import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_rieul_nasalization.dart';
import 'package:korean_vietnamese_app/data/hangul_rieul_nasalization_quiz.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_rieul_nasalization_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('rieul nasalization data has 8 verified examples and safe TTS', () {
    expect(hangulRieulNasalizationExamples, hasLength(8));
    expect(
      {
        for (final example in hangulRieulNasalizationExamples)
          example.writtenForm: example.pronunciation,
      },
      const {
        '음력': '음녁',
        '침략': '침ː냑',
        '대통령': '대ː통녕',
        '종로': '종노',
        '항로': '항ː노',
        '막론': '망논',
        '협력': '혐녁',
        '석류': '성뉴',
      },
    );
    for (final example in hangulRieulNasalizationExamples) {
      expect(example.ttsText, isNotEmpty);
      expect(example.ttsText, isNot(contains('ː')));
      expect(example.changeProcess, isNotEmpty);
      expect(example.koreanExplanation, isNotEmpty);
      expect(example.vietnameseExplanation, isNotEmpty);
    }
    expect(
      hangulRieulNasalizationExamples
          .where(
            (example) =>
                example.ruleType == HangulRieulNasalizationRuleType.chained,
          )
          .map((example) => example.writtenForm),
      const ['막론', '협력', '석류'],
    );
  });

  test('rieul nasalization quiz has 8 valid four-choice questions', () {
    expect(hangulRieulNasalizationQuizQuestions, hasLength(8));
    final correctIndices = <int>[];
    for (final question in hangulRieulNasalizationQuizQuestions) {
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
    for (final marker in const ['먼저 확인', '일반 유음화가 아니라', '연쇄 변화의 순서']) {
      expect(
        hangulRieulNasalizationQuizQuestions.any(
          (question) => question.prompt.contains(marker),
        ),
        isTrue,
      );
    }
  });

  testWidgets('advanced menu opens rieul nasalization before n insertion', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulBasicsScreen(rieulNasalizationSpeechPlayer: speechPlayer),
      ),
    );

    final listView = tester.widget<ListView>(find.byType(ListView));
    final children =
        (listView.childrenDelegate as SliverChildListDelegate).children;
    final nInsertionIndex = _indexOfKey(
      children,
      const Key('n-insertion-course'),
    );
    final saiSiotIndex = _indexOfKey(children, const Key('sai-siot-course'));
    final rieulIndex = _indexOfKey(
      children,
      const Key('rieul-nasalization-course'),
    );
    expect(rieulIndex, lessThan(nInsertionIndex));
    expect(nInsertionIndex, lessThan(saiSiotIndex));

    final course = find.byKey(const Key('rieul-nasalization-course'));
    await tester.scrollUntilVisible(
      course,
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(course);
    await tester.pumpAndSettle();
    expect(find.text('ㄹ의 비음화 · Mũi hóa ㄹ'), findsOneWidget);
    expect(
      find.byKey(const Key('rieul-nasalization-main-rule')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning TTS and full quiz work at 360x640', (tester) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulRieulNasalizationLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    final comparison = find.byKey(const Key('rieul-nasalization-comparison'));
    await tester.scrollUntilVisible(
      comparison,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(comparison, findsOneWidget);
    final firstAudio = find.byKey(
      const ValueKey('rieul-nasalization-audio-음력'),
    );
    final secondAudio = find.byKey(
      const ValueKey('rieul-nasalization-audio-침략'),
    );
    await tester.scrollUntilVisible(
      firstAudio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, firstAudio);
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['음녁']);
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
    expect(speechPlayer.spokenTexts, const ['음녁', '침냑']);

    for (final example in hangulRieulNasalizationExamples.skip(2)) {
      final card = find.byKey(
        ValueKey('rieul-nasalization-${example.writtenForm}'),
      );
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(
        find.byKey(
          ValueKey('rieul-nasalization-pronunciation-${example.writtenForm}'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          ValueKey('rieul-nasalization-process-${example.writtenForm}'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }
    speechPlayer.completeSpeech();
    await tester.pump();

    final startButton = find.byKey(const Key('start-rieul-nasalization-quiz'));
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
    expect(
      find.byKey(const Key('rieul-nasalization-quiz-result')),
      findsOneWidget,
    );
    expect(find.text('8/8 정답 · câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-rieul-nasalization-quiz')));
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);
    await _completeQuiz(tester);
    await tester.tap(
      find.byKey(const Key('back-to-rieul-nasalization-learning')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('start-rieul-nasalization-quiz')),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 2);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulRieulNasalizationQuizQuestions) {
    final option = find.byKey(
      ValueKey('rieul-nasalization-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, option);
    await tester.tap(option);
    await tester.pump();
    expect(
      find.byKey(const Key('rieul-nasalization-quiz-feedback')),
      findsOneWidget,
      reason: question.prompt,
    );
    final nextButton = find.byKey(
      const Key('next-rieul-nasalization-question'),
    );
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
