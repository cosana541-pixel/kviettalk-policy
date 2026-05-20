import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/word.dart';
import '../utils/category_labels.dart';
import '../utils/learning_direction.dart';

// 단어 목록과 즐겨찾기 목록에서 함께 쓰는 카드입니다.
class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.word,
    required this.direction,
    required this.onTap,
  });

  final Word word;
  final LearningDirection direction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isFavorite = appState.isFavorite(word);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        onTap: onTap,
        title: Text(
          word.korean,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                word.vietnamese,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                categoryLabelVi(word.category),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        trailing: IconButton(
          tooltip: isFavorite ? 'Bỏ yêu thích' : 'Thêm yêu thích',
          icon: Icon(isFavorite ? Icons.star : Icons.star_border),
          color: isFavorite ? Colors.amber.shade700 : null,
          onPressed: () => appState.toggleFavorite(word),
        ),
      ),
    );
  }
}
