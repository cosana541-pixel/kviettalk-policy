import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_n_insertion.dart';
import 'package:korean_vietnamese_app/data/hangul_n_insertion_quiz.dart';
import 'package:korean_vietnamese_app/data/hangul_sai_siot.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/screens/hangul_basics_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_n_insertion_learning_screen.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';

void main() {
  test('n insertion data has 8 verified standard pronunciations', () {
    expect(hangulNInsertionExamples, hasLength(8));
    expect(
      {
        for (final example in hangulNInsertionExamples)
          example.writtenForm: example.pronunciation,
      },
      const {
        '솜이불': '솜니불',
        '맨입': '맨닙',
        '꽃잎': '꼰닙',
        '내복약': '내ː봉냑',
        '한여름': '한녀름',
        '색연필': '생년필',
        '담요': '담뇨',
        '식용유': '시굥뉴',
      },
    );
    expect(
      hangulNInsertionExamples
          .where((example) => example.hasChangeProcess)
          .map((example) => example.writtenForm)
          .toSet(),
      const {'꽃잎', '내복약', '색연필'},
    );
    for (final example in hangulNInsertionExamples) {
      expect(example.wordBoundary, isNotEmpty);
      expect(example.koreanExplanation, isNotEmpty);
      expect(example.vietnameseExplanation, isNotEmpty);
    }
    final nInsertionWords = hangulNInsertionExamples
        .map((example) => example.writtenForm)
        .toSet();
    final saiSiotWords = hangulSaiSiotExamples
        .map((example) => example.displayWord)
        .toSet();
    expect(nInsertionWords.intersection(saiSiotWords), isEmpty);
    expect(nInsertionWords, isNot(contains('깻잎')));
    expect(saiSiotWords, contains('깻잎'));
  });

  test('n insertion quiz has 8 valid four-choice questions', () {
    expect(hangulNInsertionQuizQuestions, hasLength(8));
    final learningPronunciations = {
      for (final example in hangulNInsertionExamples)
        example.writtenForm: example.pronunciation,
    };
    final correctIndices = <int>[];
    var repeatedCardPronunciationQuestions = 0;
    for (final question in hangulNInsertionQuizQuestions) {
      expect(question.type, HangulQuizQuestionType.pronunciationGuide);
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(
        question.options.where((option) => option == question.correctAnswer),
        hasLength(1),
      );
      correctIndices.add(question.options.indexOf(question.correctAnswer));
      expect(question.explanation, isNot(contains(' / ')));
      for (final entry in learningPronunciations.entries) {
        if (question.prompt.contains(entry.key) &&
            question.correctAnswer == entry.value) {
          repeatedCardPronunciationQuestions++;
        }
      }
    }
    expect(repeatedCardPronunciationQuestions, lessThanOrEqualTo(2));
    expect(
      {
        for (var index = 0; index < 4; index++)
          index: correctIndices.where((value) => value == index).length,
      },
      const {0: 2, 1: 2, 2: 2, 3: 2},
    );
    for (final marker in const [
      'Điều kiện cơ bản',
      'Thứ tự biến đổi',
      'dạng trung gian',
      'từ mới',
    ]) {
      expect(
        hangulNInsertionQuizQuestions.any(
          (question) => question.prompt.contains(marker),
        ),
        isTrue,
      );
    }
  });

  testWidgets('n insertion follows rieul nasalization and opens', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulBasicsScreen(nInsertionSpeechPlayer: speechPlayer),
      ),
    );

    final listView = tester.widget<ListView>(find.byType(ListView));
    final children =
        (listView.childrenDelegate as SliverChildListDelegate).children;
    final rieulIndex = _indexOfKey(
      children,
      const Key('rieul-nasalization-course'),
    );
    final nInsertionIndex = _indexOfKey(
      children,
      const Key('n-insertion-course'),
    );
    final saiSiotIndex = _indexOfKey(children, const Key('sai-siot-course'));
    expect(rieulIndex, lessThan(nInsertionIndex));
    expect(nInsertionIndex, lessThan(saiSiotIndex));

    final course = find.byKey(const Key('n-insertion-course'));
    await tester.scrollUntilVisible(
      course,
      350,
      scrollable: find.byType(Scrollable).first,
    );
    final advancedTitle = find.byKey(const Key('advanced-section-title'));
    expect(advancedTitle, findsOneWidget);
    expect(
      tester.getTopLeft(advancedTitle).dy,
      lessThan(tester.getTopLeft(course).dy),
    );
    expect(find.text('Thêm âm ㄴ'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(course);
    await tester.pumpAndSettle();
    await tester.tap(course);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('n-insertion-rules')), findsOneWidget);
    expect(find.text('Phụ âm cuối + 이/야/여/요/유\n→ thêm âm ㄴ'), findsOneWidget);
    expect(find.byKey(const Key('n-insertion-chain-note')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TTS and full quiz flow work without overflow at 360x640', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    _useSmallScreen(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: HangulNInsertionLearningScreen(speechPlayer: speechPlayer),
      ),
    );

    final firstAudio = find.byKey(const ValueKey('n-insertion-audio-솜이불'));
    await tester.scrollUntilVisible(
      firstAudio,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, firstAudio);
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['솜니불']);
    expect(tester.widget<IconButton>(firstAudio).onPressed, isNull);
    await tester.tap(firstAudio);
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['솜니불']);
    speechPlayer.completeSpeech();
    await tester.pump();

    for (final example in hangulNInsertionExamples) {
      final card = find.byKey(ValueKey('n-insertion-${example.writtenForm}'));
      await tester.scrollUntilVisible(
        card,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      expect(card, findsOneWidget);
      expect(
        find.byKey(
          ValueKey('n-insertion-pronunciation-${example.writtenForm}'),
        ),
        findsOneWidget,
      );
      if (example.hasChangeProcess) {
        expect(
          find.byKey(ValueKey('n-insertion-process-${example.writtenForm}')),
          findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
    }

    final startButton = find.byKey(const Key('start-n-insertion-quiz'));
    await tester.scrollUntilVisible(
      startButton,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    expect(find.text('1/8'), findsOneWidget);
    expect(find.text('Chọn 1 đáp án đúng'), findsOneWidget);
    expect(find.textContaining('정답 1개를 고르세요'), findsNothing);

    await _completeQuiz(tester);
    expect(find.byKey(const Key('n-insertion-quiz-result')), findsOneWidget);
    expect(find.text('8/8 정답 · câu đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('retry-n-insertion-quiz')));
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);

    await _completeQuiz(tester);
    await tester.tap(find.byKey(const Key('back-to-n-insertion-learning')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('start-n-insertion-quiz')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(speechPlayer.stopCalls, 1);
  });
}

Future<void> _completeQuiz(WidgetTester tester) async {
  for (final question in hangulNInsertionQuizQuestions) {
    final option = find.byKey(
      ValueKey('n-insertion-option-${question.correctAnswer}'),
    );
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, option);
    await tester.tap(option);
    await tester.pump();
    expect(find.byKey(const Key('n-insertion-quiz-feedback')), findsOneWidget);
    final nextButton = find.byKey(const Key('next-n-insertion-question'));
    await tester.scrollUntilVisible(
      nextButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await _bringIntoTapArea(tester, nextButton);
    await tester.tap(nextButton);
    await tester.pump();
    expect(tester.takeException(), isNull);
  }
}

Future<void> _bringIntoTapArea(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  final initialRect = tester.getRect(finder);
  final dragDistance = initialRect.top < 80
      ? 80 - initialRect.top
      : initialRect.bottom > 620
      ? 620 - initialRect.bottom
      : 0.0;
  if (dragDistance != 0) {
    await tester.dragFrom(tester.getCenter(finder), Offset(0, dragDistance));
    await tester.pumpAndSettle();
  }
  final tappableRect = tester.getRect(finder);
  expect(tappableRect.top, greaterThanOrEqualTo(80));
  expect(tappableRect.bottom, lessThanOrEqualTo(620));
}

int _indexOfKey(List<Widget> children, Key key) {
  return children.indexWhere((widget) {
    if (widget.key == key) return true;
    return widget is Card && widget.child?.key == key;
  });
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
