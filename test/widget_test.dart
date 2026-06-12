import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:korean_vietnamese_app/data/app_state.dart';
import 'package:korean_vietnamese_app/main.dart';
import 'package:korean_vietnamese_app/models/word.dart';
import 'package:korean_vietnamese_app/screens/quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/writing_practice_screen.dart';
import 'package:korean_vietnamese_app/services/favorite_service.dart';
import 'package:korean_vietnamese_app/services/word_repository.dart';
import 'package:korean_vietnamese_app/utils/learning_direction.dart';
import 'package:korean_vietnamese_app/utils/learning_progress_tracker.dart';
import 'package:korean_vietnamese_app/utils/learning_stats_keys.dart';

void main() {
  testWidgets('K-Viet Talk first screen smoke test', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const KVietTalkApp());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
    });
    await tester.pump();

    expect(find.text('K-Viet Talk'), findsWidgets);
    expect(find.text('Ứng dụng học tiếng Hàn cho người Việt'), findsOneWidget);
    expect(find.text('Học hôm nay'), findsOneWidget);
    expect(find.text('Mục tiêu hôm nay 0/10'), findsOneWidget);
    expect(find.text('Bắt đầu chuỗi học tập hôm nay'), findsOneWidget);
    expect(find.text('Bắt đầu nhanh'), findsOneWidget);
    expect(find.text('Từ vựng'), findsWidgets);
    expect(find.text('Quiz'), findsWidgets);
  });

  testWidgets('Writing practice screen smoke test', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState(
      wordRepository: _FakeWordRepository(),
      favoriteService: _FakeFavoriteService(),
    );

    await tester.runAsync(() async {
      await appState.initialize();
    });
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: const MaterialApp(home: Scaffold(body: WritingPracticeScreen())),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Luyện viết'), findsWidgets);
    expect(find.text('Tổng'), findsOneWidget);
    expect(find.text('Đúng'), findsOneWidget);
    expect(find.text('Sai'), findsOneWidget);
    expect(find.text('Tỷ lệ'), findsOneWidget);
    expect(find.text('Đặt lại thống kê'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Không có danh sách từ sai'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Không có danh sách từ sai'), findsOneWidget);
  });

  test('Learning progress tracker counts streak once per day', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final tracker = LearningProgressTracker(preferences);
    final today = DateTime(2026, 6, 12);

    await tracker.recordActivity(now: today);
    await tracker.recordActivity(now: today);

    expect(preferences.getInt(LearningStatsKeys.todayCount), 2);
    expect(preferences.getInt(LearningStatsKeys.streakCount), 1);
  });

  testWidgets('Quiz answer records learning activity', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState(
      wordRepository: _FakeWordRepository(
        words: const [
          Word(
            korean: '물',
            vietnamese: 'Nước',
            koreanPronunciation: '물',
            vietnamesePronunciation: '느억',
            category: '음식',
          ),
          Word(
            korean: '밥',
            vietnamese: 'Cơm',
            koreanPronunciation: '밥',
            vietnamesePronunciation: '껌',
            category: '음식',
          ),
          Word(
            korean: '커피',
            vietnamese: 'Cà phê',
            koreanPronunciation: '커피',
            vietnamesePronunciation: '까 페',
            category: '음식',
          ),
        ],
      ),
      favoriteService: _FakeFavoriteService(),
    );

    await tester.runAsync(() async {
      await appState.initialize();
    });
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: const MaterialApp(
          home: Scaffold(
            body: QuizScreen(direction: LearningDirection.vietnameseToKorean),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byType(ListTile).first);
    await tester.pump(const Duration(milliseconds: 300));

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt(LearningStatsKeys.todayCount), 1);
    expect(preferences.getInt(LearningStatsKeys.streakCount), 1);
  });
}

class _FakeWordRepository extends WordRepository {
  _FakeWordRepository({this.words = _defaultWords});

  final List<Word> words;

  static const List<Word> _defaultWords = [
    Word(
      korean: '안녕하세요',
      vietnamese: 'Xin chào',
      koreanPronunciation: '안녕하세요',
      vietnamesePronunciation: '씬 짜오',
      category: '인사',
    ),
  ];

  @override
  Future<List<Word>> loadWords() async {
    return words;
  }
}

class _FakeFavoriteService extends FavoriteService {
  @override
  Future<Set<String>> loadFavoriteIds() async {
    return <String>{};
  }

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async {}
}
