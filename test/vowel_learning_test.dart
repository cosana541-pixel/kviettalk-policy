import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/basic_vowel_quiz.dart';
import 'package:korean_vietnamese_app/data/basic_vowels.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/vowel_learning_screen.dart';
import 'package:korean_vietnamese_app/screens/vowel_quiz_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('basic vowel data contains all 10 vowels in learning order', () {
    expect(basicVowels, hasLength(10));
    expect(basicVowels.map((item) => item.character).toList(), const [
      'ㅏ',
      'ㅑ',
      'ㅓ',
      'ㅕ',
      'ㅗ',
      'ㅛ',
      'ㅜ',
      'ㅠ',
      'ㅡ',
      'ㅣ',
    ]);
    expect(basicVowels.first.name, '아 (a)');
    expect(basicVowels.first.pronunciationGuide, contains('a ngắn'));
    expect(basicVowels.first.examples, const ['가', '나']);
  });

  test('vowel quiz has 10 questions and all four requested types', () {
    expect(basicVowelQuizQuestions, hasLength(10));
    expect(
      basicVowelQuizQuestions.map((question) => question.type).toSet(),
      const {
        HangulQuizQuestionType.matchingCharacter,
        HangulQuizQuestionType.vowelInSyllable,
        HangulQuizQuestionType.syllableWithVowel,
        HangulQuizQuestionType.pronunciationGuide,
      },
    );

    for (final question in basicVowelQuizQuestions) {
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(
        question.options.where((option) => option == question.correctAnswer),
        hasLength(1),
      );
      expect(question.explanation, isNotEmpty);
    }
  });

  testWidgets('Hangeul basics opens the basic vowel course', (tester) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);

    await tester.pumpWidget(
      MaterialApp(home: HangulBasicsScreen(vowelSpeechPlayer: speechPlayer)),
    );

    expect(find.text('Phụ âm cơ bản'), findsOneWidget);
    expect(find.text('Nguyên âm cơ bản'), findsOneWidget);
    expect(find.byKey(const Key('basic-vowels-course')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('basic-vowels-course')));
    await tester.pumpAndSettle();

    expect(find.text('10 nguyên âm cơ bản'), findsOneWidget);
    expect(find.byKey(const ValueKey('vowel-ㅏ')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('vowel learning shows audio controls and starts quiz', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);

    await tester.pumpWidget(
      MaterialApp(home: VowelLearningScreen(speechPlayer: speechPlayer)),
    );

    expect(find.byKey(const ValueKey('vowel-ㅏ')), findsOneWidget);
    expect(find.text('Tên: 아 (a)'), findsOneWidget);
    expect(
      find.text('Âm gần giống a ngắn; mở miệng tự nhiên.'),
      findsOneWidget,
    );
    expect(find.text('Ví dụ: 가, 나'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('vowel-character-audio-ㅏ')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('vowel-examples-audio-ㅏ')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('vowel-character-audio-ㅏ')));
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['아']);

    await tester.tap(find.byKey(const ValueKey('vowel-examples-audio-ㅏ')));
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['아']);

    speechPlayer.completeSpeech();
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('vowel-examples-audio-ㅏ')));
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['아', '가, 나']);
    speechPlayer.completeSpeech();
    await tester.pump();

    for (final vowel in basicVowels) {
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('vowel-${vowel.character}')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byKey(ValueKey('vowel-${vowel.character}')), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await tester.scrollUntilVisible(
      find.byKey(const Key('start-vowel-quiz')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('start-vowel-quiz')));
    await tester.pumpAndSettle();

    expect(find.text('Quiz nguyên âm'), findsOneWidget);
    expect(find.byKey(const Key('vowel-quiz-prompt')), findsOneWidget);
    expect(_vowelOptionFinder(), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('vowel quiz shows feedback and advances', (tester) async {
    _useSmallScreen(tester);
    await tester.pumpWidget(const MaterialApp(home: VowelQuizScreen()));

    final firstQuestion = basicVowelQuizQuestions.first;
    expect(find.text(firstQuestion.prompt), findsOneWidget);
    expect(_vowelOptionFinder(), findsNWidgets(4));

    final firstCorrectOption = find.byKey(
      ValueKey('vowel-option-${firstQuestion.correctAnswer}'),
    );
    await tester.ensureVisible(firstCorrectOption);
    await tester.pumpAndSettle();
    tester.widget<InkWell>(firstCorrectOption).onTap!();
    await tester.pump();

    expect(find.text('Chính xác!'), findsOneWidget);
    expect(find.byKey(const Key('vowel-quiz-feedback')), findsOneWidget);

    final nextButton = find.byKey(const Key('next-vowel-question'));
    await tester.scrollUntilVisible(
      nextButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pump();

    expect(find.text(firstQuestion.prompt), findsNothing);
    expect(find.text('2/10'), findsOneWidget);
    expect(_vowelOptionFinder(), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('vowel quiz completes all 10 questions and shows result', (
    tester,
  ) async {
    _useSmallScreen(tester);
    await tester.pumpWidget(const MaterialApp(home: VowelQuizScreen()));

    for (final question in basicVowelQuizQuestions) {
      await tester.drag(
        find.byKey(const Key('vowel-quiz-question')),
        const Offset(0, 1000),
      );
      await tester.pumpAndSettle();

      final correctOption = find.byKey(
        ValueKey('vowel-option-${question.correctAnswer}'),
      );
      await tester.scrollUntilVisible(
        correctOption,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      tester.widget<InkWell>(correctOption).onTap!();
      await tester.pump();

      final nextButton = find.byKey(const Key('next-vowel-question'));
      await tester.scrollUntilVisible(
        nextButton,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(nextButton);
      await tester.pump();
      expect(tester.takeException(), isNull);
    }

    expect(find.byKey(const Key('vowel-quiz-result')), findsOneWidget);
    expect(find.text('10/10 câu đúng'), findsOneWidget);
    expect(find.byKey(const Key('retry-vowel-quiz')), findsOneWidget);
    expect(find.byKey(const Key('back-to-vowel-learning')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Finder _vowelOptionFinder() {
  return find.byWidgetPredicate(
    (widget) =>
        widget.key is ValueKey<String> &&
        ((widget.key! as ValueKey<String>).value).startsWith('vowel-option-'),
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
    completeSpeech();
  }
}
