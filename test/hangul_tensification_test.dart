import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_tensification.dart';
import 'package:korean_vietnamese_app/data/hangul_tensification_quiz.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_tensification_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('tensification learning data has 8 unique verified examples', () {
    expect(hangulTensificationExamples, hasLength(8));
    expect(
      {
        for (final example in hangulTensificationExamples)
          example.writtenForm: example.pronunciation,
      },
      const {
        '학교': '학꾜',
        '국밥': '국빱',
        '책상': '책쌍',
        '식당': '식땅',
        '옷감': '옫깜',
        '입구': '입꾸',
        '잡지': '잡찌',
        '꽃병': '꼳뼝',
      },
    );
    expect(
      hangulTensificationExamples.map((example) => example.writtenForm).toSet(),
      hasLength(hangulTensificationExamples.length),
    );
    expect(
      hangulTensificationExamples
          .map((example) => example.pronunciation)
          .toSet(),
      hasLength(hangulTensificationExamples.length),
    );
    for (final example in hangulTensificationExamples) {
      expect(example.writtenForm, '${example.beforePart}${example.afterPart}');
      expect(example.finalConsonant, isNotEmpty);
      expect(example.tenseConsonant, isIn(const ['ㄲ', 'ㄸ', 'ㅃ', 'ㅆ', 'ㅉ']));
      expect(example.koreanExplanation, isNotEmpty);
      expect(example.vietnameseExplanation, isNotEmpty);
    }
  });

  test(
    'tensification quiz has unique pronunciation questions with one answer',
    () {
      expect(hangulTensificationQuizQuestions, hasLength(8));
      expect(
        hangulTensificationQuizQuestions
            .map((question) => question.prompt)
            .toSet(),
        hasLength(hangulTensificationQuizQuestions.length),
      );
      for (final question in hangulTensificationQuizQuestions) {
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
    'Hangeul basics opens tensification immediately after palatalization',
    (tester) async {
      final speechPlayer = _TestKoreanSpeechPlayer();
      _useSmallScreen(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: HangulBasicsScreen(tensificationSpeechPlayer: speechPlayer),
        ),
      );

      final course = find.byKey(const Key('tensification-course'));
      await tester.scrollUntilVisible(
        course,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      final palatalization = find.byKey(const Key('palatalization-course'));
      expect(palatalization, findsOneWidget);
      expect(find.text('된소리되기 · Căng hóa phụ âm'), findsOneWidget);
      expect(
        find.text('ㄱ·ㄷ·ㅂ·ㅅ·ㅈ → 된소리 · Nghe phát âm · Quiz'),
        findsOneWidget,
      );
      expect(
        tester.getTopLeft(palatalization).dy,
        lessThan(tester.getTopLeft(course).dy),
      );
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(course);
      await tester.pumpAndSettle();
      await tester.tap(course);
      await tester.pumpAndSettle();
      expect(find.text('ㄱ·ㄷ·ㅂ·ㅅ·ㅈ → ㄲ·ㄸ·ㅃ·ㅆ·ㅉ'), findsOneWidget);
      final firstCard = find.byKey(const ValueKey('tensification-학교'));
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
        home: HangulTensificationLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    expect(find.textContaining('무조건 된소리가 되는 것은 아닙니다'), findsOneWidget);
    expect(find.textContaining('Không phải mọi phụ âm thường'), findsOneWidget);
    final firstAudio = find.byKey(const ValueKey('tensification-audio-학교'));
    await tester.scrollUntilVisible(
      firstAudio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(firstAudio);
    await tester.pumpAndSettle();
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['학교']);
    expect(tester.widget<IconButton>(firstAudio).onPressed, isNull);

    speechPlayer.completeSpeech();
    await tester.pump();
    for (final example in hangulTensificationExamples) {
      final card = find.byKey(ValueKey('tensification-${example.writtenForm}'));
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(
        find.byKey(
          ValueKey('tensification-pronunciation-${example.writtenForm}'),
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
        home: HangulTensificationLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    final startButton = find.byKey(const Key('start-tensification-quiz'));
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
    expect(find.byKey(const Key('tensification-quiz-result')), findsOneWidget);
    expect(find.text('8/8 정답 · câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-tensification-quiz')));
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    await tester.tap(find.byKey(const Key('back-to-tensification-learning')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('start-tensification-quiz')), findsOneWidget);
    expect(find.text('된소리되기 · Căng hóa phụ âm'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulTensificationQuizQuestions) {
    final option = find.byKey(
      ValueKey('tensification-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester.widget<InkWell>(option).onTap!();
    await tester.pump();
    final nextButton = find.byKey(const Key('next-tensification-question'));
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
        'tensification-option-',
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
