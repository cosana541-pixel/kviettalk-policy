import '../models/hangul_quiz_question.dart';

const hangulHChangesQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘놓고’의 실제 발음은? / '놓고' được phát âm thực tế như thế nào?",
    options: ['노코', '놓고', '노고', '노토'],
    correctAnswer: '노코',
    explanation: 'ㅎ + ㄱ이 합쳐져 [ㅋ]이 됩니다. / ㅎ + ㄱ kết hợp thành [ㅋ]: [노코].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘좋던’의 실제 발음은? / '좋던' được phát âm thực tế như thế nào?",
    options: ['조ː턴', '좋던', '조ː던', '조ː컨'],
    correctAnswer: '조ː턴',
    explanation: 'ㅎ + ㄷ이 합쳐져 [ㅌ]이 됩니다. / ㅎ + ㄷ kết hợp thành [ㅌ]: [조ː턴].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘쌓지’의 실제 발음은? / '쌓지' được phát âm thực tế như thế nào?",
    options: ['싸치', '쌓지', '싸지', '싿찌'],
    correctAnswer: '싸치',
    explanation: 'ㅎ + ㅈ이 합쳐져 [ㅊ]이 됩니다. / ㅎ + ㅈ kết hợp thành [ㅊ]: [싸치].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘먹히다’의 실제 발음은? / '먹히다' được phát âm thực tế như thế nào?",
    options: ['머키다', '먹히다', '머기다', '머티다'],
    correctAnswer: '머키다',
    explanation: 'ㄱ + ㅎ이 합쳐져 [ㅋ]이 됩니다. / ㄱ + ㅎ kết hợp thành [ㅋ]: [머키다].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘좁히다’의 실제 발음은? / '좁히다' được phát âm thực tế như thế nào?",
    options: ['조피다', '좁히다', '조비다', '조키다'],
    correctAnswer: '조피다',
    explanation: 'ㅂ + ㅎ이 합쳐져 [ㅍ]이 됩니다. / ㅂ + ㅎ kết hợp thành [ㅍ]: [조피다].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘꽂히다’의 실제 발음은? / '꽂히다' được phát âm thực tế như thế nào?",
    options: ['꼬치다', '꽂히다', '꼬지다', '꼳티다'],
    correctAnswer: '꼬치다',
    explanation: 'ㅈ + ㅎ이 합쳐져 [ㅊ]이 됩니다. / ㅈ + ㅎ kết hợp thành [ㅊ]: [꼬치다].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘놓아’의 실제 발음은? / '놓아' được phát âm thực tế như thế nào?",
    options: ['노아', '놓아', '노하', '노와'],
    correctAnswer: '노아',
    explanation: '모음 앞에서 받침 ㅎ이 탈락합니다. / ㅎ cuối mất đi trước nguyên âm: [노아].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘많아’의 실제 발음은? / '많아' được phát âm thực tế như thế nào?",
    options: ['마ː나', '많아', '마ː하', '마ː아'],
    correctAnswer: '마ː나',
    explanation:
        'ㄶ에서 ㅎ은 탈락하고 ㄴ이 이어집니다. / Trong ㄶ, ㅎ mất đi và ㄴ được nối sang: [마ː나].',
  ),
];
