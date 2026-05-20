import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sentence_item.dart';
import '../services/sentence_service.dart';
import '../services/tts_service.dart';
import '../utils/category_labels.dart';
import '../utils/learning_direction.dart';

class SentenceListScreen extends StatefulWidget {
  const SentenceListScreen({super.key, required this.direction});

  final LearningDirection direction;

  @override
  State<SentenceListScreen> createState() => _SentenceListScreenState();
}

class _SentenceListScreenState extends State<SentenceListScreen> {
  static const String _allCategory = 'all';

  final SentenceService _sentenceService = SentenceService();

  List<SentenceItem> _sentences = <SentenceItem>[];
  String _selectedCategory = _allCategory;
  String _searchText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSentences();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSentences = _filterSentences();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Tìm câu',
              hintText: 'Tìm bằng tiếng Hàn hoặc tiếng Việt',
              prefixIcon: Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => _searchText = value);
            },
          ),
        ),
        _SentenceCategoryFilter(
          categories: _categories,
          selectedCategory: _selectedCategory,
          onChanged: (category) {
            setState(() => _selectedCategory = category);
          },
        ),
        Expanded(
          child: filteredSentences.isEmpty
              ? const _EmptyState(
                  icon: Icons.search_off,
                  message: 'Không tìm thấy câu phù hợp.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: filteredSentences.length,
                  itemBuilder: (context, index) {
                    return _SentenceCard(sentence: filteredSentences[index]);
                  },
                ),
        ),
      ],
    );
  }

  List<String> get _categories {
    final values = _sentences
        .map((sentence) => sentence.category)
        .toSet()
        .toList();
    values.sort();
    return values;
  }

  Future<void> _loadSentences() async {
    try {
      final sentences = await _sentenceService.loadSentences();

      if (!mounted) {
        return;
      }

      setState(() {
        _sentences = sentences;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _sentences = <SentenceItem>[];
        _isLoading = false;
      });
    }
  }

  List<SentenceItem> _filterSentences() {
    final query = _searchText.trim().toLowerCase();

    return _sentences.where((sentence) {
      final matchesCategory =
          _selectedCategory == _allCategory ||
          sentence.category == _selectedCategory;
      final matchesSearch =
          query.isEmpty ||
          sentence.ko.toLowerCase().contains(query) ||
          sentence.vi.toLowerCase().contains(query) ||
          sentence.viPronunciationHint.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }
}

class _SentenceCategoryFilter extends StatelessWidget {
  const _SentenceCategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final allCategories = <String>['all', ...categories];

    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = allCategories[index];

          return ChoiceChip(
            label: Text(categoryLabelVi(category)),
            selected: selectedCategory == category,
            showCheckmark: false,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            onSelected: (_) => onChanged(category),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: allCategories.length,
      ),
    );
  }
}

class _SentenceCard extends StatelessWidget {
  const _SentenceCard({required this.sentence});

  final SentenceItem sentence;

  @override
  Widget build(BuildContext context) {
    final ttsService = context.read<TtsService>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sentence.ko,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(sentence.vi),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              icon: const Icon(Icons.volume_up),
              label: const Text('Nghe phát âm tiếng Hàn'),
              onPressed: () => ttsService.speakKorean(sentence.ko),
            ),
          ],
        ),
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
