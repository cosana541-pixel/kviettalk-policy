import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../utils/learning_direction.dart';
import 'conversation_screen.dart';
import 'favorites_screen.dart';
import 'quiz_screen.dart';
import 'sentence_list_screen.dart';
import 'word_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final direction = context.watch<AppState>().direction;
    final isLoading = context.watch<AppState>().isLoading;

    final activeDirection = direction ?? LearningDirection.vietnameseToKorean;

    final screens = [
      WordListScreen(direction: activeDirection),
      SentenceListScreen(direction: activeDirection),
      const ConversationScreen(),
      QuizScreen(direction: activeDirection),
      FavoritesScreen(direction: activeDirection),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('K-Viet Talk')),
      body: Column(
        children: [
          _HomeHeader(
            isLoading: isLoading,
            selectedIndex: _selectedIndex,
            onMenuTap: (index) {
              setState(() => _selectedIndex = index);
            },
          ),
          Expanded(
            child: isLoading
                ? const _LoadingLessonState()
                : screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Từ vựng'),
          NavigationDestination(icon: Icon(Icons.article), label: 'Câu'),
          NavigationDestination(icon: Icon(Icons.forum), label: 'Hội thoại'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'Câu đố'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Yêu thích'),
        ],
      ),
    );
  }
}

class _LoadingLessonState extends StatelessWidget {
  const _LoadingLessonState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải bài học...', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.isLoading,
    required this.selectedIndex,
    required this.onMenuTap,
  });

  final bool isLoading;
  final int selectedIndex;
  final ValueChanged<int> onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.school,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'K-Viet Talk',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isLoading
                              ? 'Đang chuẩn bị bài học...'
                              : 'Học tiếng Hàn dễ dàng mỗi ngày',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 116,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FeatureMenuCard(
                    icon: Icons.list,
                    title: 'Từ vựng',
                    description: 'Học từ Hàn thông dụng',
                    isSelected: selectedIndex == 0,
                    onTap: () => onMenuTap(0),
                  ),
                  _FeatureMenuCard(
                    icon: Icons.article,
                    title: 'Câu',
                    description: 'Luyện câu ngắn, dễ dùng',
                    isSelected: selectedIndex == 1,
                    onTap: () => onMenuTap(1),
                  ),
                  _FeatureMenuCard(
                    icon: Icons.forum,
                    title: 'Hội thoại',
                    description: 'Nghe và đọc theo tình huống',
                    isSelected: selectedIndex == 2,
                    onTap: () => onMenuTap(2),
                  ),
                  _FeatureMenuCard(
                    icon: Icons.quiz,
                    title: 'Câu đố',
                    description: 'Nhìn nghĩa, chọn tiếng Hàn',
                    isSelected: selectedIndex == 3,
                    onTap: () => onMenuTap(3),
                  ),
                  _FeatureMenuCard(
                    icon: Icons.star,
                    title: 'Yêu thích',
                    description: 'Ôn lại nội dung đã lưu',
                    isSelected: selectedIndex == 4,
                    onTap: () => onMenuTap(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureMenuCard extends StatelessWidget {
  const _FeatureMenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 156,
      child: Card(
        margin: const EdgeInsets.only(right: 8),
        color: isSelected ? colorScheme.secondaryContainer : null,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected ? colorScheme.onSecondaryContainer : null,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
