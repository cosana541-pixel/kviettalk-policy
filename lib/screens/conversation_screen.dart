import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/conversation_item.dart';
import '../services/conversation_service.dart';
import '../services/favorite_service.dart';
import '../services/tts_service.dart';
import '../utils/category_labels.dart';
import '../widgets/illustration_placeholder.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  static const String _allCategory = 'all';
  static const String _favoriteCategory = 'favorite';

  final ConversationService _conversationService = ConversationService();
  final FavoriteService _favoriteService = FavoriteService();

  late final Future<List<ConversationItem>> _conversationsFuture;
  Set<String> _favoriteIds = <String>{};
  String _selectedCategory = _allCategory;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _conversationsFuture = _conversationService.loadConversations();
    _loadFavoriteIds();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ConversationItem>>(
      future: _conversationsFuture,
      builder: (context, snapshot) {
        final conversations = snapshot.data ?? <ConversationItem>[];

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredConversations = _filterConversations(conversations);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Tìm hội thoại',
                  hintText: 'Tìm theo chủ đề hoặc câu nói',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => _searchText = value);
                },
              ),
            ),
            _ConversationCategoryFilter(
              categories: _categories(conversations),
              selectedCategory: _selectedCategory,
              onChanged: (category) {
                setState(() => _selectedCategory = category);
              },
            ),
            Expanded(
              child: filteredConversations.isEmpty
                  ? _EmptyState(
                      icon: Icons.search_off,
                      message: _emptyMessage(),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: filteredConversations.length,
                      itemBuilder: (context, index) {
                        final conversation = filteredConversations[index];

                        return _ConversationCard(
                          conversation: conversation,
                          isFavorite: _favoriteIds.contains(conversation.id),
                          onToggleFavorite: () => _toggleFavorite(conversation),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  List<String> _categories(List<ConversationItem> conversations) {
    final values = conversations
        .map((conversation) => conversation.category)
        .toSet()
        .toList();
    values.sort();
    return values;
  }

  List<ConversationItem> _filterConversations(
    List<ConversationItem> conversations,
  ) {
    final query = _searchText.trim().toLowerCase();

    return conversations.where((conversation) {
      final matchesCategory =
          _selectedCategory == _allCategory ||
          (_selectedCategory == _favoriteCategory &&
              _favoriteIds.contains(conversation.id)) ||
          conversation.category == _selectedCategory;
      final matchesSearch =
          query.isEmpty ||
          conversation.titleKo.toLowerCase().contains(query) ||
          conversation.titleVi.toLowerCase().contains(query) ||
          conversation.lines.any(
            (line) =>
                line.ko.toLowerCase().contains(query) ||
                line.vi.toLowerCase().contains(query) ||
                line.viPronunciationHint.toLowerCase().contains(query),
          );

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _loadFavoriteIds() async {
    final ids = await _favoriteService.loadConversationFavoriteIds();

    if (!mounted) {
      return;
    }

    setState(() => _favoriteIds = ids);
  }

  Future<void> _toggleFavorite(ConversationItem conversation) async {
    final nextIds = Set<String>.from(_favoriteIds);

    if (nextIds.contains(conversation.id)) {
      nextIds.remove(conversation.id);
    } else {
      nextIds.add(conversation.id);
    }

    setState(() => _favoriteIds = nextIds);
    await _favoriteService.saveConversationFavoriteIds(nextIds);
  }

  String _emptyMessage() {
    if (_selectedCategory == _favoriteCategory) {
      return 'Chưa có hội thoại yêu thích.';
    }

    return 'Không tìm thấy hội thoại phù hợp.';
  }
}

class _ConversationCategoryFilter extends StatelessWidget {
  const _ConversationCategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final allCategories = <String>['all', 'favorite', ...categories];

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

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({
    required this.conversation,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final ConversationItem conversation;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IllustrationPlaceholder(
                  icon: _conversationIcon(conversation.category),
                  assetPath: _conversationAsset(conversation.category),
                  size: 38,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.titleVi,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite ? 'Bỏ yêu thích' : 'Thêm yêu thích',
                  icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                  color: isFavorite ? Colors.amber.shade700 : null,
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...conversation.lines.map((line) {
              return _ConversationLineTile(line: line);
            }),
          ],
        ),
      ),
    );
  }

  IconData _conversationIcon(String category) {
    switch (category) {
      case 'restaurant':
      case 'food':
      case '음식':
        return Icons.restaurant_outlined;
      case 'shopping':
      case '쇼핑':
        return Icons.shopping_bag_outlined;
      case 'travel':
      case '여행':
        return Icons.luggage_outlined;
      case 'transport':
      case '교통':
        return Icons.directions_bus_outlined;
      case 'hospital':
      case '병원':
        return Icons.local_hospital_outlined;
      case 'emergency':
      case '긴급':
        return Icons.emergency_outlined;
      default:
        return Icons.forum_outlined;
    }
  }

  String? _conversationAsset(String category) {
    switch (category) {
      case 'restaurant':
      case 'food':
      case '음식':
        return 'assets/images/conversation/restaurant.png';
      case 'cafe':
      case '카페':
        return 'assets/images/conversation/cafe.png';
      case 'hospital':
      case '병원':
        return 'assets/images/conversation/hospital_conversation.png';
      case 'transport':
      case 'subway':
      case '교통':
        return 'assets/images/conversation/subway.png';
      default:
        return null;
    }
  }
}

class _ConversationLineTile extends StatelessWidget {
  const _ConversationLineTile({required this.line});

  final ConversationLine line;

  @override
  Widget build(BuildContext context) {
    final ttsService = context.read<TtsService>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${line.speaker}. ${line.ko}',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('${line.speaker}. ${line.vi}'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
            ),
            icon: const Icon(Icons.volume_up),
            label: const Text('Nghe phát âm tiếng Hàn'),
            onPressed: () => ttsService.speakKorean(line.ko),
          ),
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
