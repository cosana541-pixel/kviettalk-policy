import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/final_consonant_quiz.dart';
import 'package:korean_vietnamese_app/data/final_consonants.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/final_consonant_learning_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('final consonant data has all 16 letters in learning order', () {
    expect(finalConsonants, hasLength(16));
    expect(finalConsonants.map((item) => item.character).toList(), const [
      'ㄱ',
      'ㄲ',
      'ㄴ',
      'ㄷ',
      'ㄹ',
      'ㅁ',
      'ㅂ',
      'ㅅ',
      'ㅆ',
      'ㅇ',
      'ㅈ',
      'ㅊ',
      'ㅋ',
      'ㅌ',
      'ㅍ',
      'ㅎ',
    ]);
    expect(finalConsonants.map((item) => item.name).toList(), const [
      '각',
      '밖',
      '간',
      '곧',
      '갈',
      '감',
      '갑',
      '갓',
      '갔',
      '강',
      '낮',
      '빛',
      '부엌',
      '밭',
      '앞',
      '좋',
    ]);
    for (final consonant in finalConsonants) {
      expect(consonant.pronunciationGuide, isNotEmpty);
      expect(consonant.examples, isNotEmpty);
      expect(consonant.examples.length, lessThanOrEqualTo(2));
    }
  });

  test('all final consonants map to the seven representative sounds', () {
    expect(finalConsonantSoundGroups, hasLength(16));
    expect(finalConsonantSoundGroups.values.toSet(), const {
      'ㄱ',
      'ㄴ',
      'ㄷ',
      'ㄹ',
      'ㅁ',
      'ㅂ',
      'ㅇ',
    });
    expect(finalConsonantSoundGroups, const {
      'ㄱ': 'ㄱ',
      'ㄲ': 'ㄱ',
      'ㄴ': 'ㄴ',
      'ㄷ': 'ㄷ',
      'ㄹ': 'ㄹ',
      'ㅁ': 'ㅁ',
      'ㅂ': 'ㅂ',
      'ㅅ': 'ㄷ',
      'ㅆ': 'ㄷ',
      'ㅇ': 'ㅇ',
      'ㅈ': 'ㄷ',
      'ㅊ': 'ㄷ',
      'ㅋ': 'ㄱ',
      'ㅌ': 'ㄷ',
      'ㅍ': 'ㅂ',
      'ㅎ': 'ㄷ',
    });
  });

  test('final consonant quiz has 16 valid four-choice questions', () {
    expect(finalConsonantQuizQuestions, hasLength(16));
    expect(
      finalConsonantQuizQuestions.map((question) => question.type).toSet(),
      const {
        HangulQuizQuestionType.vowelInSyllable,
        HangulQuizQuestionType.initialConsonant,
        HangulQuizQuestionType.pronunciationGuide,
        HangulQuizQuestionType.matchingCharacter,
      },
    );
    expect(
      finalConsonantQuizQuestions.map((question) => question.correctAnswer),
      finalConsonants.map((item) => item.character),
    );
    for (final question in finalConsonantQuizQuestions) {
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(
        question.options.where((option) => option == question.correctAnswer),
        hasLength(1),
      );
      expect(question.explanation, isNotEmpty);
    }
  });

  testWidgets('Hangeul basics opens final consonants after compound vowels', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulBasicsScreen(finalConsonantSpeechPlayer: speechPlayer),
      ),
    );

    final course = find.byKey(const Key('final-consonants-course'));
    await tester.scrollUntilVisible(
      course,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const Key('compound-vowels-course')), findsOneWidget);
    expect(find.text('Phụ âm cuối đơn'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(course);
    await tester.pumpAndSettle();
    await tester.tap(course);
    await tester.pumpAndSettle();
    expect(find.text('16 phụ âm cuối đơn (홑받침)'), findsOneWidget);
    expect(find.byKey(const ValueKey('final-consonant-ㄱ')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('all cards show syllables, groups and guarded TTS', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: FinalConsonantLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    expect(find.text('Âm tiết đại diện: 각'), findsOneWidget);
    expect(find.text('Âm cuối đại diện: [ㄱ]'), findsOneWidget);
    expect(find.text('Ví dụ: 각, 국'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('final-consonant-syllable-audio-ㄱ')),
    );
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['각']);

    final examplesAudio = find.byKey(
      const ValueKey('final-consonant-examples-audio-ㄱ'),
    );
    await tester.ensureVisible(examplesAudio);
    await tester.pumpAndSettle();
    await tester.tap(examplesAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['각']);

    speechPlayer.completeSpeech();
    await tester.pump();
    await tester.ensureVisible(examplesAudio);
    await tester.pumpAndSettle();
    await tester.tap(examplesAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['각', '각, 국']);
    speechPlayer.completeSpeech();
    await tester.pump();

    for (final consonant in finalConsonants) {
      final card = find.byKey(
        ValueKey('final-consonant-${consonant.character}'),
      );
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(find.text('Âm tiết đại diện: ${consonant.name}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
  });

  testWidgets('learning starts quiz and quiz shows feedback', (tester) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: FinalConsonantLearningScreen(speechPlayer: speechPlayer),
      ),
    );
    final startButton = find.byKey(const Key('start-final-consonant-quiz'));
    await tester.scrollUntilVisible(
      startButton,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(startButton);
    await tester.pumpAndSettle();
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    expect(find.text('Quiz phụ âm cuối đơn'), findsOneWidget);
    expect(find.text('1/16'), findsOneWidget);
    expect(_optionFinder(), findsNWidgets(4));

    _tapAnswer(tester, finalConsonantQuizQuestions.first.correctAnswer);
    await tester.pump();
    expect(find.text('Chính xác!'), findsOneWidget);
    expect(
      find.byKey(const Key('final-consonant-quiz-feedback')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('quiz completes, retries, and returns to learning', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: FinalConsonantLearningScreen(speechPlayer: speechPlayer),
      ),
    );
    final startButton = find.byKey(const Key('start-final-consonant-quiz'));
    await tester.scrollUntilVisible(
      startButton,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(startButton);
    await tester.pumpAndSettle();
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    await _completeQuiz(tester);

    expect(
      find.byKey(const Key('final-consonant-quiz-result')),
      findsOneWidget,
    );
    expect(find.text('16/16 câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-final-consonant-quiz')));
    await tester.pump();
    expect(find.text('1/16'), findsOneWidget);

    await _completeQuiz(tester);
    await tester.tap(find.byKey(const Key('back-to-final-consonant-learning')));
    await tester.pumpAndSettle();
    expect(find.text('Phụ âm cuối đơn'), findsOneWidget);
    expect(find.byKey(const Key('start-final-consonant-quiz')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in finalConsonantQuizQuestions) {
    await tester.drag(
      find.byKey(const Key('final-consonant-quiz-question')),
      const Offset(0, 1000),
    );
    await tester.pumpAndSettle();
    final option = find.byKey(
      ValueKey('final-consonant-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    _tapAnswer(tester, question.correctAnswer);
    await tester.pump();
    final nextButton = find.byKey(const Key('next-final-consonant-question'));
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
  final finder = find.byKey(ValueKey('final-consonant-option-$answer'));
  tester.widget<InkWell>(finder).onTap!();
}

Finder _optionFinder() {
  return find.byWidgetPredicate(
    (widget) =>
        widget.key is ValueKey<String> &&
        ((widget.key! as ValueKey<String>).value).startsWith(
          'final-consonant-option-',
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
