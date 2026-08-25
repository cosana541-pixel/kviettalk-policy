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
import 'package:korean_vietnamese_app/utils/word_search.dart';

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

  test('Word supports legacy, two-category, and three-category data', () {
    final legacyWord = Word.fromJson(const <String, dynamic>{
      'korean': '물',
      'vietnamese': 'Nước',
      'koreanPronunciation': '물',
      'vietnamesePronunciation': '느억',
      'category': '음료',
    });
    final twoCategoryWord = Word.fromJson(const <String, dynamic>{
      'korean': '김치',
      'vietnamese': 'Kim chi',
      'koreanPronunciation': '김치',
      'vietnamesePronunciation': '',
      'category': '한국생활',
      'categories': <String>['음식', '한국생활'],
    });
    const threeCategoryWord = Word(
      korean: '엘리베이터',
      vietnamese: 'Thang máy',
      koreanPronunciation: '엘리베이터',
      vietnamesePronunciation: '',
      category: '호텔',
      categories: <String>['호텔', '한국생활', '회사'],
    );

    final emptyCategoriesWord = Word.fromJson(const <String, dynamic>{
      'korean': '물',
      'vietnamese': 'Nước',
      'koreanPronunciation': '물',
      'vietnamesePronunciation': '느억',
      'category': '음료',
      'categories': <String>[],
    });
    final duplicateCategoriesWord = Word.fromJson(const <String, dynamic>{
      'korean': '김치',
      'vietnamese': 'Kim chi',
      'koreanPronunciation': '김치',
      'vietnamesePronunciation': '',
      'category': '한국생활',
      'categories': <String>['음식', '한국생활', '음식'],
    });
    final missingLegacyCategoryWord = Word.fromJson(const <String, dynamic>{
      'korean': '김치',
      'vietnamese': 'Kim chi',
      'koreanPronunciation': '김치',
      'vietnamesePronunciation': '',
      'category': '한국생활',
      'categories': <String>['음식', '여행'],
    });

    expect(legacyWord.categories, const <String>['음료']);
    expect(emptyCategoriesWord.categories, const <String>['음료']);
    expect(twoCategoryWord.categories, const <String>['음식', '한국생활']);
    expect(duplicateCategoriesWord.categories, const <String>['음식', '한국생활']);
    expect(missingLegacyCategoryWord.categories, const <String>[
      '한국생활',
      '음식',
      '여행',
    ]);
    expect(twoCategoryWord.belongsToCategory('음식'), isTrue);
    expect(twoCategoryWord.belongsToCategory('한국생활'), isTrue);
    expect(threeCategoryWord.categories, const <String>['호텔', '한국생활', '회사']);
    expect(threeCategoryWord.belongsToCategory('회사'), isTrue);
    expect(wordMatchesSearch(twoCategoryWord, '김치'), isTrue);
    expect(
      <Word>[twoCategoryWord].where((word) => wordMatchesSearch(word, '김치')),
      hasLength(1),
    );
  });

  test('word data exposes exactly the image-backed learning set', () async {
    final words = await WordRepository().loadWords();
    final availableWords = words
        .where((word) => word.isAvailableForLearning)
        .toList();
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assetPaths = assetManifest.listAssets().toSet();

    expect(words, hasLength(2115));
    expect(availableWords, hasLength(1260));
    expect(words.length - availableWords.length, 855);
    final multiCategoryWords = words
        .where((word) => word.categories.length > 1)
        .toList();
    expect(multiCategoryWords, hasLength(67));
    expect(
      multiCategoryWords.where((word) => word.categories.length == 2),
      hasLength(65),
    );
    expect(
      multiCategoryWords.where((word) => word.categories.length >= 3),
      hasLength(2),
    );

    final imageBackedLearningKeys = availableWords
        .map(
          (word) => <Object?>[
            word.korean,
            word.vietnamese,
            word.koreanPronunciation,
            word.vietnamesePronunciation,
            word.resolvedImagePath,
          ].join('\u001f'),
        )
        .toList();
    expect(
      imageBackedLearningKeys.toSet(),
      hasLength(imageBackedLearningKeys.length),
    );

    final kimchiWords = words.where((word) => word.korean == '김치').toList();
    expect(kimchiWords, hasLength(1));
    expect(kimchiWords.single.belongsToCategory('음식'), isTrue);
    expect(kimchiWords.single.belongsToCategory('한국생활'), isTrue);
    expect(
      words.where(
        (word) => word.belongsToCategory('음식') && word.korean == '김치',
      ),
      hasLength(1),
    );
    expect(
      words.where(
        (word) => word.belongsToCategory('한국생활') && word.korean == '김치',
      ),
      hasLength(1),
    );
    expect(
      words.where(
        (word) => word.korean == '김치' && wordMatchesSearch(word, '김치'),
      ),
      hasLength(1),
    );

    final elevatorWords = words
        .where((word) => word.korean == '엘리베이터')
        .toList();
    expect(elevatorWords, hasLength(1));
    expect(elevatorWords.single.categories, const <String>['호텔', '한국생활', '회사']);
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

  test('AppState exposes every category of a multi-category word', () async {
    const multiCategoryWord = Word(
      korean: '김치',
      vietnamese: 'Kim chi',
      koreanPronunciation: '김치',
      vietnamesePronunciation: '',
      category: '한국생활',
      categories: <String>['음식', '한국생활'],
      imagePath: 'assets/images/food/food_002.png',
    );
    final appState = AppState(
      wordRepository: _FakeWordRepository(words: const [multiCategoryWord]),
      favoriteService: _FakeFavoriteService(),
    );

    await appState.initialize();

    expect(appState.words, const <Word>[multiCategoryWord]);
    expect(appState.categories, const <String>['음식', '한국생활']);
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
