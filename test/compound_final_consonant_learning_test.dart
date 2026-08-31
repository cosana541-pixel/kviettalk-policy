import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/compound_final_consonant_quiz.dart';
import 'package:korean_vietnamese_app/data/compound_final_consonants.dart';
import 'package:korean_vietnamese_app/screens/compound_final_consonant_learning_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('compound final consonant data has all 11 letters in order', () {
    expect(compoundFinalConsonants, hasLength(11));
    expect(
      compoundFinalConsonants.map((item) => item.character).toList(),
      const ['ㄳ', 'ㄵ', 'ㄶ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅄ'],
    );
    expect(compoundFinalConsonantSoundGroups, const {
      'ㄳ': 'ㄱ',
      'ㄵ': 'ㄴ',
      'ㄶ': 'ㄴ',
      'ㄺ': 'ㄱ',
      'ㄻ': 'ㅁ',
      'ㄼ': 'ㄹ',
      'ㄽ': 'ㄹ',
      'ㄾ': 'ㄹ',
      'ㄿ': 'ㅂ',
      'ㅀ': 'ㄹ',
      'ㅄ': 'ㅂ',
    });
    for (final consonant in compoundFinalConsonants) {
      expect(consonant.name, isNotEmpty);
      expect(
        consonant.pronunciationGuide,
        contains('[${compoundFinalConsonantSoundGroups[consonant.character]}]'),
      );
      expect(consonant.examples, isNotEmpty);
      expect(consonant.examples.length, lessThanOrEqualTo(2));
    }
  });

  test('compound final consonant quiz has 11 unique valid answers', () {
    expect(compoundFinalConsonantQuizQuestions, hasLength(11));
    expect(
      compoundFinalConsonantQuizQuestions.map(
        (question) => question.correctAnswer,
      ),
      compoundFinalConsonants.map((item) => item.character),
    );
    expect(
      compoundFinalConsonantQuizQuestions
          .map((question) => question.correctAnswer)
          .toSet(),
      hasLength(11),
    );
    for (final question in compoundFinalConsonantQuizQuestions) {
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(
        question.options.where((option) => option == question.correctAnswer),
        hasLength(1),
      );
      expect(question.explanation, isNotEmpty);
    }
  });

  testWidgets('Hangeul basics opens compound final consonants after finals', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulBasicsScreen(
          compoundFinalConsonantSpeechPlayer: speechPlayer,
        ),
      ),
    );

    final course = find.byKey(const Key('compound-final-consonants-course'));
    await tester.scrollUntilVisible(
      course,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const Key('final-consonants-course')), findsOneWidget);
    expect(find.text('Phụ âm cuối kép'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(course);
    await tester.pumpAndSettle();
    await tester.tap(course);
    await tester.pumpAndSettle();
    expect(find.text('11 phụ âm cuối kép (겹받침)'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('compound-final-consonant-ㄳ')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning cards play guarded TTS and stop on dispose', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: CompoundFinalConsonantLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    expect(find.text('Từ đại diện: 넋'), findsOneWidget);
    expect(find.text('Âm cuối đại diện: [ㄱ]'), findsOneWidget);
    expect(find.text('Ví dụ: 넋, 몫'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('compound-final-consonant-syllable-audio-ㄳ')),
    );
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['넋']);

    final examplesAudio = find.byKey(
      const ValueKey('compound-final-consonant-examples-audio-ㄳ'),
    );
    await tester.tap(examplesAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['넋']);

    speechPlayer.completeSpeech();
    await tester.pump();
    await tester.tap(examplesAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['넋', '넋, 몫']);
    speechPlayer.completeSpeech();
    await tester.pump();

    for (final consonant in compoundFinalConsonants) {
      final card = find.byKey(
        ValueKey('compound-final-consonant-${consonant.character}'),
      );
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(find.text('Từ đại diện: ${consonant.name}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
  });

  testWidgets(
    'learning quiz completes, retries, and returns without overflow',
    (tester) async {
      final speechPlayer = _TestKoreanSpeechPlayer();
      _useSmallScreen(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: CompoundFinalConsonantLearningScreen(
            speechPlayer: speechPlayer,
          ),
        ),
      );
      final startButton = find.byKey(
        const Key('start-compound-final-consonant-quiz'),
      );
      await tester.scrollUntilVisible(
        startButton,
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(startButton);
      await tester.pumpAndSettle();
      await tester.tap(startButton);
      await tester.pumpAndSettle();
      expect(find.text('1/11'), findsOneWidget);
      expect(_optionFinder(), findsNWidgets(4));

      await _completeQuiz(tester);
      expect(
        find.byKey(const Key('compound-final-consonant-quiz-result')),
        findsOneWidget,
      );
      expect(find.text('11/11 câu đúng'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(
        find.byKey(const Key('retry-compound-final-consonant-quiz')),
      );
      await tester.pump();
      expect(find.text('1/11'), findsOneWidget);

      await _completeQuiz(tester);
      await tester.tap(
        find.byKey(const Key('back-to-compound-final-consonant-learning')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Phụ âm cuối kép'), findsOneWidget);
      expect(
        find.byKey(const Key('start-compound-final-consonant-quiz')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in compoundFinalConsonantQuizQuestions) {
    await tester.drag(
      find.byKey(const Key('compound-final-consonant-quiz-question')),
      const Offset(0, 1000),
    );
    await tester.pumpAndSettle();
    final option = find.byKey(
      ValueKey('compound-final-consonant-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester.widget<InkWell>(option).onTap!();
    await tester.pump();
    final nextButton = find.byKey(
      const Key('next-compound-final-consonant-question'),
    );
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

Finder _optionFinder() {
  return find.byWidgetPredicate(
    (widget) =>
        widget.key is ValueKey<String> &&
        ((widget.key! as ValueKey<String>).value).startsWith(
          'compound-final-consonant-option-',
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
