import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/word.dart';
import '../services/tts_service.dart';
import '../utils/category_labels.dart';
import '../utils/learning_direction.dart';

class WordDetailScreen extends StatelessWidget {
  const WordDetailScreen({
    super.key,
    required this.word,
    required this.direction,
  });

  final Word word;
  final LearningDirection direction;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final ttsService = context.read<TtsService>();
    final isFavorite = appState.isFavorite(word);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết từ'),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Bỏ yêu thích' : 'Thêm yêu thích',
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
            color: isFavorite ? Colors.amber.shade700 : null,
            onPressed: () => appState.toggleFavorite(word),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    label: 'Tiếng Hàn',
                    value: word.korean,
                    emphasize: true,
                  ),
                  _InfoRow(label: 'Nghĩa tiếng Việt', value: word.vietnamese),
                  _InfoRow(
                    label: 'Cách đọc tiếng Hàn',
                    value: word.koreanPronunciation,
                  ),
                  _InfoRow(
                    label: 'Chủ đề',
                    value: categoryLabelVi(word.category),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(Icons.volume_up),
            label: const Text('Nghe phát âm tiếng Hàn'),
            onPressed: () => ttsService.speakKorean(word.korean),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 5),
          Text(
            value,
            style: emphasize
                ? Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
