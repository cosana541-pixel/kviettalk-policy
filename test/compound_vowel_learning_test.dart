import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/compound_vowel_quiz.dart';
import 'package:korean_vietnamese_app/data/compound_vowels.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/compound_vowel_learning_screen.dart';
import 'package:korean_vietnamese_app/screens/compound_vowel_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('compound vowel data contains all 11 vowels in learning order', () {
    expect(compoundVowels, hasLength(11));
    expect(compoundVowels.map((item) => item.character).toList(), const [
      'ㅐ',
      'ㅔ',
      'ㅘ',
      'ㅙ',
      'ㅚ',
      'ㅝ',
      'ㅞ',
      'ㅟ',
      'ㅢ',
      'ㅒ',
      'ㅖ',
    ]);
    expect(compoundVowels.first.name, '애 (ae)');
    expect(compoundVowels.first.pronunciationGuide, contains('gần giống'));
    expect(compoundVowels.first.examples, const ['개', '내']);
    expect(compoundVowels[2].name, '와 (wa)');
  });

  test('compound vowel quiz has 11 valid four-choice questions', () {
    expect(compoundVowelQuizQuestions, hasLength(11));
    expect(
      compoundVowelQuizQuestions.map((question) => question.type).toSet(),
      const {
        HangulQuizQuestionType.matchingCharacter,
        HangulQuizQuestionType.vowelInSyllable,
        HangulQuizQuestionType.syllableWithVowel,
        HangulQuizQuestionType.pronunciationGuide,
      },
    );

    for (final question in compoundVowelQuizQuestions) {
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(
        question.options.where((option) => option == question.correctAnswer),
        hasLength(1),
      );
      expect(question.explanation, isNotEmpty);
    }
  });

  testWidgets('Hangeul basics opens the compound vowel course', (tester) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulBasicsScreen(compoundVowelSpeechPlayer: speechPlayer),
      ),
    );

    expect(find.text('Phụ âm cơ bản'), findsOneWidget);
    expect(find.text('Nguyên âm cơ bản'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('compound-vowels-course')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Nguyên âm ghép'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('compound-vowels-course')));
    await tester.pumpAndSettle();

    expect(find.text('11 nguyên âm ghép'), findsOneWidget);
    expect(find.byKey(const ValueKey('compound-vowel-ㅐ')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning cards use stable syllable TTS and block repeat taps', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: CompoundVowelLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    expect(find.text('Tên: 애 (ae)'), findsOneWidget);
    expect(find.text('Ví dụ: 개, 내'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(
      find.byKey(const ValueKey('compound-vowel-character-audio-ㅐ')),
    );
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['애']);
    expect(speechPlayer.spokenTexts, isNot(contains('ㅐ')));

    await tester.tap(
      find.byKey(const ValueKey('compound-vowel-examples-audio-ㅐ')),
    );
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['애']);

    speechPlayer.completeSpeech();
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('compound-vowel-examples-audio-ㅐ')),
    );
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['애', '개, 내']);
    speechPlayer.completeSpeech();
    await tester.pump();

    for (final vowel in compoundVowels) {
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('compound-vowel-${vowel.character}')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        find.byKey(ValueKey('compound-vowel-${vowel.character}')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
  });

  testWidgets('learning starts the compound vowel quiz', (tester) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: CompoundVowelLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('start-compound-vowel-quiz')),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('start-compound-vowel-quiz')));
    await tester.pumpAndSettle();

    expect(find.text('Quiz nguyên âm ghép'), findsOneWidget);
    expect(find.byKey(const Key('compound-vowel-quiz-prompt')), findsOneWidget);
    expect(_optionFinder(), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('quiz shows feedback and advances', (tester) async {
    _useSmallScreen(tester);
    await tester.pumpWidget(const MaterialApp(home: CompoundVowelQuizScreen()));

    final firstQuestion = compoundVowelQuizQuestions.first;
    _tapAnswer(tester, firstQuestion.correctAnswer);
    await tester.pump();
    expect(find.text('Chính xác!'), findsOneWidget);
    expect(
      find.byKey(const Key('compound-vowel-quiz-feedback')),
      findsOneWidget,
    );

    final nextButton = find.byKey(const Key('next-compound-vowel-question'));
    await tester.scrollUntilVisible(
      nextButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(nextButton);
    await tester.pump();
    expect(find.text('2/11'), findsOneWidget);
    expect(_optionFinder(), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('quiz completes all questions and retries', (tester) async {
    _useSmallScreen(tester);
    await tester.pumpWidget(const MaterialApp(home: CompoundVowelQuizScreen()));

    await _completeQuiz(tester);
    expect(find.byKey(const Key('compound-vowel-quiz-result')), findsOneWidget);
    expect(find.text('11/11 câu đúng'), findsOneWidget);
    expect(
      find.byKey(const Key('back-to-compound-vowel-learning')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-compound-vowel-quiz')));
    await tester.pump();
    expect(find.text('1/11'), findsOneWidget);
    expect(find.text(compoundVowelQuizQuestions.first.prompt), findsOneWidget);
  });

  testWidgets('quiz result returns to compound vowel learning', (tester) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: CompoundVowelLearningScreen(speechPlayer: speechPlayer),
      ),
    );
    await tester.scrollUntilVisible(
      find.byKey(const Key('start-compound-vowel-quiz')),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('start-compound-vowel-quiz')));
    await tester.pumpAndSettle();
    await _completeQuiz(tester);

    await tester.tap(find.byKey(const Key('back-to-compound-vowel-learning')));
    await tester.pumpAndSettle();
    expect(find.text('Nguyên âm ghép'), findsOneWidget);
    expect(find.byKey(const Key('start-compound-vowel-quiz')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in compoundVowelQuizQuestions) {
    await tester.drag(
      find.byKey(const Key('compound-vowel-quiz-question')),
      const Offset(0, 1000),
    );
    await tester.pumpAndSettle();
    final correctOption = find.byKey(
      ValueKey('compound-vowel-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      correctOption,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    _tapAnswer(tester, question.correctAnswer);
    await tester.pump();
    final nextButton = find.byKey(const Key('next-compound-vowel-question'));
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

void _tapAnswer(WidgetTester tester, String answer) {
  final finder = find.byKey(ValueKey('compound-vowel-option-$answer'));
  tester.widget<InkWell>(finder).onTap!();
}

Finder _optionFinder() {
  return find.byWidgetPredicate(
    (widget) =>
        widget.key is ValueKey<String> &&
        ((widget.key! as ValueKey<String>).value).startsWith(
          'compound-vowel-option-',
        ),
  );
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
