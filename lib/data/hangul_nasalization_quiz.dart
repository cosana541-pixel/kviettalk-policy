import '../models/hangul_quiz_question.dart';

const hangulNasalizationQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘국물’의 실제 발음은? / '국물' được phát âm thực tế như thế nào?",
    options: ['궁물', '국물', '군물', '굼물'],
    correctAnswer: '궁물',
    explanation: '받침 ㄱ이 ㅁ 앞에서 [ㅇ]으로 비음화됩니다. / ㄱ đổi thành [ㅇ] trước ㅁ: [궁물].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘앞문’의 실제 발음은? / '앞문' được phát âm thực tế như thế nào?",
    options: ['암문', '앞문', '안문', '압문'],
    correctAnswer: '암문',
    explanation:
        '받침 ㅍ의 대표음 [ㅂ]이 ㅁ 앞에서 [ㅁ]으로 비음화됩니다. / Âm [ㅂ] của 받침 ㅍ đổi thành [ㅁ]: [암문].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘작년’의 실제 발음은? / '작년' được phát âm thực tế như thế nào?",
    options: ['장년', '작년', '잔년', '잠년'],
    correctAnswer: '장년',
    explanation: '받침 ㄱ이 ㄴ 앞에서 [ㅇ]으로 비음화됩니다. / ㄱ đổi thành [ㅇ] trước ㄴ: [장년].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘국민’의 실제 발음은? / '국민' được phát âm thực tế như thế nào?",
    options: ['궁민', '국민', '군민', '굼민'],
    correctAnswer: '궁민',
    explanation: '받침 ㄱ이 ㅁ 앞에서 [ㅇ]으로 비음화됩니다. / ㄱ đổi thành [ㅇ] trước ㅁ: [궁민].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘막내’의 실제 발음은? / '막내' được phát âm thực tế như thế nào?",
    options: ['망내', '막내', '만내', '맘내'],
    correctAnswer: '망내',
    explanation: '받침 ㄱ이 ㄴ 앞에서 [ㅇ]으로 비음화됩니다. / ㄱ đổi thành [ㅇ] trước ㄴ: [망내].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘받는’의 실제 발음은? / '받는' được phát âm thực tế như thế nào?",
    options: ['반는', '받는', '밤는', '방는'],
    correctAnswer: '반는',
    explanation: '받침 ㄷ이 ㄴ 앞에서 [ㄴ]으로 비음화됩니다. / ㄷ đổi thành [ㄴ] trước ㄴ: [반는].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘십만’의 실제 발음은? / '십만' được phát âm thực tế như thế nào?",
    options: ['심만', '십만', '신만', '싱만'],
    correctAnswer: '심만',
    explanation: '받침 ㅂ이 ㅁ 앞에서 [ㅁ]으로 비음화됩니다. / ㅂ đổi thành [ㅁ] trước ㅁ: [심만].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘업무’의 실제 발음은? / '업무' được phát âm thực tế như thế nào?",
    options: ['엄무', '업무', '언무', '엉무'],
    correctAnswer: '엄무',
    explanation: '받침 ㅂ이 ㅁ 앞에서 [ㅁ]으로 비음화됩니다. / ㅂ đổi thành [ㅁ] trước ㅁ: [엄무].',
  ),
];
