import '../models/hangul_quiz_question.dart';

const basicConsonantQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: 'Hãy chọn chữ giống với phụ âm ㄱ.',
    options: ['ㄴ', 'ㄱ', 'ㄷ', 'ㅁ'],
    correctAnswer: 'ㄱ',
    explanation: 'ㄱ là chữ được đưa ra trong câu hỏi.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.initialConsonant,
    prompt: 'Phụ âm đầu của “나” là gì?',
    options: ['ㄱ', 'ㄴ', 'ㄷ', 'ㅁ'],
    correctAnswer: 'ㄴ',
    explanation: '나 được ghép từ phụ âm đầu ㄴ và nguyên âm ㅏ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.startingSyllable,
    prompt: 'Âm tiết nào sau đây bắt đầu bằng ㄷ?',
    options: ['가', '나', '다', '마'],
    correctAnswer: '다',
    explanation: '다 bắt đầu bằng phụ âm ㄷ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: 'Phụ âm nào có âm gần với m trong tiếng Việt?',
    options: ['ㄹ', 'ㅁ', 'ㅂ', 'ㅅ'],
    correctAnswer: 'ㅁ',
    explanation: 'ㅁ (미음) có âm gần với m trong tiếng Việt.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: 'Hãy chọn chữ giống với phụ âm ㅅ.',
    options: ['ㅈ', 'ㅊ', 'ㅅ', 'ㅎ'],
    correctAnswer: 'ㅅ',
    explanation: 'ㅅ là chữ được đưa ra trong câu hỏi.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.initialConsonant,
    prompt: 'Phụ âm đầu của “호” là gì?',
    options: ['ㅍ', 'ㅎ', 'ㅋ', 'ㅌ'],
    correctAnswer: 'ㅎ',
    explanation: '호 được ghép từ phụ âm đầu ㅎ và nguyên âm ㅗ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.startingSyllable,
    prompt: 'Âm tiết nào sau đây bắt đầu bằng ㅂ?',
    options: ['바', '사', '자', '차'],
    correctAnswer: '바',
    explanation: '바 bắt đầu bằng phụ âm ㅂ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        'Phụ âm nào không phát âm ở đầu âm tiết và thường gần âm ng ở cuối?',
    options: ['ㄴ', 'ㄹ', 'ㅇ', 'ㅎ'],
    correctAnswer: 'ㅇ',
    explanation: 'ㅇ không có âm ở đầu; ở cuối âm tiết thường phát âm gần ng.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.initialConsonant,
    prompt: 'Phụ âm đầu của “코” là gì?',
    options: ['ㄱ', 'ㅋ', 'ㅌ', 'ㅍ'],
    correctAnswer: 'ㅋ',
    explanation: '코 được ghép từ phụ âm đầu ㅋ và nguyên âm ㅗ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.startingSyllable,
    prompt: 'Âm tiết nào sau đây bắt đầu bằng ㅍ?',
    options: ['포', '도', '로', '토'],
    correctAnswer: '포',
    explanation: '포 bắt đầu bằng phụ âm ㅍ.',
  ),
];
