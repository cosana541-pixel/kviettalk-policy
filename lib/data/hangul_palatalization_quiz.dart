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
    options: ['가티', '가치', '가지', '같이'],
    correctAnswer: '가치',
    explanation:
        '받침 ㅌ + 접미사 이가 만나 [ㅊ]으로 구개음화됩니다. / ㅌ gặp hậu tố 이 và biến thành [ㅊ]: [가치].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘밭이’의 올바른 발음은? / '밭이' được phát âm đúng như thế nào?",
    options: ['바티', '바지', '바치', '밭이'],
    correctAnswer: '바치',
    explanation:
        '받침 ㅌ + 조사 이가 만나 [ㅊ]으로 구개음화됩니다. / ㅌ gặp trợ từ 이 và biến thành [ㅊ]: [바치].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘해돋이’의 올바른 발음은? / '해돋이' được phát âm đúng như thế nào?",
    options: ['해도디', '해도치', '해돋이', '해도지'],
    correctAnswer: '해도지',
    explanation:
        '돋의 받침 ㄷ이 접미사 이 앞에서 [ㅈ]으로 바뀝니다. / ㄷ đổi thành [ㅈ] trước hậu tố 이: [해도지].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        "‘곧이듣다’의 변화가 모두 반영된 발음은? / '곧이듣다' được phát âm thế nào sau tất cả biến đổi?",
    options: ['고지듣따', '고디듣다', '고치듣따', '곧이듣다'],
    correctAnswer: '고지듣따',
    explanation:
        'ㄷ + 접미사 이가 [ㅈ]으로 구개음화되고, 뒤의 ㄷ은 된소리 [ㄸ]가 됩니다. / ㄷ gặp hậu tố 이 đổi thành [ㅈ], sau đó ㄷ phía sau được căng hóa thành [ㄸ]: [고지듣따].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘땀받이’에 적용된 변화는? / Biến đổi nào được áp dụng trong '땀받이'?",
    options: ['ㄷ → [ㅌ]', 'ㄷ → [ㅈ]', 'ㅌ → [ㅊ]', 'ㄷ → [ㄴ]'],
    correctAnswer: 'ㄷ → [ㅈ]',
    explanation:
        '받의 ㄷ이 접미사 이 앞에서 [ㅈ]으로 구개음화되어 [땀바지]가 됩니다. / ㄷ của 받 đổi thành [ㅈ] trước hậu tố 이, tạo cách đọc [땀바지].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        "‘벼훑이’에서 ㄾ 뒤에 조사 이가 결합한 결과는? / Kết quả khi trợ từ 이 kết hợp sau ㄾ trong '벼훑이'?",
    options: ['벼훌티', '벼후리', '벼훌치', '벼훌지'],
    correctAnswer: '벼훌치',
    explanation:
        'ㄾ의 ㄹ은 받침으로 남고 ㅌ은 조사 이 앞에서 [ㅊ]으로 구개음화되어 [벼훌치]가 됩니다. / ㄹ trong ㄾ vẫn là âm cuối, còn ㅌ đổi thành [ㅊ] trước trợ từ 이: [벼훌치].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '구개음화가 일어나는 조건은? / Điều kiện nào làm xảy ra biến âm vòm miệng?',
    options: [
      '받침 ㄱ + 모음 아',
      '받침 ㅂ + 자음 ㄴ',
      '받침 ㄴ + 자음 ㄹ',
      '받침 ㄷ·ㅌ + 조사나 접미사의 이',
    ],
    correctAnswer: '받침 ㄷ·ㅌ + 조사나 접미사의 이',
    explanation:
        '받침 ㄷ·ㅌ이 조사나 접미사의 이와 결합하면 각각 [ㅈ]·[ㅊ]으로 구개음화됩니다. / Khi 받침 ㄷ·ㅌ kết hợp với 이 của trợ từ hoặc hậu tố, chúng lần lượt đổi thành [ㅈ]·[ㅊ].',
  ),
];
