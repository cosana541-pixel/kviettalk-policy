import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/word.dart';
import '../utils/category_labels.dart';
import '../utils/learning_direction.dart';
import 'word_image_widget.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            children: [
              WordImageWidget(
                word: word,
                size: word.resolvedImagePath == null ? 52 : 76,
                icon: _categoryIcon(word.category),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.korean,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      word.vietnamese,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _categoryIcon(word.category),
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            categoryLabelVi(word.category),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: isFavorite ? 'Bỏ yêu thích' : 'Thêm yêu thích',
                icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                color: isFavorite ? Colors.amber.shade700 : null,
                onPressed: () => appState.toggleFavorite(word),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case '인사':
      case 'greeting':
        return Icons.waving_hand_outlined;
      case '음식':
      case 'food':
      case 'restaurant':
        return Icons.restaurant_outlined;
      case '집':
        return Icons.home_outlined;
      case '공항':
        return Icons.flight_takeoff_outlined;
      case '호텔':
        return Icons.hotel_outlined;
      case '여행':
      case 'travel':
        return Icons.luggage_outlined;
      case '교통':
      case 'transport':
        return Icons.directions_bus_outlined;
      case '쇼핑':
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case '병원':
      case 'hospital':
        return Icons.local_hospital_outlined;
      case '긴급':
      case 'emergency':
        return Icons.emergency_outlined;
      case '일':
      case '회사':
      case 'work':
        return Icons.work_outline;
      case '학교':
      case 'school':
        return Icons.school_outlined;
      default:
        return Icons.style_outlined;
    }
  }
}
