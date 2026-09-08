import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  testWidgets('courses are grouped by level and remain scrollable at 360x640', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: HangulBasicsScreen(
          consonantClusterReductionSpeechPlayer: _TestKoreanSpeechPlayer(),
          nInsertionSpeechPlayer: _TestKoreanSpeechPlayer(),
          saiSiotSpeechPlayer: _TestKoreanSpeechPlayer(),
          rieulNasalizationSpeechPlayer: _TestKoreanSpeechPlayer(),
        ),
      ),
    );

    final listView = tester.widget<ListView>(find.byType(ListView));
    final children =
        (listView.childrenDelegate as SliverChildListDelegate).children;
    const orderedKeys = [
      'beginner-section-title',
      'basic-consonants-course',
      'basic-vowels-course',
      'compound-vowels-course',
      'final-consonants-course',
      'compound-final-consonants-course',
      'syllable-building-course',
      'intermediate-section-title',
      'liaison-course',
      'palatalization-course',
      'tensification-course',
      'nasalization-course',
      'liquidization-course',
      'h-changes-course',
      'consonant-cluster-reduction-course',
      'advanced-section-title',
      'rieul-nasalization-course',
      'n-insertion-course',
      'sai-siot-course',
    ];

    final indices = orderedKeys
        .map((key) => _indexOfKey(children, Key(key)))
        .toList();
    expect(indices, everyElement(isNonNegative));
    for (var index = 1; index < indices.length; index++) {
      expect(indices[index - 1], lessThan(indices[index]));
    }

    final scrollable = find.byType(Scrollable).first;
    for (final key in orderedKeys) {
      await tester.scrollUntilVisible(
        find.byKey(Key(key)),
        250,
        scrollable: scrollable,
      );
      expect(find.byKey(Key(key)), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    expect(find.text('ㄴ 첨가 · Thêm âm ㄴ'), findsOneWidget);
    expect(find.text('사이시옷 · Phát âm 사이시옷'), findsOneWidget);
    expect(find.text('ㄹ의 비음화 · Mũi hóa ㄹ'), findsOneWidget);

    final clusterReduction = find.byKey(
      const Key('consonant-cluster-reduction-course'),
    );
    await tester.scrollUntilVisible(
      clusterReduction,
      -250,
      scrollable: scrollable,
    );
    tester.widget<InkWell>(clusterReduction).onTap!();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('cluster-reduction-rules')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

int _indexOfKey(List<Widget> children, Key key) {
  return children.indexWhere((widget) {
    if (widget.key == key) {
      return true;
    }
    return widget is Card && widget.child?.key == key;
  });
}

class _TestKoreanSpeechPlayer implements KoreanSpeechPlayer {
  @override
  Future<void> speakKorean(String text) async {}

  @override
  Future<void> stop() async {}
}
