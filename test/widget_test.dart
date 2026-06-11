import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:korean_vietnamese_app/data/app_state.dart';
import 'package:korean_vietnamese_app/main.dart';
import 'package:korean_vietnamese_app/models/word.dart';
import 'package:korean_vietnamese_app/screens/writing_practice_screen.dart';
import 'package:korean_vietnamese_app/services/favorite_service.dart';
import 'package:korean_vietnamese_app/services/word_repository.dart';

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
    expect(find.text('Tiến độ học tập'), findsOneWidget);
    expect(find.text('Từ vựng'), findsWidgets);
    expect(find.text('Câu đố'), findsWidgets);
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
}

class _FakeWordRepository extends WordRepository {
  @override
  Future<List<Word>> loadWords() async {
    return const [
      Word(
        korean: '안녕하세요',
        vietnamese: 'Xin chào',
        koreanPronunciation: '안녕하세요',
        vietnamesePronunciation: '씬 짜오',
        category: '인사',
      ),
    ];
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
