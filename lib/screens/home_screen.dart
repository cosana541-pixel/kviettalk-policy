import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_state.dart';
import '../utils/learning_progress_tracker.dart';
import '../utils/learning_stats_keys.dart';
import '../utils/learning_direction.dart';
import '../widgets/illustration_placeholder.dart';
import 'conversation_screen.dart';
import 'favorites_screen.dart';
import 'hangul_basics_screen.dart';
import 'quiz_screen.dart';
import 'review_screen.dart';
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
  int _todayLearningCount = 0;
  int _streakCount = 0;
  int _dailyGoal = 10;
  int _wrongQuizCount = 0;
  int _recentWordCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLearningStats();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFirstRunGuideIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final direction = context.watch<AppState>().direction;
    final isLoading = context.watch<AppState>().isLoading;
    final favoriteCount = context.watch<AppState>().favoriteWords.length;

    final activeDirection = direction ?? LearningDirection.vietnameseToKorean;

    final screens = [
      _HomeDashboard(
        isLoading: isLoading,
        todayLearningCount: _todayLearningCount,
        streakCount: _streakCount,
        dailyGoal: _dailyGoal,
        reviewCount: _wrongQuizCount + _recentWordCount,
        favoriteCount: favoriteCount,
        writingTotalCount: _writingTotalCount,
        onMenuTap: _selectTab,
        onHangulBasicsTap: _openHangulBasics,
        onQuizTap: () => _openQuiz(activeDirection),
        onWritingTap: _openWriting,
      ),
      WordListScreen(direction: activeDirection),
      const ConversationScreen(),
      ReviewScreen(direction: activeDirection),
      _MoreScreen(
        todayLearningCount: _todayLearningCount,
        streakCount: _streakCount,
        dailyGoal: _dailyGoal,
        writingTotalCount: _writingTotalCount,
        reviewCount: _wrongQuizCount + _recentWordCount,
        favoriteCount: favoriteCount,
        onQuizTap: () => _openQuiz(activeDirection),
        onWritingTap: _openWriting,
        onFavoritesTap: () => _openFavorites(activeDirection),
        onSentencesTap: () => _openSentences(activeDirection),
      ),
    ];

    return Scaffold(
      body: PopScope(
        canPop: _selectedIndex == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _selectedIndex != 0) {
            _selectTab(0);
          }
        },
        child: SafeArea(
          child: isLoading && _selectedIndex != 0
              ? const _LoadingLessonState()
              : screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(size: isSelected ? 25 : 23);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: isSelected ? 12 : 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            );
          }),
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _selectTab,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.list), label: 'Từ vựng'),
            NavigationDestination(icon: Icon(Icons.forum), label: 'Hội thoại'),
            NavigationDestination(icon: Icon(Icons.replay), label: 'Ôn tập'),
            NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Thêm'),
          ],
        ),
      ),
    );
  }

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
    _loadLearningStats();
  }

  Future<void> _openQuiz(LearningDirection direction) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _StandaloneLessonPage(
          title: 'Quiz',
          child: QuizScreen(
            direction: direction,
            onQuizAnswered: _loadLearningStats,
          ),
        ),
      ),
    );
    _loadLearningStats();
  }

  Future<void> _openHangulBasics() async {
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (_) => const HangulBasicsScreen()));
  }

  Future<void> _openWriting() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _StandaloneLessonPage(
          title: 'Viết',
          child: WritingPracticeScreen(
            onPracticeResultChanged: _loadLearningStats,
          ),
        ),
      ),
    );
    _loadLearningStats();
  }

  Future<void> _openFavorites(LearningDirection direction) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _StandaloneLessonPage(
          title: 'Yêu thích',
          child: FavoritesScreen(direction: direction),
        ),
      ),
    );
    _loadLearningStats();
  }

  Future<void> _openSentences(LearningDirection direction) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _StandaloneLessonPage(
          title: 'Câu',
          child: SentenceListScreen(direction: direction),
        ),
      ),
    );
    _loadLearningStats();
  }

  Future<void> _loadLearningStats() async {
    final preferences = await SharedPreferences.getInstance();
    final progress = LearningProgressTracker(preferences).load();
    if (!mounted) {
      return;
    }

    setState(() {
      _writingTotalCount =
          preferences.getInt(LearningStatsKeys.writingTotal) ?? 0;
      _todayLearningCount = progress.todayCount;
      _streakCount = progress.streakCount;
      _dailyGoal = progress.dailyGoal;
      _wrongQuizCount =
          preferences.getStringList(LearningStatsKeys.quizWrongIds)?.length ??
          0;
      _recentWordCount =
          preferences.getStringList(LearningStatsKeys.recentWordIds)?.length ??
          0;
    });
  }

  Future<void> _showFirstRunGuideIfNeeded() async {
    final preferences = await SharedPreferences.getInstance();
    final hasSeenGuide =
        preferences.getBool(LearningStatsKeys.firstRunGuideSeen) ?? false;

    if (!mounted || hasSeenGuide) {
      return;
    }

    await preferences.setBool(LearningStatsKeys.firstRunGuideSeen, true);

    if (!mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chào mừng đến K-Viet Talk'),
          content: const Text(
            'Học từ vựng, luyện viết và làm quiz mỗi ngày để giữ chuỗi học tập.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Bắt đầu học'),
            ),
          ],
        );
      },
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

class _StandaloneLessonPage extends StatelessWidget {
  const _StandaloneLessonPage({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(child: child),
    );
  }
}

class _MoreScreen extends StatelessWidget {
  const _MoreScreen({
    required this.todayLearningCount,
    required this.streakCount,
    required this.dailyGoal,
    required this.writingTotalCount,
    required this.reviewCount,
    required this.favoriteCount,
    required this.onQuizTap,
    required this.onWritingTap,
    required this.onFavoritesTap,
    required this.onSentencesTap,
  });

  final int todayLearningCount;
  final int streakCount;
  final int dailyGoal;
  final int writingTotalCount;
  final int reviewCount;
  final int favoriteCount;
  final VoidCallback onQuizTap;
  final VoidCallback onWritingTap;
  final VoidCallback onFavoritesTap;
  final VoidCallback onSentencesTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveGoal = dailyGoal <= 0 ? 10 : dailyGoal;

    return ColoredBox(
      color: colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            'Thêm',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Các bài học và tiện ích khác',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _MoreActionCard(
            icon: Icons.quiz,
            title: 'Quiz',
            description: 'Luyện chọn đáp án tiếng Hàn',
            onTap: onQuizTap,
          ),
          _MoreActionCard(
            icon: Icons.edit_note,
            title: 'Viết',
            description: 'Gõ tiếng Hàn và kiểm tra đáp án',
            onTap: onWritingTap,
          ),
          _MoreActionCard(
            icon: Icons.star,
            title: 'Yêu thích',
            description: '$favoriteCount từ đã lưu',
            onTap: onFavoritesTap,
          ),
          _MoreActionCard(
            icon: Icons.article,
            title: 'Câu',
            description: 'Ôn câu ví dụ theo chủ đề',
            onTap: onSentencesTap,
          ),
          const SizedBox(height: 10),
          Card(
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Thống kê',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatPill(
                        label: 'Hôm nay',
                        value: '$todayLearningCount/$effectiveGoal',
                      ),
                      _StatPill(label: 'Chuỗi', value: '$streakCount ngày'),
                      _StatPill(label: 'Cần ôn', value: reviewCount.toString()),
                      _StatPill(
                        label: 'Viết',
                        value: writingTotalCount.toString(),
                      ),
                      _StatPill(
                        label: 'Yêu thích',
                        value: favoriteCount.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreActionCard extends StatelessWidget {
  const _MoreActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label $value',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({
    required this.isLoading,
    required this.todayLearningCount,
    required this.streakCount,
    required this.dailyGoal,
    required this.reviewCount,
    required this.writingTotalCount,
    required this.favoriteCount,
    required this.onMenuTap,
    required this.onHangulBasicsTap,
    required this.onQuizTap,
    required this.onWritingTap,
  });

  final bool isLoading;
  final int todayLearningCount;
  final int streakCount;
  final int dailyGoal;
  final int reviewCount;
  final int writingTotalCount;
  final int favoriteCount;
  final ValueChanged<int> onMenuTap;
  final VoidCallback onHangulBasicsTap;
  final VoidCallback onQuizTap;
  final VoidCallback onWritingTap;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomePanel(isLoading: isLoading),
            const SizedBox(height: 16),
            _TodayLearningCard(
              count: todayLearningCount,
              streakCount: streakCount,
              dailyGoal: dailyGoal,
              reviewCount: reviewCount,
              favoriteCount: favoriteCount,
              writingTotalCount: writingTotalCount,
              onContinueTap: () => onMenuTap(1),
            ),
            const SizedBox(height: 18),
            Text(
              'Bắt đầu nhanh',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 76,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _PrimaryShortcutCard(
                    icon: Icons.abc,
                    title: 'Hangeul cơ bản',
                    onTap: onHangulBasicsTap,
                  ),
                  _PrimaryShortcutCard(
                    icon: Icons.menu_book,
                    title: 'Từ vựng',
                    onTap: () => onMenuTap(1),
                  ),
                  _PrimaryShortcutCard(
                    icon: Icons.replay,
                    title: 'Ôn tập',
                    onTap: () => onMenuTap(3),
                  ),
                  _PrimaryShortcutCard(
                    icon: Icons.quiz,
                    title: 'Quiz',
                    onTap: onQuizTap,
                  ),
                  _PrimaryShortcutCard(
                    icon: Icons.edit_note,
                    title: 'Viết',
                    onTap: onWritingTap,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _DailySuggestionCard(
              reviewCount: reviewCount,
              onTap: () => reviewCount > 0 ? onMenuTap(3) : onMenuTap(1),
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
          IllustrationPlaceholder(
            icon: Icons.school,
            assetPath: 'assets/images/home/learning_hero.png',
            size: 52,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.primary,
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
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = colorScheme.surfaceContainerHighest;
    final foregroundColor = colorScheme.onSurfaceVariant;

    return SizedBox(
      width: 96,
      child: Card(
        margin: const EdgeInsets.only(right: 10),
        color: backgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: foregroundColor),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: foregroundColor,
                  ),
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
    required this.reviewCount,
    required this.favoriteCount,
    required this.writingTotalCount,
    required this.onContinueTap,
  });

  final int count;
  final int streakCount;
  final int dailyGoal;
  final int reviewCount;
  final int favoriteCount;
  final int writingTotalCount;
  final VoidCallback onContinueTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveGoal = dailyGoal <= 0 ? 10 : dailyGoal;
    final progress = (count / effectiveGoal).clamp(0.0, 1.0);
    final isGoalDone = count >= effectiveGoal;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.today, color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Học hôm nay',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _GoalBadge(isGoalDone: isGoalDone),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              'Mục tiêu hôm nay $count/$effectiveGoal',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress,
                backgroundColor: colorScheme.surface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 19,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    streakCount == 0
                        ? 'Bắt đầu chuỗi học tập hôm nay'
                        : '$streakCount ngày liên tiếp',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _LearningInfoChip(
                  icon: Icons.replay,
                  label: 'Cần ôn',
                  value: reviewCount.toString(),
                ),
                _LearningInfoChip(
                  icon: Icons.star,
                  label: 'Yêu thích',
                  value: favoriteCount.toString(),
                ),
                _LearningInfoChip(
                  icon: Icons.edit_note,
                  label: 'Viết',
                  value: writingTotalCount.toString(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(42),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onContinueTap,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Tiếp tục học'),
              ),
            ),
            if (isGoalDone) ...[
              const SizedBox(height: 7),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.92, end: 1),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Hoàn thành mục tiêu hôm nay!',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GoalBadge extends StatelessWidget {
  const _GoalBadge({required this.isGoalDone});

  final bool isGoalDone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isGoalDone ? colorScheme.surface : colorScheme.secondary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGoalDone ? Icons.check : Icons.flag,
            size: 14,
            color: isGoalDone ? colorScheme.primary : colorScheme.onSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            isGoalDone ? 'Xong' : 'Mục tiêu',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isGoalDone ? colorScheme.primary : colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningInfoChip extends StatelessWidget {
  const _LearningInfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 5),
          Text(
            '$label $value',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailySuggestionCard extends StatelessWidget {
  const _DailySuggestionCard({required this.reviewCount, required this.onTap});

  final int reviewCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasReview = reviewCount > 0;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  hasReview ? Icons.replay : Icons.menu_book,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gợi ý hôm nay',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasReview
                          ? '$reviewCount mục cần ôn lại'
                          : 'Học thêm từ vựng mới',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
