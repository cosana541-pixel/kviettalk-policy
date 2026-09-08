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
    options: ['좋던', '조ː턴', '조ː던', '조ː컨'],
    correctAnswer: '조ː턴',
    explanation: 'ㅎ + ㄷ이 합쳐져 [ㅌ]이 됩니다. / ㅎ + ㄷ kết hợp thành [ㅌ]: [조ː턴].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘쌓지’의 실제 발음은? / '쌓지' được phát âm thực tế như thế nào?",
    options: ['쌓지', '싸지', '싸치', '싿찌'],
    correctAnswer: '싸치',
    explanation: 'ㅎ + ㅈ이 합쳐져 [ㅊ]이 됩니다. / ㅎ + ㅈ kết hợp thành [ㅊ]: [싸치].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘먹히다’의 실제 발음은? / '먹히다' được phát âm thực tế như thế nào?",
    options: ['먹히다', '머기다', '머티다', '머키다'],
    correctAnswer: '머키다',
    explanation: 'ㄱ + ㅎ이 합쳐져 [ㅋ]이 됩니다. / ㄱ + ㅎ kết hợp thành [ㅋ]: [머키다].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘각하’의 올바른 발음은? / '각하' được phát âm đúng như thế nào?",
    options: ['가카', '각하', '가가', '가타'],
    correctAnswer: '가카',
    explanation:
        '받침 ㄱ과 뒤의 ㅎ이 합쳐져 거센소리 [ㅋ]이 됩니다. / 받침 ㄱ kết hợp với ㅎ phía sau thành âm bật hơi [ㅋ]: [가카].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘맏형’의 올바른 발음은? / '맏형' được phát âm đúng như thế nào?",
    options: ['마딩', '마텽', '마형', '맏형'],
    correctAnswer: '마텽',
    explanation:
        '받침 ㄷ과 뒤의 ㅎ이 합쳐져 [ㅌ]이 되고 형의 ㅎ 자리에 이어져 [마텽]이 됩니다. / 받침 ㄷ kết hợp với ㅎ thành [ㅌ] và chuyển sang đầu âm tiết sau: [마텽].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘많고’에서 ㄶ과 ㄱ이 결합한 결과는? / Kết quả khi ㄶ kết hợp với ㄱ trong '많고'?",
    options: ['만ː고', '맏ː꼬', '만ː코', '많고'],
    correctAnswer: '만ː코',
    explanation:
        'ㄶ의 ㅎ과 뒤의 ㄱ이 합쳐져 [ㅋ]이 되고 ㄴ은 받침으로 남아 [만ː코]가 됩니다. / ㅎ trong ㄶ kết hợp với ㄱ thành [ㅋ], còn ㄴ vẫn là âm cuối: [만ː코].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '받침 ㅂ 뒤에 ㅎ이 올 때 합쳐지는 소리는? / 받침 ㅂ kết hợp với ㅎ phía sau thành âm nào?',
    options: ['[ㅋ]', '[ㅌ]', '[ㅊ]', '[ㅍ]'],
    correctAnswer: '[ㅍ]',
    explanation:
        '받침 ㅂ과 ㅎ이 결합하면 거센소리 [ㅍ]으로 발음됩니다. / 받침 ㅂ kết hợp với ㅎ và được phát âm thành âm bật hơi [ㅍ].',
  ),
];
