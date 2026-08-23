import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_state.dart';
import '../models/word.dart';
import '../utils/learning_direction.dart';
import '../utils/learning_progress_tracker.dart';
import '../utils/review_repository.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.direction, this.onQuizAnswered});

  final LearningDirection direction;
  final VoidCallback? onQuizAnswered;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Random _random = Random();

  Word? _question;
  List<Word> _options = <Word>[];
  Word? _selectedAnswer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_question == null) {
      _makeQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = context.watch<AppState>().words;

    if (words.length < 4) {
      return const _EmptyState(
        icon: Icons.quiz_outlined,
        message: 'Không đủ từ để tạo câu đố.',
      );
    }

    final question = _question;
    if (question == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isAnswered = _selectedAnswer != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Câu hỏi', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Text(
                  'Chọn đáp án đúng',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  question.vietnamese,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Từ này trong tiếng Hàn là gì?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._options.map((option) {
          final isSelected = _selectedAnswer?.id == option.id;
          final isCorrect = question.id == option.id;

          Color? tileColor;
          if (isAnswered && isCorrect) {
            tileColor = Colors.green.shade100;
          } else if (isAnswered && isSelected && !isCorrect) {
            tileColor = Colors.red.shade100;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: tileColor,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                option.korean,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: isAnswered && isCorrect
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: isAnswered ? null : () => _selectAnswer(option),
            ),
          );
        }),
        const SizedBox(height: 16),
        if (isAnswered)
          Text(
            _selectedAnswer?.id == question.id
                ? 'Chính xác!'
                : 'Tiếc quá. Hãy thử lại.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        const SizedBox(height: 12),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          icon: const Icon(Icons.refresh),
          label: const Text('Câu tiếp theo'),
          onPressed: _makeQuestion,
        ),
      ],
    );
  }

  void _makeQuestion() {
    final words = context.read<AppState>().words;
    if (words.length < 4) {
      return;
    }

    final question = words[_random.nextInt(words.length)];
    final wrongOptions = _wrongOptionsFor(question, words);

    final options = <Word>[question, ...wrongOptions.take(3)]..shuffle(_random);

    setState(() {
      _question = question;
      _options = options;
      _selectedAnswer = null;
    });
  }

  List<Word> _wrongOptionsFor(Word question, List<Word> words) {
    final selectedIds = <String>{question.id};
    final categoryOptions =
        words
            .where(
              (word) =>
                  word.id != question.id &&
                  word.categories.any(question.belongsToCategory),
            )
            .toList()
          ..shuffle(_random);
    final allOptions = words.where((word) => word.id != question.id).toList()
      ..shuffle(_random);
    final wrongOptions = <Word>[];

    void addOption(Word word) {
      if (selectedIds.add(word.id)) {
        wrongOptions.add(word);
      }
    }

    for (final word in categoryOptions) {
      if (wrongOptions.length == 3) {
        return wrongOptions;
      }
      addOption(word);
    }

    for (final word in allOptions) {
      if (wrongOptions.length == 3) {
        return wrongOptions;
      }
      addOption(word);
    }

    return wrongOptions;
  }

  Future<void> _selectAnswer(Word option) async {
    if (_selectedAnswer != null) {
      return;
    }

    setState(() => _selectedAnswer = option);

    final preferences = await SharedPreferences.getInstance();
    await LearningProgressTracker(preferences).recordActivity();
    final reviewRepository = ReviewRepository(preferences);
    if (option.id == _question?.id) {
      await reviewRepository.removeWrongQuizWord(option);
    } else {
      await reviewRepository.addWrongQuizWord(_question!);
    }
    widget.onQuizAnswered?.call();
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
