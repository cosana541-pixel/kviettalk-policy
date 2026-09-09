import 'package:flutter/material.dart';

class HangulQuizQuestionCard extends StatelessWidget {
  const HangulQuizQuestionCard({
    super.key,
    required this.prompt,
    required this.promptKey,
  });

  static const instruction = 'Chọn 1 đáp án đúng';

  final String prompt;
  final Key promptKey;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              instruction,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              prompt,
              key: promptKey,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
