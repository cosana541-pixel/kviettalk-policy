import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_state.dart';
import '../models/word.dart';
import '../utils/learning_stats_keys.dart';

class WritingPracticeScreen extends StatefulWidget {
  const WritingPracticeScreen({super.key, this.onPracticeResultChanged});

  final VoidCallback? onPracticeResultChanged;

  @override
  State<WritingPracticeScreen> createState() => _WritingPracticeScreenState();
}

class _WritingPracticeScreenState extends State<WritingPracticeScreen> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();

  Word? _question;
  bool? _isCorrect;
  bool _showAnswer = false;
  bool _hasCheckedCurrentQuestion = false;
  bool _retryWrongOnly = false;
  int _totalCount = 0;
  int _correctCount = 0;
  Set<String> _wrongIds = <String>{};

  int get _wrongCount => _totalCount - _correctCount;
  int get _accuracy =>
      _totalCount == 0 ? 0 : ((_correctCount / _totalCount) * 100).round();
  bool get _hasPracticeResult => _totalCount > 0 || _wrongIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadPracticeResult();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_question == null) {
      _makeQuestion();
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = context.watch<AppState>().words;
    final wrongWords = _wrongWordsFrom(words);

    if (words.isEmpty) {
      return const _EmptyState(
        icon: Icons.edit_note,
        message: 'Chưa có từ để luyện viết.',
      );
    }

    final question = _question;
    if (question == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _WritingPromptCard(
          question: question,
          accuracy: _accuracy,
          wrongWordCount: wrongWords.length,
        ),
        const SizedBox(height: 12),
        _ResultSummary(
          totalCount: _totalCount,
          correctCount: _correctCount,
          wrongCount: _wrongCount,
          accuracy: _accuracy,
        ),
        const SizedBox(height: 12),
        FilledButton.tonalIcon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          icon: const Icon(Icons.replay),
          label: Text(
            wrongWords.isEmpty
                ? 'Không có từ sai'
                : 'Luyện lại từ sai (${wrongWords.length})',
          ),
          onPressed: wrongWords.isEmpty
              ? null
              : () {
                  setState(() => _retryWrongOnly = true);
                  _makeQuestion();
                },
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Đặt lại thống kê'),
          onPressed: _hasPracticeResult
              ? () {
                  _resetPracticeResult();
                }
              : null,
        ),
        const SizedBox(height: 14),
        if (_retryWrongOnly)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              wrongWords.isEmpty
                  ? 'Đã hết từ sai. Tiếp tục luyện tất cả từ.'
                  : 'Đang luyện lại từ đã sai.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        TextField(
          controller: _answerController,
          decoration: const InputDecoration(
            labelText: 'Đáp án tiếng Hàn',
            hintText: 'Ví dụ: 안녕하세요',
            prefixIcon: Icon(Icons.keyboard),
            border: OutlineInputBorder(),
            filled: true,
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _checkAnswer(question),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          icon: const Icon(Icons.check),
          label: const Text('Kiểm tra'),
          onPressed: () => _checkAnswer(question),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          icon: const Icon(Icons.visibility),
          label: const Text('Xem đáp án'),
          onPressed: () {
            setState(() => _showAnswer = true);
          },
        ),
        const SizedBox(height: 12),
        if (_isCorrect != null || _showAnswer)
          _FeedbackPanel(
            isCorrect: _isCorrect,
            showAnswer: _showAnswer,
            answer: question.korean,
          ),
        const SizedBox(height: 12),
        FilledButton.tonalIcon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          icon: const Icon(Icons.navigate_next),
          label: const Text('Câu tiếp theo'),
          onPressed: _makeQuestion,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          icon: const Icon(Icons.list_alt),
          label: Text(
            wrongWords.isEmpty
                ? 'Không có danh sách từ sai'
                : 'Xem từ sai (${wrongWords.length})',
          ),
          onPressed: wrongWords.isEmpty
              ? null
              : () => _showWrongWords(context, wrongWords),
        ),
      ],
    );
  }

  Future<void> _checkAnswer(Word question) async {
    final isCorrect = _isAnswerCorrect(_answerController.text, question.korean);
    var countedNewQuestion = false;

    setState(() {
      _isCorrect = isCorrect;
      _showAnswer = false;

      if (!_hasCheckedCurrentQuestion) {
        _totalCount += 1;
        if (isCorrect) {
          _correctCount += 1;
        }
        _hasCheckedCurrentQuestion = true;
        countedNewQuestion = true;
      }

      if (isCorrect) {
        _wrongIds.remove(question.id);
      } else {
        _wrongIds.add(question.id);
      }
    });

    if (countedNewQuestion) {
      await _recordTodayLearningActivity();
    }
    await _savePracticeResult();
    widget.onPracticeResultChanged?.call();
  }

  void _makeQuestion() {
    final allWords = context.read<AppState>().words;
    final wrongWords = _wrongWordsFrom(allWords);
    final words = _retryWrongOnly && wrongWords.isNotEmpty
        ? wrongWords
        : allWords;

    if (words.isEmpty) {
      return;
    }

    setState(() {
      if (_retryWrongOnly && wrongWords.isEmpty) {
        _retryWrongOnly = false;
      }
      _question = words[_random.nextInt(words.length)];
      _answerController.clear();
      _isCorrect = null;
      _showAnswer = false;
      _hasCheckedCurrentQuestion = false;
    });
  }

  List<Word> _wrongWordsFrom(List<Word> words) {
    return words.where((word) => _wrongIds.contains(word.id)).toList();
  }

  bool _isAnswerCorrect(String userAnswer, String answer) {
    return _normalize(userAnswer) == _normalize(answer);
  }

  String _normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase();
  }

  Future<void> _loadPracticeResult() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }

    setState(() {
      _totalCount = preferences.getInt(LearningStatsKeys.writingTotal) ?? 0;
      _correctCount = preferences.getInt(LearningStatsKeys.writingCorrect) ?? 0;
      _wrongIds =
          preferences
              .getStringList(LearningStatsKeys.writingWrongIds)
              ?.toSet() ??
          <String>{};
    });
  }

  Future<void> _savePracticeResult() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(LearningStatsKeys.writingTotal, _totalCount);
    await preferences.setInt(LearningStatsKeys.writingCorrect, _correctCount);
    await preferences.setStringList(
      LearningStatsKeys.writingWrongIds,
      _wrongIds.toList()..sort(),
    );
  }

  Future<void> _recordTodayLearningActivity() async {
    final preferences = await SharedPreferences.getInstance();
    final today = _todayKey();
    final savedDate = preferences.getString(LearningStatsKeys.todayDate);
    final currentCount = savedDate == today
        ? preferences.getInt(LearningStatsKeys.todayCount) ?? 0
        : 0;

    await preferences.setString(LearningStatsKeys.todayDate, today);
    await preferences.setInt(LearningStatsKeys.todayCount, currentCount + 1);

    if (savedDate != today) {
      final streakLastDate = preferences.getString(
        LearningStatsKeys.streakLastDate,
      );
      final currentStreak =
          preferences.getInt(LearningStatsKeys.streakCount) ?? 0;
      final nextStreak = streakLastDate == _yesterdayKey()
          ? currentStreak + 1
          : 1;

      await preferences.setInt(LearningStatsKeys.streakCount, nextStreak);
      await preferences.setString(LearningStatsKeys.streakLastDate, today);
    }
  }

  Future<void> _resetPracticeResult() async {
    setState(() {
      _totalCount = 0;
      _correctCount = 0;
      _wrongIds = <String>{};
      _retryWrongOnly = false;
      _isCorrect = null;
      _showAnswer = false;
      _hasCheckedCurrentQuestion = false;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(LearningStatsKeys.writingTotal);
    await preferences.remove(LearningStatsKeys.writingCorrect);
    await preferences.remove(LearningStatsKeys.writingWrongIds);
    widget.onPracticeResultChanged?.call();
  }

  String _todayKey() {
    final now = DateTime.now();
    return _dateKey(now);
  }

  String _yesterdayKey() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _dateKey(yesterday);
  }

  String _dateKey(DateTime date) {
    final now = date;
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  void _showWrongWords(BuildContext context, List<Word> wrongWords) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: wrongWords.length + 1,
            separatorBuilder: (_, index) =>
                index == 0 ? const SizedBox.shrink() : const Divider(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Từ đã sai',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              final word = wrongWords[index - 1];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(word.korean),
                subtitle: Text(word.vietnamese),
              );
            },
          ),
        );
      },
    );
  }
}

class _WritingPromptCard extends StatelessWidget {
  const _WritingPromptCard({
    required this.question,
    required this.accuracy,
    required this.wrongWordCount,
  });

  final Word question;
  final int accuracy;
  final int wrongWordCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note, color: colorScheme.onSecondaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Luyện viết',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Mới',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              question.vietnamese,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'Nhập từ tiếng Hàn phù hợp.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PromptStat(label: 'Đúng', value: '$accuracy%'),
                _PromptStat(label: 'Từ sai', value: wrongWordCount.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptStat extends StatelessWidget {
  const _PromptStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label $value',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({
    required this.totalCount,
    required this.correctCount,
    required this.wrongCount,
    required this.accuracy,
  });

  final int totalCount;
  final int correctCount;
  final int wrongCount;
  final int accuracy;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _ResultItem(label: 'Tổng', value: totalCount.toString()),
            _ResultItem(label: 'Đúng', value: correctCount.toString()),
            _ResultItem(label: 'Sai', value: wrongCount.toString()),
            _ResultItem(label: 'Tỷ lệ', value: '$accuracy%'),
          ],
        ),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  const _ResultItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  const _FeedbackPanel({
    required this.isCorrect,
    required this.showAnswer,
    required this.answer,
  });

  final bool? isCorrect;
  final bool showAnswer;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWrong = isCorrect == false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect == true
            ? Colors.green.shade100
            : isWrong
            ? Colors.red.shade100
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCorrect != null)
            Text(
              isCorrect == true ? 'Chính xác!' : 'Chưa đúng.',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          if (showAnswer || isWrong) ...[
            if (isCorrect != null) const SizedBox(height: 6),
            Text('Đáp án: $answer'),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
