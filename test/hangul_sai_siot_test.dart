import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_sai_siot.dart';
import 'package:korean_vietnamese_app/data/hangul_sai_siot_quiz.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_sai_siot_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('sai-siot data has 8 verified examples and correct rule types', () {
    expect(hangulSaiSiotExamples, hasLength(8));
    expect(
      {
        for (final example in hangulSaiSiotExamples)
          example.displayWord: example.pronunciation,
      },
      const {
        '찻집': '차찝',
        '냇가': '내ː까',
        '콧등': '코뜽',
        '뱃길': '배낄',
        '햇볕': '해뼏',
        '나뭇잎': '나문닙',
        '깻잎': '깬닙',
        '콧날': '콘날',
      },
    );

    for (final example in hangulSaiSiotExamples) {
      expect(example.koreanExplanation, isNotEmpty);
      expect(example.vietnameseExplanation, isNotEmpty);
      expect(example.ttsText, isNotEmpty);
      expect(example.changeProcess, isNotEmpty);
      expect(example.learnerPronunciation, isNotEmpty);
      expect(example.ttsText, isNot(contains('ː')));
      expect(
        example.hasAllowedPronunciation,
        example.ruleType == HangulSaiSiotRuleType.tensification,
      );
    }

    final byWord = {
      for (final example in hangulSaiSiotExamples) example.displayWord: example,
    };
    expect(byWord['나뭇잎']!.ruleType, HangulSaiSiotRuleType.doubleNBeforeI);
    expect(byWord['깻잎']!.ruleType, HangulSaiSiotRuleType.doubleNBeforeI);
    expect(byWord['콧날']!.ruleType, HangulSaiSiotRuleType.nBeforeNOrM);
    expect(byWord['나뭇잎']!.allowedPronunciation, isNull);
    expect(byWord['깻잎']!.allowedPronunciation, isNull);
    expect(byWord['콧날']!.allowedPronunciation, isNull);
  });

  test('sai-siot quiz has 8 valid four-choice questions', () {
    expect(hangulSaiSiotQuizQuestions, hasLength(8));
    final correctIndices = <int>[];
    for (final question in hangulSaiSiotQuizQuestions) {
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(
        question.options.where((option) => option == question.correctAnswer),
        hasLength(1),
      );
      expect(question.explanation, contains('/'));
      correctIndices.add(question.options.indexOf(question.correctAnswer));
    }
    expect(
      {
        for (var index = 0; index < 4; index++)
          index: correctIndices.where((value) => value == index).length,
      },
      const {0: 2, 1: 2, 2: 2, 3: 2},
    );
    for (final marker in const ['만들어지는 단계', '원칙 발음과 허용 발음', '잘못 적용한']) {
      expect(
        hangulSaiSiotQuizQuestions.any(
          (question) => question.prompt.contains(marker),
        ),
        isTrue,
      );
    }
  });

  testWidgets('sai-siot follows rieul nasalization and n insertion', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(home: HangulBasicsScreen(saiSiotSpeechPlayer: speechPlayer)),
    );

    final listView = tester.widget<ListView>(find.byType(ListView));
    final children =
        (listView.childrenDelegate as SliverChildListDelegate).children;
    final rieulIndex = _indexOfKey(
      children,
      const Key('rieul-nasalization-course'),
    );
    final nInsertionIndex = _indexOfKey(
      children,
      const Key('n-insertion-course'),
    );
    final saiSiotIndex = _indexOfKey(children, const Key('sai-siot-course'));
    expect(rieulIndex, lessThan(nInsertionIndex));
    expect(nInsertionIndex, isNonNegative);
    expect(saiSiotIndex, greaterThan(nInsertionIndex));

    final course = find.byKey(const Key('sai-siot-course'));
    await tester.scrollUntilVisible(
      course,
      350,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('사이시옷 · Phát âm 사이시옷'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _bringIntoTapArea(tester, course);
    await tester.tap(course);
    await tester.pumpAndSettle();
    for (final key in const [
      'sai-siot-rule-tensification',
      'sai-siot-rule-n-before-n-m',
      'sai-siot-rule-double-n',
    ]) {
      final rule = find.byKey(Key(key));
      await tester.scrollUntilVisible(
        rule,
        250,
        scrollable: find.byType(Scrollable).first,
      );
      expect(rule, findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning, TTS switching, and quiz work at 360x640', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulSaiSiotLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    final firstAudio = find.byKey(const ValueKey('sai-siot-audio-찻집'));
    final secondAudio = find.byKey(const ValueKey('sai-siot-audio-냇가'));
    await tester.scrollUntilVisible(
      firstAudio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, firstAudio);
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['차찝']);
    expect(tester.widget<IconButton>(firstAudio).onPressed, isNull);

    await tester.scrollUntilVisible(
      secondAudio,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, secondAudio);
    await tester.tap(secondAudio);
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
    expect(speechPlayer.spokenTexts, const ['차찝', '내까']);
    speechPlayer.completeSpeech();
    await tester.pump();

    await tester.drag(find.byType(Scrollable).first, const Offset(0, 5000));
    await tester.pumpAndSettle();

    for (final example in hangulSaiSiotExamples) {
      final card = find.byKey(ValueKey('sai-siot-${example.displayWord}'));
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(
        find.byKey(ValueKey('sai-siot-pronunciation-${example.displayWord}')),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey('sai-siot-process-${example.displayWord}')),
        findsOneWidget,
      );
      if (example.hasAllowedPronunciation) {
        expect(
          find.byKey(ValueKey('sai-siot-allowed-${example.displayWord}')),
          findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
    }

    final startButton = find.byKey(const Key('start-sai-siot-quiz'));
    await tester.scrollUntilVisible(
      startButton,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    expect(find.byKey(const Key('sai-siot-quiz-result')), findsOneWidget);
    expect(find.text('8/8 정답 · câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-sai-siot-quiz')));
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);
    await _completeQuiz(tester);
    await tester.tap(find.byKey(const Key('back-to-sai-siot-learning')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('start-sai-siot-quiz')), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 2);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulSaiSiotQuizQuestions) {
    final option = find.byKey(
      ValueKey('sai-siot-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, option);
    await tester.tap(option);
    await tester.pump();
    expect(find.byKey(const Key('sai-siot-quiz-feedback')), findsOneWidget);
    final nextButton = find.byKey(const Key('next-sai-siot-question'));
    await tester.scrollUntilVisible(
      nextButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, nextButton);
    await tester.tap(nextButton);
    await tester.pump();
    expect(tester.takeException(), isNull);
  }
}

Future<void> _bringIntoTapArea(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  final initialRect = tester.getRect(finder);
  final dragDistance = initialRect.top < 80
      ? 80 - initialRect.top
      : initialRect.bottom > 620
      ? 620 - initialRect.bottom
      : 0.0;
  if (dragDistance != 0) {
    await tester.drag(find.byType(Scrollable).first, Offset(0, dragDistance));
    await tester.pumpAndSettle();
  }
  final tappableRect = tester.getRect(finder);
  expect(tappableRect.top, greaterThanOrEqualTo(80));
  expect(tappableRect.bottom, lessThanOrEqualTo(620));
}

int _indexOfKey(List<Widget> children, Key key) {
  return children.indexWhere((widget) {
    if (widget.key == key) return true;
    return widget is Card && widget.child?.key == key;
  });
}

void _useSmallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

class _TestKoreanSpeechPlayer implements KoreanSpeechPlayer {
  final List<String> spokenTexts = <String>[];
  Completer<void>? _speechCompleter;
  int stopCalls = 0;

  @override
  Future<void> speakKorean(String text) {
    spokenTexts.add(text);
    _speechCompleter = Completer<void>();
    return _speechCompleter!.future;
  }

  void completeSpeech() {
    if (_speechCompleter case final completer?) {
      if (!completer.isCompleted) completer.complete();
    }
    _speechCompleter = null;
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    completeSpeech();
  }
}
