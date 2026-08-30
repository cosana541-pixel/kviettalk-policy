import '../models/hangul_quiz_question.dart';

const basicVowelQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: 'Hãy chọn chữ giống với nguyên âm ㅏ.',
    options: ['ㅓ', 'ㅏ', 'ㅗ', 'ㅜ'],
    correctAnswer: 'ㅏ',
    explanation: 'ㅏ là chữ được đưa ra trong câu hỏi.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.vowelInSyllable,
    prompt: 'Nguyên âm được dùng trong “너” là gì?',
    options: ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
    correctAnswer: 'ㅓ',
    explanation: '너 được ghép từ phụ âm ㄴ và nguyên âm ㅓ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.syllableWithVowel,
    prompt: 'Âm tiết nào sau đây có nguyên âm ㅗ?',
    options: ['가', '너', '고', '구'],
    correctAnswer: '고',
    explanation: '고 được ghép từ phụ âm ㄱ và nguyên âm ㅗ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: 'Nguyên âm nào gần giống ư ngắn nhưng môi không tròn?',
    options: ['ㅜ', 'ㅡ', 'ㅣ', 'ㅓ'],
    correctAnswer: 'ㅡ',
    explanation: 'ㅡ gần giống ư ngắn, phát âm với môi kéo ngang nhẹ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: 'Hãy chọn chữ giống với nguyên âm ㅑ.',
    options: ['ㅏ', 'ㅑ', 'ㅕ', 'ㅛ'],
    correctAnswer: 'ㅑ',
    explanation: 'ㅑ là chữ được đưa ra trong câu hỏi.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.vowelInSyllable,
    prompt: 'Nguyên âm được dùng trong “유” là gì?',
    options: ['ㅛ', 'ㅜ', 'ㅠ', 'ㅣ'],
    correctAnswer: 'ㅠ',
    explanation: '유 được ghép từ phụ âm đầu ㅇ và nguyên âm ㅠ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.syllableWithVowel,
    prompt: 'Âm tiết nào sau đây có nguyên âm ㅣ?',
    options: ['나', '너', '노', '니'],
    correctAnswer: '니',
    explanation: '니 được ghép từ phụ âm ㄴ và nguyên âm ㅣ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: 'Nguyên âm nào gần giống u ngắn với môi tròn?',
    options: ['ㅗ', 'ㅜ', 'ㅡ', 'ㅣ'],
    correctAnswer: 'ㅜ',
    explanation: 'ㅜ gần giống u ngắn; môi tròn và đưa nhẹ ra trước.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.vowelInSyllable,
    prompt: 'Nguyên âm được dùng trong “여” là gì?',
    options: ['ㅑ', 'ㅓ', 'ㅕ', 'ㅛ'],
    correctAnswer: 'ㅕ',
    explanation: '여 được ghép từ phụ âm đầu ㅇ và nguyên âm ㅕ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.syllableWithVowel,
    prompt: 'Âm tiết nào sau đây có nguyên âm ㅛ?',
    options: ['겨', '고', '교', '규'],
    correctAnswer: '교',
    explanation: '교 được ghép từ phụ âm ㄱ và nguyên âm ㅛ.',
  ),
];
