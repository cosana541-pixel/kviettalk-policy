import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_state.dart';
import '../models/word.dart';
import '../utils/learning_stats_keys.dart';
import '../utils/learning_direction.dart';
import 'conversation_screen.dart';
import 'favorites_screen.dart';
import 'quiz_screen.dart';
import 'sentence_list_screen.dart';
import 'word_list_screen.dart';
import 'writing_practice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _writingTotalCount = 0;
  int _writingCorrectCount = 0;
  int _writingWrongCount = 0;
  int _todayLearningCount = 0;
  int _streakCount = 0;
  int _dailyGoal = 10;

  int get _writingAccuracy => _writingTotalCount == 0
      ? 0
      : ((_writingCorrectCount / _writingTotalCount) * 100).round();

  @override
  void initState() {
    super.initState();
    _loadLearningStats();
  }

  @override
  Widget build(BuildContext context) {
    final direction = context.watch<AppState>().direction;
    final isLoading = context.watch<AppState>().isLoading;
    final words = context.watch<AppState>().words;
    final favoriteCount = context.watch<AppState>().favoriteWords.length;

    final activeDirection = direction ?? LearningDirection.vietnameseToKorean;

    final screens = [
      WordListScreen(direction: activeDirection),
      SentenceListScreen(direction: activeDirection),
      const ConversationScreen(),
      QuizScreen(direction: activeDirection),
      WritingPracticeScreen(onPracticeResultChanged: _loadLearningStats),
      FavoritesScreen(direction: activeDirection),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _HomeHeader(
              isLoading: isLoading,
              selectedIndex: _selectedIndex,
              writingAccuracy: _writingAccuracy,
              writingWrongCount: _writingWrongCount,
              todayLearningCount: _todayLearningCount,
              streakCount: _streakCount,
              dailyGoal: _dailyGoal,
              words: words,
              favoriteCount: favoriteCount,
              onMenuTap: (index) {
                setState(() => _selectedIndex = index);
                _loadLearningStats();
              },
            ),
            Expanded(
              child: isLoading
                  ? const _LoadingLessonState()
                  : screens[_selectedIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          _loadLearningStats();
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Từ vựng'),
          NavigationDestination(icon: Icon(Icons.article), label: 'Câu'),
          NavigationDestination(icon: Icon(Icons.forum), label: 'Hội thoại'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'Câu đố'),
          NavigationDestination(icon: Icon(Icons.edit_note), label: 'Viết'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Yêu thích'),
        ],
      ),
    );
  }

  Future<void> _loadLearningStats() async {
    final preferences = await SharedPreferences.getInstance();
    final today = _todayKey();
    final savedDate = preferences.getString(LearningStatsKeys.todayDate);
    if (!mounted) {
      return;
    }

    setState(() {
      _writingTotalCount =
          preferences.getInt(LearningStatsKeys.writingTotal) ?? 0;
      _writingCorrectCount =
          preferences.getInt(LearningStatsKeys.writingCorrect) ?? 0;
      _writingWrongCount =
          preferences
              .getStringList(LearningStatsKeys.writingWrongIds)
              ?.length ??
          0;
      _todayLearningCount = savedDate == today
          ? preferences.getInt(LearningStatsKeys.todayCount) ?? 0
          : 0;
      _streakCount = _activeStreakCount(
        preferences.getInt(LearningStatsKeys.streakCount) ?? 0,
        preferences.getString(LearningStatsKeys.streakLastDate),
        today,
      );
      _dailyGoal = preferences.getInt(LearningStatsKeys.dailyGoal) ?? 10;
    });
  }

  int _activeStreakCount(int savedCount, String? lastDate, String today) {
    if (savedCount <= 0 || lastDate == null) {
      return 0;
    }

    if (lastDate == today || lastDate == _yesterdayKey()) {
      return savedCount;
    }

    return 0;
  }

  String _todayKey() {
    final now = DateTime.now();
    return _dateKey(now);
  }

  String _yesterdayKey() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _dateKey(yesterday);
  }

  String _dateKey(DateTime date) {
    final now = date;
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
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
    required this.writingAccuracy,
    required this.writingWrongCount,
    required this.todayLearningCount,
    required this.streakCount,
    required this.dailyGoal,
    required this.words,
    required this.favoriteCount,
    required this.onMenuTap,
  });

  final bool isLoading;
  final int selectedIndex;
  final int writingAccuracy;
  final int writingWrongCount;
  final int todayLearningCount;
  final int streakCount;
  final int dailyGoal;
  final List<Word> words;
  final int favoriteCount;
  final ValueChanged<int> onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomePanel(isLoading: isLoading),
            const SizedBox(height: 8),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _PrimaryShortcutCard(
                    icon: Icons.menu_book,
                    title: 'Từ vựng',
                    description: 'Học từ mới mỗi ngày',
                    isSelected: selectedIndex == 0,
                    onTap: () => onMenuTap(0),
                  ),
                  _PrimaryShortcutCard(
                    icon: Icons.edit_note,
                    title: 'Luyện viết',
                    description:
                        'Đúng $writingAccuracy% · Sai $writingWrongCount',
                    isSelected: selectedIndex == 4,
                    isHighlighted: true,
                    onTap: () => onMenuTap(4),
                  ),
                  _PrimaryShortcutCard(
                    icon: Icons.quiz,
                    title: 'Câu đố',
                    description: 'Chọn đáp án tiếng Hàn',
                    isSelected: selectedIndex == 3,
                    onTap: () => onMenuTap(3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 118,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _TodayLearningCard(
                    count: todayLearningCount,
                    streakCount: streakCount,
                    dailyGoal: dailyGoal,
                  ),
                  _ProgressOverviewCard(
                    totalWordCount: words.length,
                    imageWordCount: words
                        .where((word) => word.image != null)
                        .length,
                    favoriteCount: favoriteCount,
                    writingAccuracy: writingAccuracy,
                    wrongWordCount: writingWrongCount,
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

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.school, color: colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'K-Viet Talk',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isLoading
                      ? 'Đang chuẩn bị bài học...'
                      : 'Ứng dụng học tiếng Hàn cho người Việt',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryShortcutCard extends StatelessWidget {
  const _PrimaryShortcutCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    this.isHighlighted = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = isSelected || isHighlighted
        ? colorScheme.secondaryContainer
        : colorScheme.surfaceContainerHighest;
    final foregroundColor = isSelected || isHighlighted
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;

    return SizedBox(
      width: 184,
      child: Card(
        margin: const EdgeInsets.only(right: 10),
        color: backgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: foregroundColor),
                    const Spacer(),
                    if (isHighlighted)
                      Text(
                        'Mới',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: foregroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: foregroundColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: foregroundColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TodayLearningCard extends StatelessWidget {
  const _TodayLearningCard({
    required this.count,
    required this.streakCount,
    required this.dailyGoal,
  });

  final int count;
  final int streakCount;
  final int dailyGoal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveGoal = dailyGoal <= 0 ? 10 : dailyGoal;
    final progress = (count / effectiveGoal).clamp(0.0, 1.0);
    final isGoalDone = count >= effectiveGoal;

    return SizedBox(
      width: 252,
      child: Card(
        margin: const EdgeInsets.only(right: 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.today, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Học hôm nay',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                count == 0
                    ? 'Hãy bắt đầu học hôm nay'
                    : '$count hoạt động đã học',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 5),
              Text(
                'Mục tiêu hôm nay $count/$effectiveGoal',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 5),
              Text(
                isGoalDone
                    ? 'Hoàn thành mục tiêu hôm nay!'
                    : streakCount == 0
                    ? 'Chuỗi học tập: bắt đầu hôm nay'
                    : 'Chuỗi học tập: $streakCount ngày liên tiếp',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isGoalDone
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressOverviewCard extends StatelessWidget {
  const _ProgressOverviewCard({
    required this.totalWordCount,
    required this.imageWordCount,
    required this.favoriteCount,
    required this.writingAccuracy,
    required this.wrongWordCount,
  });

  final int totalWordCount;
  final int imageWordCount;
  final int favoriteCount;
  final int writingAccuracy;
  final int wrongWordCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 360,
      child: Card(
        color: colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiến độ học tập',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _ProgressChip(label: 'Từ', value: totalWordCount.toString()),
                  _ProgressChip(label: 'Ảnh', value: imageWordCount.toString()),
                  _ProgressChip(
                    label: 'Yêu thích',
                    value: favoriteCount.toString(),
                  ),
                  _ProgressChip(label: 'Đúng', value: '$writingAccuracy%'),
                  _ProgressChip(label: 'Sai', value: wrongWordCount.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressChip extends StatelessWidget {
  const _ProgressChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label $value',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
