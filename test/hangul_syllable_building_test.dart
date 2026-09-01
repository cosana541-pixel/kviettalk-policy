import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_syllable_building.dart';
import 'package:korean_vietnamese_app/data/hangul_syllable_building_quiz.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_syllable_building_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test(
    'learning data has complete fields and intended syllable combinations',
    () {
      expect(hangulSyllableBuildingExamples, hasLength(12));
      expect(
        hangulSyllableBuildingExamples.where(
          (item) => item.stage == HangulSyllableBuildingStage.initialAndVowel,
        ),
        hasLength(4),
      );
      expect(
        hangulSyllableBuildingExamples.where(
          (item) =>
              item.stage == HangulSyllableBuildingStage.simpleFinalConsonant,
        ),
        hasLength(4),
      );
      expect(
        hangulSyllableBuildingExamples.where(
          (item) =>
              item.stage == HangulSyllableBuildingStage.compoundFinalConsonant,
        ),
        hasLength(4),
      );

      const intendedCombinations = <String, String>{
        'ㄱ + ㅏ': '가',
        'ㄴ + ㅓ': '너',
        'ㅁ + ㅜ': '무',
        'ㅅ + ㅣ': '시',
        'ㄱ + ㅏ + ㄴ': '간',
        'ㅂ + ㅏ + ㅂ': '밥',
        'ㅎ + ㅏ + ㄴ': '한',
        'ㅁ + ㅜ + ㄹ': '물',
        'ㄷ + ㅏ + ㄺ': '닭',
        'ㄱ + ㅏ + ㅄ': '값',
        'ㅅ + ㅏ + ㄻ': '삶',
        'ㅁ + ㅗ + ㄳ': '몫',
      };
      expect({
        for (final item in hangulSyllableBuildingExamples)
          item.formula: item.syllable,
      }, intendedCombinations);
      for (final item in hangulSyllableBuildingExamples) {
        expect(item.initialConsonant, isNotEmpty);
        expect(item.vowel, isNotEmpty);
        expect(item.syllable, isNotEmpty);
        expect(item.explanation, contains(item.syllable));
        if (item.stage == HangulSyllableBuildingStage.initialAndVowel) {
          expect(item.finalConsonant, isNull);
        } else {
          expect(item.finalConsonant, isNotEmpty);
        }
      }
    },
  );

  test(
    'quiz has 12 valid unique four-choice questions and all required types',
    () {
      expect(hangulSyllableBuildingQuizQuestions, hasLength(12));
      expect(
        hangulSyllableBuildingQuizQuestions
            .map((question) => question.type)
            .toSet(),
        containsAll(const {
          HangulQuizQuestionType.combiningSyllable,
          HangulQuizQuestionType.finalConsonant,
          HangulQuizQuestionType.decomposingSyllable,
        }),
      );
      for (final question in hangulSyllableBuildingQuizQuestions) {
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

  testWidgets('Hangeul basics opens syllable building after compound finals', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulBasicsScreen(syllableBuildingSpeechPlayer: speechPlayer),
      ),
    );

    final course = find.byKey(const Key('syllable-building-course'));
    await tester.scrollUntilVisible(
      course,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      find.byKey(const Key('compound-final-consonants-course')),
      findsOneWidget,
    );
    expect(find.text('Ghép âm tiết Hangul'), findsOneWidget);
    expect(find.text('Hiểu cấu trúc 초성 + 중성 (+ 종성) · Quiz'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(course);
    await tester.pumpAndSettle();
    await tester.tap(course);
    await tester.pumpAndSettle();
    expect(find.text('Cấu tạo một âm tiết Hangul'), findsOneWidget);
    expect(find.byKey(const ValueKey('syllable-building-가')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning cards play guarded TTS and stop on dispose', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulSyllableBuildingLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    expect(find.text('ㄱ + ㅏ  →  가'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('syllable-audio-가')));
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['가']);
    final playingButton = tester.widget<IconButton>(
      find.byKey(const ValueKey('syllable-audio-가')),
    );
    expect(playingButton.onPressed, isNull);
    expect(speechPlayer.spokenTexts, const ['가']);

    speechPlayer.completeSpeech();
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('syllable-audio-가')));
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['가', '가']);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'quiz completes, retries, returns to learning, and has no small-screen overflow',
    (tester) async {
      final speechPlayer = _TestKoreanSpeechPlayer();
      _useSmallScreen(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: HangulSyllableBuildingLearningScreen(
            speechPlayer: speechPlayer,
          ),
        ),
      );
      final startButton = find.byKey(const Key('start-syllable-building-quiz'));
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
      expect(
        find.byKey(const Key('syllable-building-quiz-result')),
        findsOneWidget,
      );
      expect(find.text('12/12 câu đúng'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const Key('retry-syllable-building-quiz')));
      await tester.pump();
      expect(find.text('1/12'), findsOneWidget);

      await _completeQuiz(tester);
      await tester.tap(
        find.byKey(const Key('back-to-syllable-building-learning')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('start-syllable-building-quiz')),
        findsOneWidget,
      );
      expect(find.text('Ghép âm tiết Hangul'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulSyllableBuildingQuizQuestions) {
    await tester.drag(
      find.byKey(const Key('syllable-building-quiz-question')),
      const Offset(0, 1000),
    );
    await tester.pumpAndSettle();
    final option = find.byKey(
      ValueKey('syllable-building-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    tester.widget<InkWell>(option).onTap!();
    await tester.pump();
    final nextButton = find.byKey(const Key('next-syllable-building-question'));
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
        'syllable-building-option-',
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
