import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/word.dart';
import '../utils/learning_direction.dart';
import '../widgets/word_card.dart';
import 'word_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.direction});

  final LearningDirection direction;

  @override
  Widget build(BuildContext context) {
    final words = context.watch<AppState>().favoriteWords;

    if (words.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_border, size: 40),
              SizedBox(height: 12),
              Text(
                'Chưa có từ yêu thích.\nNhấn biểu tượng ngôi sao để lưu từ cần ôn lại.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];

        return WordCard(
          word: word,
          direction: direction,
          onTap: () => _openDetail(context, word),
        );
      },
    );
  }

  void _openDetail(BuildContext context, Word word) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WordDetailScreen(word: word, direction: direction),
      ),
    );
  }
}
