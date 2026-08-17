import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  test('Word availability supports current and legacy image fields', () {
    const currentImageWord = Word(
      korean: '물',
      vietnamese: 'Nước',
      koreanPronunciation: '물',
      vietnamesePronunciation: '느억',
      category: '음료',
      imagePath: 'assets/images/drink/drink_001.png',
    );
    const legacyImageWord = Word(
      korean: '쌀국수',
      vietnamese: 'Phở',
      koreanPronunciation: '쌀국수',
      vietnamesePronunciation: '퍼',
      category: '음식',
      image: 'assets/images/words/pho.png',
    );
    const unavailableWord = Word(
      korean: '숨김',
      vietnamese: 'Ẩn',
      koreanPronunciation: '숨김',
      vietnamesePronunciation: '언',
      category: '기타',
    );

    expect(currentImageWord.isAvailableForLearning, isTrue);
    expect(legacyImageWord.isAvailableForLearning, isTrue);
    expect(unavailableWord.isAvailableForLearning, isFalse);
  });

  test('word data exposes exactly the image-backed learning set', () async {
    final words = await WordRepository().loadWords();
    final availableWords = words
        .where((word) => word.isAvailableForLearning)
        .toList();
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assetPaths = assetManifest.listAssets().toSet();

    expect(words, hasLength(2083));
    expect(availableWords, hasLength(1223));
    expect(words.length - availableWords.length, 860);
    expect(
      availableWords.where(
        (word) => !assetPaths.contains(word.resolvedImagePath),
      ),
      isEmpty,
    );
    expect(
      availableWords.any(
        (word) => word.category == '음식' && word.korean == '쌀국수',
      ),
      isTrue,
    );
    expect(
      availableWords.any(
        (word) => word.category == '음식' && word.korean == '맛있어요',
      ),
      isTrue,
    );
  });

  test('AppState exposes only words available for learning', () async {
    const visibleWord = Word(
      korean: '쌀국수',
      vietnamese: 'Phở',
      koreanPronunciation: '쌀국수',
      vietnamesePronunciation: '퍼',
      category: '음식',
      image: 'assets/images/words/pho.png',
    );
    const hiddenWord = Word(
      korean: '숨김',
      vietnamese: 'Ẩn',
      koreanPronunciation: '숨김',
      vietnamesePronunciation: '언',
      category: '빈 카테고리',
    );
    final appState = AppState(
      wordRepository: _FakeWordRepository(
        words: const [visibleWord, hiddenWord],
      ),
      favoriteService: _FakeFavoriteService(
        favoriteIds: {visibleWord.id, hiddenWord.id},
      ),
    );

    await appState.initialize();

    expect(appState.words, const [visibleWord]);
    expect(appState.categories, const ['음식']);
    expect(appState.favoriteWords, const [visibleWord]);
  });

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
            imagePath: 'assets/images/words/water.png',
          ),
          Word(
            korean: '밥',
            vietnamese: 'Cơm',
            koreanPronunciation: '밥',
            vietnamesePronunciation: '껌',
            category: '음식',
            imagePath: 'assets/images/words/rice.png',
          ),
          Word(
            korean: '커피',
            vietnamese: 'Cà phê',
            koreanPronunciation: '커피',
            vietnamesePronunciation: '까 페',
            category: '음식',
            imagePath: 'assets/images/words/coffee.png',
          ),
          Word(
            korean: '차',
            vietnamese: 'Trà',
            koreanPronunciation: '차',
            vietnamesePronunciation: '짜',
            category: '음식',
            imagePath: 'assets/images/words/delicious.png',
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

    expect(find.text('Chọn đáp án đúng'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(4));

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
      imagePath: 'assets/images/words/water.png',
    ),
  ];

  @override
  Future<List<Word>> loadWords() async {
    return words;
  }
}

class _FakeFavoriteService extends FavoriteService {
  _FakeFavoriteService({this.favoriteIds = const <String>{}});

  final Set<String> favoriteIds;

  @override
  Future<Set<String>> loadFavoriteIds() async {
    return Set<String>.of(favoriteIds);
  }

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async {}
}
