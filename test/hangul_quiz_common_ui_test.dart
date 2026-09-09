import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:korean_vietnamese_app/data/hangul_liaison_quiz.dart';
import 'package:korean_vietnamese_app/screens/hangul_consonant_cluster_reduction_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_h_changes_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_liaison_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_liquidization_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_n_insertion_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_nasalization_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_palatalization_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_rieul_nasalization_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_sai_siot_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/hangul_tensification_quiz_screen.dart';
import 'package:korean_vietnamese_app/utils/hangul_quiz_option_order.dart';
import 'package:korean_vietnamese_app/widgets/hangul_quiz_question_card.dart';

void main() {
  test('option ordering copies all values without changing the source', () {
    final original = ['a', 'b', 'c', 'd'];
    final originalSnapshot = List<String>.of(original);

    final first = createShuffledHangulQuizOptions(original);
    final second = createShuffledHangulQuizOptions(original);

    expect(first, unorderedEquals(original));
    expect(second, unorderedEquals(original));
    expect(identical(first, original), isFalse);
    expect(identical(second, original), isFalse);
    expect(identical(first, second), isFalse);
    expect(original, originalSnapshot);
  });

  testWidgets('all pronunciation quizzes use the common instruction card', (
    tester,
  ) async {
    const quizScreens = <Widget>[
      HangulLiaisonQuizScreen(),
      HangulPalatalizationQuizScreen(),
      HangulTensificationQuizScreen(),
      HangulNasalizationQuizScreen(),
      HangulLiquidizationQuizScreen(),
      HangulHChangesQuizScreen(),
      HangulConsonantClusterReductionQuizScreen(),
      HangulRieulNasalizationQuizScreen(),
      HangulNInsertionQuizScreen(),
      HangulSaiSiotQuizScreen(),
    ];

    for (final screen in quizScreens) {
      await tester.pumpWidget(MaterialApp(home: screen));
      expect(find.byType(HangulQuizQuestionCard), findsOneWidget);
      expect(find.text(HangulQuizQuestionCard.instruction), findsOneWidget);
      expect(find.textContaining('정답 1개를 고르세요'), findsNothing);
    }
  });

  for (final brightness in Brightness.values) {
    testWidgets('question card uses secondary container in $brightness', (
      tester,
    ) async {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: brightness,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme),
          home: const Scaffold(
            body: HangulQuizQuestionCard(
              prompt: 'Prompt',
              promptKey: Key('test-prompt'),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, colorScheme.secondaryContainer);
      expect(find.text(HangulQuizQuestionCard.instruction), findsOneWidget);
    });
  }

  testWidgets('liaison option order is stable and answers use string values', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HangulLiaisonQuizScreen()));

    final firstQuestion = hangulLiaisonQuizQuestions.first;
    final initialOrder = _liaisonOptionOrder(tester);
    expect(initialOrder, unorderedEquals(firstQuestion.options));

    tester.view.physicalSize = const Size(810, 1200);
    await tester.pump();
    expect(_liaisonOptionOrder(tester), initialOrder);

    await tester.tap(
      find.byKey(ValueKey('liaison-option-${firstQuestion.correctAnswer}')),
    );
    await tester.pump();
    expect(_liaisonOptionOrder(tester), initialOrder);
    expect(find.text('Chính xác!'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('next-liaison-question')));
    await tester.tap(find.byKey(const Key('next-liaison-question')));
    await tester.pump();

    final secondQuestion = hangulLiaisonQuizQuestions[1];
    expect(find.text(secondQuestion.prompt), findsOneWidget);
    expect(
      _liaisonOptionOrder(tester),
      unorderedEquals(secondQuestion.options),
    );
  });
}

List<String> _liaisonOptionOrder(WidgetTester tester) {
  const prefix = 'liaison-option-';
  return find
      .byWidgetPredicate(
        (widget) =>
            widget.key is ValueKey<String> &&
            (widget.key! as ValueKey<String>).value.startsWith(prefix),
      )
      .evaluate()
      .map(
        (element) => ((element.widget.key! as ValueKey<String>).value)
            .substring(prefix.length),
      )
      .toList();
}
