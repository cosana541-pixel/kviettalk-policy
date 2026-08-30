import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:korean_vietnamese_app/data/app_state.dart';
import 'package:korean_vietnamese_app/data/basic_consonant_quiz.dart';
import 'package:korean_vietnamese_app/data/basic_consonants.dart';
import 'package:korean_vietnamese_app/models/hangul_quiz_question.dart';
import 'package:korean_vietnamese_app/models/word.dart';
import 'package:korean_vietnamese_app/screens/consonant_learning_screen.dart';
import 'package:korean_vietnamese_app/screens/consonant_quiz_screen.dart';
import 'package:korean_vietnamese_app/screens/home_screen.dart';
import 'package:korean_vietnamese_app/services/favorite_service.dart';
import 'package:korean_vietnamese_app/services/tts_service.dart';
import 'package:korean_vietnamese_app/services/word_repository.dart';
import 'package:korean_vietnamese_app/utils/learning_stats_keys.dart';

void main() {
  test('basic consonant data contains all 14 consonants and first lesson', () {
    expect(basicConsonants, hasLength(14));
    expect(basicConsonants.map((item) => item.character).toList(), const [
      'ㄱ',
      'ㄴ',
      'ㄷ',
      'ㄹ',
      'ㅁ',
      'ㅂ',
      'ㅅ',
      'ㅇ',
      'ㅈ',
      'ㅊ',
      'ㅋ',
      'ㅌ',
      'ㅍ',
      'ㅎ',
    ]);
    expect(basicConsonants.first.name, '기역 (giyeok)');
    expect(basicConsonants.first.pronunciationGuide, contains('k/g'));
    expect(basicConsonants.first.pronunciationGuide, contains('tùy vị trí'));
    expect(basicConsonants.first.examples, const ['가', '고']);
  });

  test('consonant quiz has 10 unambiguous four-choice questions', () {
    expect(basicConsonantQuizQuestions, hasLength(10));
    expect(
      basicConsonantQuizQuestions.map((question) => question.type).toSet(),
      const {
        HangulQuizQuestionType.matchingCharacter,
        HangulQuizQuestionType.initialConsonant,
        HangulQuizQuestionType.startingSyllable,
        HangulQuizQuestionType.pronunciationGuide,
      },
    );

    for (final question in basicConsonantQuizQuestions) {
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(
        question.options.where((option) => option == question.correctAnswer),
        hasLength(1),
      );
      expect(question.explanation, isNotEmpty);
    }
  });

  testWidgets('learning screen shows ㄱ information and starts quiz', (
    tester,
  ) async {
    final speechPlayer = _TestKoreanSpeechPlayer();
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: ConsonantLearningScreen(speechPlayer: speechPlayer)),
    );

    expect(find.byKey(const ValueKey('consonant-ㄱ')), findsOneWidget);
    expect(find.text('Tên: 기역 (giyeok)'), findsOneWidget);
    expect(find.text('Ví dụ: 가, 고'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('consonant-name-audio-ㄱ')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('consonant-examples-audio-ㄱ')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('consonant-name-audio-ㄱ')));
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['기역']);

    await tester.tap(find.byKey(const ValueKey('consonant-examples-audio-ㄱ')));
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['기역']);

    speechPlayer.completeSpeech();
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('consonant-examples-audio-ㄱ')));
    await tester.pump();
    expect(speechPlayer.spokenTexts, const ['기역', '가, 고']);
    speechPlayer.completeSpeech();
    await tester.pump();

    await tester.scrollUntilVisible(
      find.byKey(const Key('start-consonant-quiz')),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('start-consonant-quiz')));
    await tester.pumpAndSettle();

    expect(find.text('Quiz phụ âm'), findsOneWidget);
    expect(find.byKey(const Key('consonant-quiz-prompt')), findsOneWidget);
    expect(_optionFinder(), findsNWidgets(4));
  });

  testWidgets('quiz shows feedback and advances to the next question', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ConsonantQuizScreen()));

    final firstPrompt = basicConsonantQuizQuestions.first.prompt;
    expect(find.text(firstPrompt), findsOneWidget);
    expect(_optionFinder(), findsNWidgets(4));

    await tester.tap(
      find.byKey(
        ValueKey(
          'consonant-option-${basicConsonantQuizQuestions.first.correctAnswer}',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Chính xác!'), findsOneWidget);
    expect(find.byKey(const Key('next-consonant-question')), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('consonant-quiz-question')),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('next-consonant-question')));
    await tester.pump();

    expect(find.text(firstPrompt), findsNothing);
    expect(find.text('2/10'), findsOneWidget);
    expect(_optionFinder(), findsNWidgets(4));
  });

  testWidgets('home opens Hangeul basics and keeps existing Quiz entry', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      LearningStatsKeys.firstRunGuideSeen: true,
    });
    final appState = AppState(
      wordRepository: _TestWordRepository(),
      favoriteService: _TestFavoriteService(),
    );
    await appState.initialize();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Quiz'), findsWidgets);
    await tester.tap(find.text('Hangeul cơ bản'));
    await tester.pumpAndSettle();

    expect(find.text('Bắt đầu học bảng chữ cái Hàn Quốc'), findsOneWidget);
    expect(find.text('Phụ âm cơ bản'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quiz').last);
    await tester.pumpAndSettle();

    expect(find.text('Chọn đáp án đúng'), findsOneWidget);
  });
}

Finder _optionFinder() {
  return find.byWidgetPredicate(
    (widget) =>
        widget.key is ValueKey<String> &&
        ((widget.key! as ValueKey<String>).value).startsWith(
          'consonant-option-',
        ),
  );
}

class _TestWordRepository extends WordRepository {
  @override
  Future<List<Word>> loadWords() async {
    return const [
      Word(
        korean: '물',
        vietnamese: 'Nước',
        koreanPronunciation: '물',
        vietnamesePronunciation: '',
        category: '기타',
        imagePath: 'test/1.png',
      ),
      Word(
        korean: '밥',
        vietnamese: 'Cơm',
        koreanPronunciation: '밥',
        vietnamesePronunciation: '',
        category: '기타',
        imagePath: 'test/2.png',
      ),
      Word(
        korean: '집',
        vietnamese: 'Nhà',
        koreanPronunciation: '집',
        vietnamesePronunciation: '',
        category: '기타',
        imagePath: 'test/3.png',
      ),
      Word(
        korean: '차',
        vietnamese: 'Trà',
        koreanPronunciation: '차',
        vietnamesePronunciation: '',
        category: '기타',
        imagePath: 'test/4.png',
      ),
    ];
  }
}

class _TestFavoriteService extends FavoriteService {
  @override
  Future<Set<String>> loadFavoriteIds() async => <String>{};
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
