import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_nasalization.dart';
import 'package:korean_vietnamese_app/data/hangul_nasalization_quiz.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_nasalization_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('nasalization learning data has 8 unique verified examples', () {
    expect(hangulNasalizationExamples, hasLength(8));
    expect(
      {
        for (final example in hangulNasalizationExamples)
          example.writtenForm: example.pronunciation,
      },
      const {
        '국물': '궁물',
        '먹는': '멍는',
        '닫는': '단는',
        '있는': '인는',
        '앞문': '암문',
        '밥물': '밤물',
        '꽃망울': '꼰망울',
        '잡는': '잠는',
      },
    );
    expect(
      hangulNasalizationExamples.map((example) => example.writtenForm).toSet(),
      hasLength(hangulNasalizationExamples.length),
    );
    expect(
      hangulNasalizationExamples
          .map((example) => example.pronunciation)
          .toSet(),
      hasLength(hangulNasalizationExamples.length),
    );
    for (final example in hangulNasalizationExamples) {
      expect(example.writtenForm, '${example.beforePart}${example.afterPart}');
      expect(example.finalConsonantFamily, isNotEmpty);
      expect(example.nasalConsonant, isIn(const ['ㅇ', 'ㄴ', 'ㅁ']));
      expect(example.koreanExplanation, isNotEmpty);
      expect(example.vietnameseExplanation, isNotEmpty);
    }
  });

  test(
    'nasalization quiz has unique pronunciation questions with one answer',
    () {
      expect(hangulNasalizationQuizQuestions, hasLength(8));
      expect(
        hangulNasalizationQuizQuestions
            .map((question) => question.correctAnswer)
            .toSet(),
        const {'궁물', '암문', '장년', '궁민', '망내', '반는', '심만', '엄무'},
      );
      expect(
        hangulNasalizationQuizQuestions
            .map((question) => question.prompt)
            .toSet(),
        hasLength(hangulNasalizationQuizQuestions.length),
      );
      for (final question in hangulNasalizationQuizQuestions) {
        expect(question.type, HangulQuizQuestionType.pronunciationGuide);
        expect(question.options, hasLength(4));
        expect(question.options.toSet(), hasLength(4));
        expect(
          question.options.where((option) => option == question.correctAnswer),
          hasLength(1),
        );
        expect(question.explanation, isNotEmpty);
      }
    },
  );

  testWidgets(
    'Hangeul basics opens nasalization immediately after tensification',
    (tester) async {
      final speechPlayer = _TestKoreanSpeechPlayer();
      _useSmallScreen(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: HangulBasicsScreen(nasalizationSpeechPlayer: speechPlayer),
        ),
      );

      final course = find.byKey(const Key('nasalization-course'));
      await tester.scrollUntilVisible(
        course,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      final tensification = find.byKey(const Key('tensification-course'));
      expect(tensification, findsOneWidget);
      expect(find.text('비음화 · Biến âm mũi'), findsOneWidget);
      expect(
        find.text('ㄱ·ㄷ·ㅂ + ㄴ/ㅁ → ㅇ·ㄴ·ㅁ · Nghe phát âm · Quiz'),
        findsOneWidget,
      );
      expect(
        tester.getTopLeft(tensification).dy,
        lessThan(tester.getTopLeft(course).dy),
      );
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(course);
      await tester.pumpAndSettle();
      await tester.tap(course);
      await tester.pumpAndSettle();
      expect(find.text('ㄱ·ㄷ·ㅂ 계열 + ㄴ/ㅁ → ㅇ·ㄴ·ㅁ'), findsOneWidget);
      final firstCard = find.byKey(const ValueKey('nasalization-국물'));
      await tester.scrollUntilVisible(
        firstCard,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(firstCard, findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('learning cards show bilingual rules and reuse guarded TTS', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulNasalizationLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    expect(find.textContaining('먼저 뒤에 ㄴ/ㅁ이 오는지'), findsOneWidget);
    expect(find.textContaining('Một số 받침'), findsOneWidget);
    final firstAudio = find.byKey(const ValueKey('nasalization-audio-국물'));
    await tester.scrollUntilVisible(
      firstAudio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(firstAudio);
    await tester.pumpAndSettle();
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['국물']);
    expect(tester.widget<IconButton>(firstAudio).onPressed, isNull);

    speechPlayer.completeSpeech();
    await tester.pump();
    for (final example in hangulNasalizationExamples) {
      final card = find.byKey(ValueKey('nasalization-${example.writtenForm}'));
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(
        find.byKey(
          ValueKey('nasalization-pronunciation-${example.writtenForm}'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
  });

  testWidgets('quiz starts, progresses, completes, retries without overflow', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulNasalizationLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    final startButton = find.byKey(const Key('start-nasalization-quiz'));
    await tester.scrollUntilVisible(
      startButton,
      600,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    expect(find.text('1/8'), findsOneWidget);
    expect(_optionFinder(), findsNWidgets(4));

    await _completeQuiz(tester);
    expect(find.byKey(const Key('nasalization-quiz-result')), findsOneWidget);
    expect(find.text('8/8 정답 · câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-nasalization-quiz')));
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    await tester.tap(find.byKey(const Key('back-to-nasalization-learning')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('start-nasalization-quiz')), findsOneWidget);
    expect(find.text('비음화 · Biến âm mũi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulNasalizationQuizQuestions) {
    final option = find.byKey(
      ValueKey('nasalization-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester.widget<InkWell>(option).onTap!();
    await tester.pump();
    final nextButton = find.byKey(const Key('next-nasalization-question'));
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

Finder _optionFinder() => find.byWidgetPredicate(
  (widget) =>
      widget.key is ValueKey<String> &&
      ((widget.key! as ValueKey<String>).value).startsWith(
        'nasalization-option-',
      ),
);

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
