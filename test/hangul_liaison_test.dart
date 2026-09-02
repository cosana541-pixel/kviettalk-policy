import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_liaison.dart';
import 'package:korean_vietnamese_app/data/hangul_liaison_quiz.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_liaison_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('liaison learning data has 12 verified basic examples', () {
    expect(hangulLiaisonExamples, hasLength(12));
    expect(
      {
        for (final example in hangulLiaisonExamples)
          example.writtenForm: example.pronunciation,
      },
      const {
        '먹어요': '머거요',
        '문을': '무늘',
        '닫아요': '다다요',
        '달이': '다리',
        '밤에': '바메',
        '집에': '지베',
        '옷이': '오시',
        '낮에': '나제',
        '꽃을': '꼬츨',
        '부엌에': '부어케',
        '밭에': '바테',
        '앞에': '아페',
      },
    );
    expect(
      hangulLiaisonExamples.map((example) => example.finalConsonant).toSet(),
      const {'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ'},
    );
    for (final example in hangulLiaisonExamples) {
      expect(example.writtenForm, isNotEmpty);
      expect(example.pronunciation, isNotEmpty);
      expect(example.beforePart, isNotEmpty);
      expect(example.afterPart, isNotEmpty);
      expect(example.explanation, isNotEmpty);
      expect(example.writtenForm, '${example.beforePart}${example.afterPart}');
    }
  });

  test(
    'liaison quiz has 12 unique valid four-choice questions and 4 types',
    () {
      expect(hangulLiaisonQuizQuestions, hasLength(12));
      expect(
        hangulLiaisonQuizQuestions.map((question) => question.prompt).toSet(),
        hasLength(12),
      );
      expect(
        hangulLiaisonQuizQuestions.map((question) => question.type).toSet(),
        const {
          HangulQuizQuestionType.pronunciationGuide,
          HangulQuizQuestionType.matchingCharacter,
          HangulQuizQuestionType.finalConsonant,
          HangulQuizQuestionType.combiningSyllable,
        },
      );
      for (final question in hangulLiaisonQuizQuestions) {
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
    'Hangeul basics opens liaison immediately after syllable building',
    (tester) async {
      final speechPlayer = _TestKoreanSpeechPlayer();
      _useSmallScreen(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: HangulBasicsScreen(liaisonSpeechPlayer: speechPlayer),
        ),
      );

      final course = find.byKey(const Key('liaison-course'));
      await tester.scrollUntilVisible(
        course,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byKey(const Key('syllable-building-course')), findsOneWidget);
      expect(find.text('Nối âm (연음)'), findsOneWidget);
      expect(
        find.text('받침 + nguyên âm · Nghe cách nối âm · Quiz'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(course);
      await tester.pumpAndSettle();
      await tester.tap(course);
      await tester.pumpAndSettle();
      expect(find.text('받침 nối sang âm tiết tiếp theo'), findsOneWidget);
      expect(find.byKey(const ValueKey('liaison-먹어요')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'learning cards show contrasts and use guarded written-form TTS',
    (tester) async {
      final speechPlayer = _TestKoreanSpeechPlayer();
      _useSmallScreen(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: HangulLiaisonLearningScreen(speechPlayer: speechPlayer),
        ),
      );

      expect(find.text('먹 + 어요'), findsOneWidget);
      expect(find.text('머거요'), findsWidgets);
      await tester.tap(find.byKey(const ValueKey('liaison-audio-먹어요')));
      await tester.pump();
      expect(speechPlayer.spokenTexts, const ['먹어요']);
      final playingButton = tester.widget<IconButton>(
        find.byKey(const ValueKey('liaison-audio-먹어요')),
      );
      expect(playingButton.onPressed, isNull);
      expect(speechPlayer.spokenTexts, const ['먹어요']);

      speechPlayer.completeSpeech();
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('liaison-audio-먹어요')));
      await tester.pump();
      expect(speechPlayer.spokenTexts, const ['먹어요', '먹어요']);
      speechPlayer.completeSpeech();
      await tester.pump();

      for (final example in hangulLiaisonExamples) {
        final card = find.byKey(ValueKey('liaison-${example.writtenForm}'));
        await tester.scrollUntilVisible(
          card,
          350,
          scrollable: find.byType(Scrollable).first,
        );
        expect(card, findsOneWidget);
        expect(
          find.byKey(ValueKey('liaison-pronunciation-${example.writtenForm}')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      }

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(speechPlayer.stopCalls, 1);
    },
  );

  testWidgets(
    'quiz completes, retries, returns, and has no small-screen overflow',
    (tester) async {
      final speechPlayer = _TestKoreanSpeechPlayer();
      _useSmallScreen(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: HangulLiaisonLearningScreen(speechPlayer: speechPlayer),
        ),
      );

      final startButton = find.byKey(const Key('start-liaison-quiz'));
      await tester.scrollUntilVisible(
        startButton,
        600,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(startButton);
      await tester.pumpAndSettle();
      await tester.tap(startButton);
      await tester.pumpAndSettle();
      expect(find.text('1/12'), findsOneWidget);
      expect(_optionFinder(), findsNWidgets(4));

      await _completeQuiz(tester);
      expect(find.byKey(const Key('liaison-quiz-result')), findsOneWidget);
      expect(find.text('12/12 câu đúng'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const Key('retry-liaison-quiz')));
      await tester.pump();
      expect(find.text('1/12'), findsOneWidget);

      await _completeQuiz(tester);
      await tester.tap(find.byKey(const Key('back-to-liaison-learning')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('start-liaison-quiz')), findsOneWidget);
      expect(find.text('Nối âm trong tiếng Hàn (연음)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulLiaisonQuizQuestions) {
    await tester.drag(
      find.byKey(const Key('liaison-quiz-question')),
      const Offset(0, 1000),
    );
    await tester.pumpAndSettle();
    final option = find.byKey(
      ValueKey('liaison-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester.widget<InkWell>(option).onTap!();
    await tester.pump();
    final nextButton = find.byKey(const Key('next-liaison-question'));
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
      ((widget.key! as ValueKey<String>).value).startsWith('liaison-option-'),
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
