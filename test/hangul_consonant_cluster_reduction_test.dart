import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_consonant_cluster_reduction.dart';
import 'package:korean_vietnamese_app/data/hangul_consonant_cluster_reduction_quiz.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_consonant_cluster_reduction_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('cluster reduction data has 8 verified standard pronunciations', () {
    expect(hangulConsonantClusterReductionExamples, hasLength(8));
    expect(
      {
        for (final example in hangulConsonantClusterReductionExamples)
          example.writtenForm: example.pronunciation,
      },
      const {
        '넋': '넉',
        '앉다': '안따',
        '여덟': '여덜',
        '핥다': '할따',
        '값': '갑',
        '닭': '닥',
        '삶': '삼ː',
        '읊다': '읍따',
      },
    );
    expect(
      hangulConsonantClusterReductionExamples
          .map((example) => example.writtenForm)
          .toSet(),
      hasLength(8),
    );
    expect(
      hangulConsonantClusterReductionExamples
          .where((example) => example.hasChainRule)
          .map((example) => example.writtenForm)
          .toSet(),
      const {'앉다', '핥다', '읊다'},
    );
    for (final example in hangulConsonantClusterReductionExamples) {
      expect(example.cluster, isNotEmpty);
      expect(example.remainingFinal, isNotEmpty);
      expect(example.rule, isNotEmpty);
      expect(example.koreanExplanation, isNotEmpty);
      expect(example.vietnameseExplanation, isNotEmpty);
    }
  });

  test('cluster reduction quiz has 8 valid four-choice questions', () {
    expect(hangulConsonantClusterReductionQuizQuestions, hasLength(8));
    expect(
      hangulConsonantClusterReductionQuizQuestions
          .map((question) => question.correctAnswer)
          .toList(),
      const ['넉', '안따', '여덜', '할따', '갑', '닥', '삼ː', '읍따'],
    );
    for (final question in hangulConsonantClusterReductionQuizQuestions) {
      expect(question.type, HangulQuizQuestionType.pronunciationGuide);
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(
        question.options.where((option) => option == question.correctAnswer),
        hasLength(1),
      );
      expect(question.explanation, isNotEmpty);
    }
  });

  testWidgets('cluster reduction follows h changes and opens', (tester) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulBasicsScreen(
          consonantClusterReductionSpeechPlayer: speechPlayer,
        ),
      ),
    );

    final course = find.byKey(const Key('consonant-cluster-reduction-course'));
    await tester.scrollUntilVisible(
      course,
      350,
      scrollable: find.byType(Scrollable).first,
    );
    final hChanges = find.byKey(const Key('h-changes-course'));
    expect(hChanges, findsOneWidget);
    expect(
      tester.getTopLeft(hChanges).dy,
      lessThan(tester.getTopLeft(course).dy),
    );
    expect(find.text('자음군 단순화 · Giản lược cụm phụ âm'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // A following advanced card lets this course settle directly below the
    // app bar (at y=60), which is already a safe tap target.
    await tester.ensureVisible(course);
    await tester.pumpAndSettle();
    await tester.tap(course);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cluster-reduction-rules')), findsOneWidget);
    expect(
      find.byKey(const Key('cluster-reduction-chain-note')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('TTS and full quiz flow work without overflow at 360x640', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulConsonantClusterReductionLearningScreen(
          speechPlayer: speechPlayer,
        ),
      ),
    );

    expect(find.byKey(const Key('cluster-reduction-rules')), findsOneWidget);
    expect(tester.takeException(), isNull);

    final firstAudio = find.byKey(const ValueKey('cluster-reduction-audio-넋'));
    await tester.scrollUntilVisible(
      firstAudio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, firstAudio);
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['넉']);
    expect(tester.widget<IconButton>(firstAudio).onPressed, isNull);
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['넉']);
    speechPlayer.completeSpeech();
    await tester.pump();

    for (final example in hangulConsonantClusterReductionExamples) {
      final card = find.byKey(
        ValueKey('cluster-reduction-${example.writtenForm}'),
      );
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(
        find.byKey(ValueKey('cluster-reduction-audio-${example.writtenForm}')),
        findsOneWidget,
      );
      if (example.writtenForm == '삶') {
        final longVowelAudio = find.byKey(
          const ValueKey('cluster-reduction-audio-삶'),
        );
        await _bringIntoTapArea(tester, longVowelAudio);
        await tester.tap(longVowelAudio);
        await tester.pump();
        expect(speechPlayer.spokenTexts.last, '삼');
        speechPlayer.completeSpeech();
        await tester.pump();
      }
      expect(tester.takeException(), isNull);
    }

    final startButton = find.byKey(const Key('start-cluster-reduction-quiz'));
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
      find.byKey(const Key('cluster-reduction-quiz-result')),
      findsOneWidget,
    );
    expect(find.text('8/8 정답 · câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-cluster-reduction-quiz')));
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    await tester.tap(
      find.byKey(const Key('back-to-cluster-reduction-learning')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('start-cluster-reduction-quiz')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulConsonantClusterReductionQuizQuestions) {
    final option = find.byKey(
      ValueKey('cluster-reduction-option-${question.correctAnswer}'),
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
      find.byKey(const Key('cluster-reduction-quiz-feedback')),
      findsOneWidget,
    );
    final nextButton = find.byKey(const Key('next-cluster-reduction-question'));
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
    _speechCompleter?.complete();
    _speechCompleter = null;
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    completeSpeech();
  }
}
