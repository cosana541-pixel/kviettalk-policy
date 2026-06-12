import 'package:shared_preferences/shared_preferences.dart';

import 'learning_stats_keys.dart';

class LearningProgressSnapshot {
  const LearningProgressSnapshot({
    required this.todayCount,
    required this.streakCount,
    required this.dailyGoal,
    required this.totalActivityCount,
  });

  final int todayCount;
  final int streakCount;
  final int dailyGoal;
  final int totalActivityCount;
}

class LearningProgressTracker {
  const LearningProgressTracker(this.preferences);

  static const int defaultDailyGoal = 10;

  final SharedPreferences preferences;

  LearningProgressSnapshot load({DateTime? now}) {
    final today = _dateKey(now ?? DateTime.now());
    final savedDate = preferences.getString(LearningStatsKeys.todayDate);
    final streakLastDate = preferences.getString(
      LearningStatsKeys.streakLastDate,
    );

    return LearningProgressSnapshot(
      todayCount: savedDate == today
          ? preferences.getInt(LearningStatsKeys.todayCount) ?? 0
          : 0,
      streakCount: _activeStreakCount(
        preferences.getInt(LearningStatsKeys.streakCount) ?? 0,
        streakLastDate,
        today,
        _dateKey((now ?? DateTime.now()).subtract(const Duration(days: 1))),
      ),
      dailyGoal:
          preferences.getInt(LearningStatsKeys.dailyGoal) ?? defaultDailyGoal,
      totalActivityCount:
          preferences.getInt(LearningStatsKeys.totalActivityCount) ?? 0,
    );
  }

  Future<void> recordActivity({DateTime? now}) async {
    final activityDate = now ?? DateTime.now();
    final today = _dateKey(activityDate);
    final yesterday = _dateKey(activityDate.subtract(const Duration(days: 1)));
    final savedDate = preferences.getString(LearningStatsKeys.todayDate);
    final currentCount = savedDate == today
        ? preferences.getInt(LearningStatsKeys.todayCount) ?? 0
        : 0;

    await preferences.setString(LearningStatsKeys.todayDate, today);
    await preferences.setInt(LearningStatsKeys.todayCount, currentCount + 1);
    await preferences.setInt(
      LearningStatsKeys.totalActivityCount,
      (preferences.getInt(LearningStatsKeys.totalActivityCount) ?? 0) + 1,
    );

    if (savedDate == today) {
      return;
    }

    final streakLastDate = preferences.getString(
      LearningStatsKeys.streakLastDate,
    );
    final currentStreak =
        preferences.getInt(LearningStatsKeys.streakCount) ?? 0;
    final nextStreak = streakLastDate == yesterday ? currentStreak + 1 : 1;

    await preferences.setInt(LearningStatsKeys.streakCount, nextStreak);
    await preferences.setString(LearningStatsKeys.streakLastDate, today);
  }

  int _activeStreakCount(
    int savedCount,
    String? lastDate,
    String today,
    String yesterday,
  ) {
    if (savedCount <= 0 || lastDate == null) {
      return 0;
    }

    if (lastDate == today || lastDate == yesterday) {
      return savedCount;
    }

    return 0;
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
