import '../models/hangul_quiz_question.dart';

const hangulPalatalizationQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘굳이’의 올바른 발음은? / '굳이' được phát âm đúng như thế nào?",
    options: ['구지', '구디', '구치', '굳이'],
    correctAnswer: '구지',
    explanation:
        '받침 ㄷ + 접미사 이가 만나 [ㅈ]으로 구개음화됩니다. / ㄷ gặp hậu tố 이 và biến thành [ㅈ]: [구지].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘같이’의 올바른 발음은? / '같이' được phát âm đúng như thế nào?",
    options: ['가치', '가티', '가지', '같이'],
    correctAnswer: '가치',
    explanation:
        '받침 ㅌ + 접미사 이가 만나 [ㅊ]으로 구개음화됩니다. / ㅌ gặp hậu tố 이 và biến thành [ㅊ]: [가치].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘밭이’의 올바른 발음은? / '밭이' được phát âm đúng như thế nào?",
    options: ['바치', '바티', '바지', '밭이'],
    correctAnswer: '바치',
    explanation:
        '받침 ㅌ + 조사 이가 만나 [ㅊ]으로 구개음화됩니다. / ㅌ gặp trợ từ 이 và biến thành [ㅊ]: [바치].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘해돋이’의 올바른 발음은? / '해돋이' được phát âm đúng như thế nào?",
    options: ['해도지', '해도디', '해도치', '해돋이'],
    correctAnswer: '해도지',
    explanation:
        '돋의 받침 ㄷ이 접미사 이 앞에서 [ㅈ]으로 바뀝니다. / ㄷ đổi thành [ㅈ] trước hậu tố 이: [해도지].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘미닫이’의 올바른 발음은? / '미닫이' được phát âm đúng như thế nào?",
    options: ['미다지', '미다디', '미다치', '미닫이'],
    correctAnswer: '미다지',
    explanation:
        '닫의 받침 ㄷ이 접미사 이 앞에서 [ㅈ]으로 바뀝니다. / ㄷ đổi thành [ㅈ] trước hậu tố 이: [미다지].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘맏이’의 올바른 발음은? / '맏이' được phát âm đúng như thế nào?",
    options: ['마지', '마디', '마치', '맏이'],
    correctAnswer: '마지',
    explanation:
        '받침 ㄷ + 접미사 이가 만나 [ㅈ]으로 구개음화됩니다. / ㄷ gặp hậu tố 이 và biến thành [ㅈ]: [마지].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘끝이’의 올바른 발음은? / '끝이' được phát âm đúng như thế nào?",
    options: ['끄치', '끄티', '끄지', '끝이'],
    correctAnswer: '끄치',
    explanation:
        '받침 ㅌ + 조사 이가 만나 [ㅊ]으로 구개음화됩니다. / ㅌ gặp trợ từ 이 và biến thành [ㅊ]: [끄치].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘붙이다’의 올바른 발음은? / '붙이다' được phát âm đúng như thế nào?",
    options: ['부치다', '부티다', '부지다', '붙이다'],
    correctAnswer: '부치다',
    explanation:
        '받침 ㅌ + 접미사 이가 만나 [ㅊ]으로 구개음화됩니다. / ㅌ gặp hậu tố 이 và biến thành [ㅊ]: [부치다].',
  ),
];
