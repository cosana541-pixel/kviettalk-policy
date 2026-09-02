import 'package:flutter/material.dart';

import '../data/hangul_liaison_quiz.dart';
import '../models/hangul_quiz_question.dart';

class HangulLiaisonQuizScreen extends StatefulWidget {
  const HangulLiaisonQuizScreen({super.key});

  @override
  State<HangulLiaisonQuizScreen> createState() =>
      _HangulLiaisonQuizScreenState();
}

class _HangulLiaisonQuizScreenState extends State<HangulLiaisonQuizScreen> {
  int _questionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isComplete = false;

  HangulQuizQuestion get _question =>
      hangulLiaisonQuizQuestions[_questionIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz nối âm (연음)')),
      body: SafeArea(
        child: _isComplete ? _buildResult(context) : _buildQuestion(context),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAnswered = _selectedAnswer != null;
    return ListView(
      key: const Key('liaison-quiz-question'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: (_questionIndex + 1) / hangulLiaisonQuizQuestions.length,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${_questionIndex + 1}/${hangulLiaisonQuizQuestions.length}',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chọn 1 đáp án đúng',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: colorScheme.primary),
                ),
                const SizedBox(height: 12),
                Text(
                  _question.prompt,
                  key: const Key('liaison-quiz-prompt'),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        for (final option in _question.options)
          _LiaisonAnswerCard(
            option: option,
            correctAnswer: _question.correctAnswer,
            selectedAnswer: _selectedAnswer,
            onTap: () => _selectAnswer(option),
          ),
        if (isAnswered) ...[
          const SizedBox(height: 8),
          Card(
            color: _selectedAnswer == _question.correctAnswer
                ? Colors.green.shade50
                : Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedAnswer == _question.correctAnswer
                        ? 'Chính xác!'
                        : 'Chưa đúng',
                    key: const Key('liaison-quiz-feedback'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _selectedAnswer == _question.correctAnswer
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(_question.explanation),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            key: const Key('next-liaison-question'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: _nextQuestion,
            child: Text(
              _questionIndex == hangulLiaisonQuizQuestions.length - 1
                  ? 'Xem kết quả'
                  : 'Câu tiếp theo',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      key: const Key('liaison-quiz-result'),
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 24),
      children: [
        Icon(Icons.emoji_events, size: 72, color: colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          'Bạn đã hoàn thành!',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '$_score/${hangulLiaisonQuizQuestions.length} câu đúng',
          key: const Key('liaison-quiz-score'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          key: const Key('retry-liaison-quiz'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          onPressed: _restart,
          icon: const Icon(Icons.refresh),
          label: const Text('Làm lại'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          key: const Key('back-to-liaison-learning'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.menu_book),
          label: const Text('Quay lại bài học nối âm'),
        ),
      ],
    );
  }

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null) return;
    setState(() {
      _selectedAnswer = answer;
      if (answer == _question.correctAnswer) _score++;
    });
  }

  void _nextQuestion() {
    if (_selectedAnswer == null) return;
    setState(() {
      if (_questionIndex == hangulLiaisonQuizQuestions.length - 1) {
        _isComplete = true;
      } else {
        _questionIndex++;
        _selectedAnswer = null;
      }
    });
  }

  void _restart() {
    setState(() {
      _questionIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _isComplete = false;
    });
  }
}

class _LiaisonAnswerCard extends StatelessWidget {
  const _LiaisonAnswerCard({
    required this.option,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.onTap,
  });

  final String option;
  final String correctAnswer;
  final String? selectedAnswer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAnswered = selectedAnswer != null;
    final isCorrect = option == correctAnswer;
    final isSelected = option == selectedAnswer;
    Color? color;
    IconData? icon;
    if (isAnswered && isCorrect) {
      color = Colors.green.shade100;
      icon = Icons.check_circle;
    } else if (isAnswered && isSelected) {
      color = Colors.red.shade100;
      icon = Icons.cancel;
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: color,
      child: InkWell(
        key: ValueKey('liaison-option-$option'),
        borderRadius: BorderRadius.circular(8),
        onTap: isAnswered ? null : onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (icon != null) Icon(icon, color: Colors.grey.shade800),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
