import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_h_changes.dart';
import 'package:korean_vietnamese_app/data/hangul_h_changes_quiz.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_h_changes_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('h change learning data has 8 verified examples', () {
    expect(hangulHChangeExamples, hasLength(8));
    expect(
      {
        for (final example in hangulHChangeExamples)
          example.writtenForm: example.pronunciation,
      },
      const {
        '놓고': '노코',
        '좋던': '조ː턴',
        '쌓지': '싸치',
        '먹히다': '머키다',
        '좁히다': '조피다',
        '꽂히다': '꼬치다',
        '놓아': '노아',
        '많아': '마ː나',
      },
    );
    expect(
      hangulHChangeExamples.map((example) => example.writtenForm).toSet(),
      hasLength(8),
    );
    expect(
      hangulHChangeExamples.map((example) => example.pronunciation).toSet(),
      const {'노코', '조ː턴', '싸치', '머키다', '조피다', '꼬치다', '노아', '마ː나'},
    );
    for (final example in hangulHChangeExamples) {
      expect(example.writtenForm, '${example.beforePart}${example.afterPart}');
      expect(example.rule, isNotEmpty);
      expect(example.koreanExplanation, isNotEmpty);
      expect(example.vietnameseExplanation, isNotEmpty);
    }
  });

  test('h change quiz has 8 valid questions with unique options', () {
    expect(hangulHChangesQuizQuestions, hasLength(8));
    expect(
      hangulHChangesQuizQuestions
          .map((question) => question.correctAnswer)
          .toList(),
      const ['노코', '조ː턴', '싸치', '머키다', '조피다', '꼬치다', '노아', '마ː나'],
    );
    for (final question in hangulHChangesQuizQuestions) {
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

  testWidgets('h change course follows liquidization and opens', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(home: HangulBasicsScreen(hChangesSpeechPlayer: speechPlayer)),
    );

    final hChanges = find.byKey(const Key('h-changes-course'));
    await tester.scrollUntilVisible(
      hChanges,
      350,
      scrollable: find.byType(Scrollable).first,
    );
    final liquidization = find.byKey(const Key('liquidization-course'));
    expect(liquidization, findsOneWidget);
    expect(
      tester.getTopLeft(liquidization).dy,
      lessThan(tester.getTopLeft(hChanges).dy),
    );
    expect(find.text('ㅎ 관련 발음 변화 · Biến đổi âm ㅎ'), findsOneWidget);
    expect(find.textContaining('ㅎ과 만나 거센소리'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _bringIntoTapArea(tester, hChanges);
    await tester.tap(hChanges);
    await tester.pumpAndSettle();
    expect(find.text('ㅎ 발음 변화 · Biến đổi âm ㅎ'), findsOneWidget);
    expect(find.byKey(const Key('h-changes-rules')), findsOneWidget);
    expect(find.byKey(const Key('h-deletion-note')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TTS and full quiz flow work without overflow at 360x640', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulHChangesLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    expect(find.byKey(const Key('h-changes-rules')), findsOneWidget);
    expect(tester.takeException(), isNull);

    final firstAudio = find.byKey(const ValueKey('h-change-audio-놓고'));
    await tester.scrollUntilVisible(
      firstAudio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, firstAudio);
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['노코']);
    expect(tester.widget<IconButton>(firstAudio).onPressed, isNull);
    speechPlayer.completeSpeech();
    await tester.pump();

    for (final example in hangulHChangeExamples) {
      final card = find.byKey(ValueKey('h-change-${example.writtenForm}'));
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(
        find.byKey(ValueKey('h-change-audio-${example.writtenForm}')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }

    final startButton = find.byKey(const Key('start-h-changes-quiz'));
    await tester.scrollUntilVisible(
      startButton,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    expect(find.byKey(const Key('h-changes-quiz-result')), findsOneWidget);
    expect(find.text('8/8 정답 · câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-h-changes-quiz')));
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    await tester.tap(find.byKey(const Key('back-to-h-changes-learning')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('start-h-changes-quiz')), findsOneWidget);
    expect(find.text('ㅎ 발음 변화 · Biến đổi âm ㅎ'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulHChangesQuizQuestions) {
    final option = find.byKey(
      ValueKey('h-changes-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester.widget<InkWell>(option).onTap!();
    await tester.pump();
    expect(find.byKey(const Key('h-changes-quiz-feedback')), findsOneWidget);
    final nextButton = find.byKey(const Key('next-h-changes-question'));
    await tester.scrollUntilVisible(
      nextButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(nextButton);
    await tester.pump();
    expect(tester.takeException(), isNull);
  }
}

Future<void> _bringIntoTapArea(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  final centerY = tester.getCenter(finder).dy;
  final dragDistance = centerY < 100
      ? 100 - centerY
      : centerY > 540
      ? 540 - centerY
      : 0.0;
  if (dragDistance != 0) {
    await tester.drag(find.byType(Scrollable).first, Offset(0, dragDistance));
    await tester.pumpAndSettle();
  }
  expect(tester.getCenter(finder).dy, inInclusiveRange(100, 540));
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
