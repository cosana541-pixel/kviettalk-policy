import '../models/hangul_quiz_question.dart';

const hangulTensificationQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘학교’의 실제 발음은? / '학교' được phát âm thực tế như thế nào?",
    options: ['학꾜', '학교', '하교', '학쿄'],
    correctAnswer: '학꾜',
    explanation: '받침 ㄱ 뒤의 ㄱ이 된소리 [ㄲ]가 됩니다. / Sau 받침 ㄱ, ㄱ căng thành [ㄲ]: [학꾜].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘국밥’의 실제 발음은? / '국밥' được phát âm thực tế như thế nào?",
    options: ['국빱', '국밥', '구빱', '국팝'],
    correctAnswer: '국빱',
    explanation: '받침 ㄱ 뒤의 ㅂ이 된소리 [ㅃ]가 됩니다. / Sau 받침 ㄱ, ㅂ căng thành [ㅃ]: [국빱].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘책상’의 실제 발음은? / '책상' được phát âm thực tế như thế nào?",
    options: ['책쌍', '책상', '채쌍', '책창'],
    correctAnswer: '책쌍',
    explanation: '받침 ㄱ 뒤의 ㅅ이 된소리 [ㅆ]가 됩니다. / Sau 받침 ㄱ, ㅅ căng thành [ㅆ]: [책쌍].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘옷감’의 실제 발음은? / '옷감' được phát âm thực tế như thế nào?",
    options: ['옫깜', '옷감', '옫감', '오깜'],
    correctAnswer: '옫깜',
    explanation:
        '받침 ㅅ은 [ㄷ]으로, 뒤의 ㄱ은 [ㄲ]로 발음됩니다. / ㅅ cuối đọc là [ㄷ], rồi ㄱ căng thành [ㄲ]: [옫깜].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘잡지’의 실제 발음은? / '잡지' được phát âm thực tế như thế nào?",
    options: ['잡찌', '잡지', '자찌', '잡치'],
    correctAnswer: '잡찌',
    explanation: '받침 ㅂ 뒤의 ㅈ이 된소리 [ㅉ]가 됩니다. / Sau 받침 ㅂ, ㅈ căng thành [ㅉ]: [잡찌].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘축구’의 실제 발음은? / '축구' được phát âm thực tế như thế nào?",
    options: ['축꾸', '축구', '추꾸', '축쿠'],
    correctAnswer: '축꾸',
    explanation: '받침 ㄱ 뒤의 ㄱ이 된소리 [ㄲ]가 됩니다. / Sau 받침 ㄱ, ㄱ căng thành [ㄲ]: [축꾸].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘숙제’의 실제 발음은? / '숙제' được phát âm thực tế như thế nào?",
    options: ['숙쩨', '숙제', '수쩨', '숙체'],
    correctAnswer: '숙쩨',
    explanation: '받침 ㄱ 뒤의 ㅈ이 된소리 [ㅉ]가 됩니다. / Sau 받침 ㄱ, ㅈ căng thành [ㅉ]: [숙쩨].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘밥상’의 실제 발음은? / '밥상' được phát âm thực tế như thế nào?",
    options: ['밥쌍', '밥상', '바쌍', '밥창'],
    correctAnswer: '밥쌍',
    explanation: '받침 ㅂ 뒤의 ㅅ이 된소리 [ㅆ]가 됩니다. / Sau 받침 ㅂ, ㅅ căng thành [ㅆ]: [밥쌍].',
  ),
];
