import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_palatalization.dart';
import 'package:korean_vietnamese_app/data/hangul_palatalization_quiz.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_palatalization_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('palatalization learning data has 8 unique verified examples', () {
    expect(hangulPalatalizationExamples, hasLength(8));
    expect(
      {
        for (final example in hangulPalatalizationExamples)
          example.writtenForm: example.pronunciation,
      },
      const {
        '굳이': '구지',
        '같이': '가치',
        '밭이': '바치',
        '해돋이': '해도지',
        '미닫이': '미다지',
        '맏이': '마지',
        '끝이': '끄치',
        '붙이다': '부치다',
      },
    );
    expect(
      hangulPalatalizationExamples
          .map((example) => example.writtenForm)
          .toSet(),
      hasLength(hangulPalatalizationExamples.length),
    );
    expect(
      hangulPalatalizationExamples
          .map((example) => example.pronunciation)
          .toSet(),
      hasLength(hangulPalatalizationExamples.length),
    );
    for (final example in hangulPalatalizationExamples) {
      expect(example.writtenForm, '${example.beforePart}${example.afterPart}');
      expect(example.finalConsonant, isIn(const ['ㄷ', 'ㅌ']));
      expect(example.koreanExplanation, isNotEmpty);
      expect(example.vietnameseExplanation, isNotEmpty);
    }
  });

  test(
    'palatalization quiz has unique pronunciation questions with one answer',
    () {
      expect(hangulPalatalizationQuizQuestions, hasLength(8));
      expect(
        hangulPalatalizationQuizQuestions
            .map((question) => question.prompt)
            .toSet(),
        hasLength(hangulPalatalizationQuizQuestions.length),
      );
      for (final question in hangulPalatalizationQuizQuestions) {
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

  testWidgets('Hangeul basics opens palatalization immediately after liaison', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulBasicsScreen(palatalizationSpeechPlayer: speechPlayer),
      ),
    );

    final course = find.byKey(const Key('palatalization-course'));
    await tester.scrollUntilVisible(
      course,
      350,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const Key('liaison-course')), findsOneWidget);
    expect(find.text('구개음화 · Biến âm vòm miệng'), findsOneWidget);
    expect(find.text('ㄷ → ㅈ · ㅌ → ㅊ · Nghe phát âm · Quiz'), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const Key('liaison-course'))).dy,
      lessThan(tester.getTopLeft(course).dy),
    );
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(course);
    await tester.pumpAndSettle();
    await tester.tap(course);
    await tester.pumpAndSettle();
    expect(find.text('ㄷ → ㅈ, ㅌ → ㅊ'), findsOneWidget);
    final firstCard = find.byKey(const ValueKey('palatalization-굳이'));
    await tester.scrollUntilVisible(
      firstCard,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(firstCard, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning cards show bilingual rules and reuse guarded TTS', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulPalatalizationLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    expect(find.textContaining('항상 구개음화되는 것은 아닙니다'), findsOneWidget);
    expect(find.textContaining('Không phải mọi chữ viết'), findsOneWidget);
    final firstAudio = find.byKey(const ValueKey('palatalization-audio-굳이'));
    await tester.scrollUntilVisible(
      firstAudio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(firstAudio);
    await tester.pumpAndSettle();
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['굳이']);
    expect(tester.widget<IconButton>(firstAudio).onPressed, isNull);

    speechPlayer.completeSpeech();
    await tester.pump();
    for (final example in hangulPalatalizationExamples) {
      final card = find.byKey(
        ValueKey('palatalization-${example.writtenForm}'),
      );
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(
        find.byKey(
          ValueKey('palatalization-pronunciation-${example.writtenForm}'),
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
        home: HangulPalatalizationLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    final startButton = find.byKey(const Key('start-palatalization-quiz'));
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
    expect(find.byKey(const Key('palatalization-quiz-result')), findsOneWidget);
    expect(find.text('8/8 정답 · câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-palatalization-quiz')));
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    await tester.tap(find.byKey(const Key('back-to-palatalization-learning')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('start-palatalization-quiz')), findsOneWidget);
    expect(find.text('구개음화 · Biến âm vòm miệng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulPalatalizationQuizQuestions) {
    final option = find.byKey(
      ValueKey('palatalization-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester.widget<InkWell>(option).onTap!();
    await tester.pump();
    final nextButton = find.byKey(const Key('next-palatalization-question'));
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
        'palatalization-option-',
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
