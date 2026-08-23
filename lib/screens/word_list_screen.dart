import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_state.dart';
import '../models/word.dart';
import '../utils/learning_direction.dart';
import '../utils/review_repository.dart';
import '../utils/word_search.dart';
import '../utils/word_sort.dart';
import '../widgets/category_filter.dart';
import '../widgets/word_card.dart';
import 'word_detail_screen.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key, required this.direction});

  final LearningDirection direction;

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  String _selectedCategory = CategoryFilter.allCategoryLabel;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final words = _filterWords(appState.words);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Tìm kiếm',
              hintText: 'Nhập tiếng Hàn hoặc nghĩa tiếng Việt',
              prefixIcon: Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => _searchText = value);
            },
          ),
        ),
        CategoryFilter(
          categories: appState.categories,
          selectedCategory: _selectedCategory,
          onChanged: (category) {
            setState(() => _selectedCategory = category);
          },
        ),
        Expanded(
          child: words.isEmpty
              ? const _EmptyState(
                  icon: Icons.search_off,
                  message: 'Không tìm thấy nội dung phù hợp.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];

                    return WordCard(
                      word: word,
                      direction: widget.direction,
                      onTap: () => _openDetail(context, word),
                    );
                  },
                ),
        ),
      ],
    );
  }

  List<Word> _filterWords(List<Word> words) {
    final query = _searchText.trim();

    final filteredWords = words.where((word) {
      final matchesCategory =
          _selectedCategory == CategoryFilter.allCategoryLabel ||
          word.belongsToCategory(_selectedCategory);

      return matchesCategory && wordMatchesSearch(word, query);
    }).toList();

    return sortWordsByKorean(filteredWords);
  }

  Future<void> _openDetail(BuildContext context, Word word) async {
    final preferences = await SharedPreferences.getInstance();
    await ReviewRepository(preferences).addRecentWord(word);

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            WordDetailScreen(word: word, direction: widget.direction),
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
