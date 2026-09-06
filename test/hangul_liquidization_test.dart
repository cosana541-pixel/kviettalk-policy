import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_liquidization.dart';
import 'package:korean_vietnamese_app/data/hangul_liquidization_quiz.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_liquidization_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('liquidization learning data has 8 verified examples', () {
    expect(hangulLiquidizationExamples, hasLength(8));
    expect(
      {
        for (final example in hangulLiquidizationExamples)
          example.writtenForm: example.pronunciation,
      },
      const {
        '신라': '실라',
        '난로': '날ː로',
        '연락': '열락',
        '신랑': '실랑',
        '설날': '설ː랄',
        '칼날': '칼랄',
        '물난리': '물랄리',
        '실내': '실래',
      },
    );
    expect(
      hangulLiquidizationExamples.map((example) => example.writtenForm).toSet(),
      hasLength(8),
    );
    for (final example in hangulLiquidizationExamples) {
      expect(example.writtenForm, '${example.beforePart}${example.afterPart}');
      expect(example.rule, isIn(const ['ㄴ + ㄹ → [ㄹㄹ]', 'ㄹ + ㄴ → [ㄹㄹ]']));
      expect(example.koreanExplanation, isNotEmpty);
      expect(example.vietnameseExplanation, isNotEmpty);
    }
  });

  test('liquidization quiz has 8 questions with explicit unique answers', () {
    expect(hangulLiquidizationQuizQuestions, hasLength(8));
    expect(
      hangulLiquidizationQuizQuestions
          .map((question) => question.correctAnswer)
          .toList(),
      const ['실라', '날ː로', '열락', '실랑', '설ː랄', '칼랄', '물랄리', '실래'],
    );
    for (final question in hangulLiquidizationQuizQuestions) {
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

  testWidgets(
    'liquidization follows nasalization and learning screen renders',
    (tester) async {
      final speechPlayer = _TestKoreanSpeechPlayer();
      _useSmallScreen(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: HangulBasicsScreen(liquidizationSpeechPlayer: speechPlayer),
        ),
      );

      final liquidization = find.byKey(const Key('liquidization-course'));
      await tester.scrollUntilVisible(
        liquidization,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      final nasalization = find.byKey(const Key('nasalization-course'));
      expect(nasalization, findsOneWidget);
      expect(
        tester.getTopLeft(nasalization).dy,
        lessThan(tester.getTopLeft(liquidization).dy),
      );
      expect(find.text('유음화 · Biến âm lỏng'), findsOneWidget);
      expect(find.textContaining('ㄴ + ㄹ / ㄹ + ㄴ → ㄹㄹ'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(liquidization);
      await tester.tap(liquidization);
      await tester.pumpAndSettle();
      expect(find.text('유음화 · Biến âm lỏng'), findsOneWidget);
      expect(find.textContaining('ㄴ + ㄹ → [ㄹㄹ]'), findsOneWidget);
      expect(find.textContaining('ㄹ + ㄴ → [ㄹㄹ]'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('learning TTS and quiz flow work on a 360x640 screen', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulLiquidizationLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    final firstAudio = find.byKey(const ValueKey('liquidization-audio-신라'));
    await tester.scrollUntilVisible(
      firstAudio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(firstAudio);
    await tester.pumpAndSettle();
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['실라']);
    expect(tester.widget<IconButton>(firstAudio).onPressed, isNull);
    speechPlayer.completeSpeech();
    await tester.pump();

    for (final example in hangulLiquidizationExamples) {
      final card = find.byKey(ValueKey('liquidization-${example.writtenForm}'));
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    final startButton = find.byKey(const Key('start-liquidization-quiz'));
    await tester.scrollUntilVisible(
      startButton,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    expect(find.byKey(const Key('liquidization-quiz-result')), findsOneWidget);
    expect(find.text('8/8 정답 · câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-liquidization-quiz')));
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    await tester.tap(find.byKey(const Key('back-to-liquidization-learning')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('start-liquidization-quiz')), findsOneWidget);
    expect(find.text('유음화 · Biến âm lỏng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulLiquidizationQuizQuestions) {
    final option = find.byKey(
      ValueKey('liquidization-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester.widget<InkWell>(option).onTap!();
    await tester.pump();
    expect(
      find.byKey(const Key('liquidization-quiz-feedback')),
      findsOneWidget,
    );
    final nextButton = find.byKey(const Key('next-liquidization-question'));
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
