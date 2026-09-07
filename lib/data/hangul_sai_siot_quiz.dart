import '../models/hangul_quiz_question.dart';

const hangulSaiSiotQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘찻집’의 원칙 발음은? / Cách phát âm chính của “찻집”?',
    options: ['찯찝', '차집', '차찝', '찻찝'],
    correctAnswer: '차찝',
    explanation:
        '사이시옷은 소리 내지 않고 ㅈ만 ㅉ으로 읽는 [차찝]이 원칙입니다. / '
        'Cách đọc chính là [차찝]; không đọc riêng ㅅ và đọc căng ㅈ thành ㅉ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘냇가’에서 허용되는 발음은? / Cách đọc nào được chấp nhận cho “냇가”?',
    options: ['내가', '낻가', '낻ː까', '냇까'],
    correctAnswer: '낻ː까',
    explanation:
        '원칙은 [내ː까]이고 사이시옷을 [ㄷ]으로 읽은 [낻ː까]도 허용됩니다. / '
        '[내ː까] là cách đọc chính; [낻ː까] cũng được chấp nhận.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '제30항 1의 원칙을 바르게 설명한 것은? / Mô tả đúng về khoản 1?',
    options: [
      '사이시옷을 항상 [ㅅ]으로 읽는다',
      '뒤 자음만 된소리로 읽는다',
      '항상 [ㄴㄴ]을 덧낸다',
      '뒤 자음을 거센소리로 읽는다',
    ],
    correctAnswer: '뒤 자음만 된소리로 읽는다',
    explanation:
        'ㄱ, ㄷ, ㅂ, ㅅ, ㅈ 앞에서는 사이시옷을 발음하지 않고 뒤 자음만 된소리로 읽는 것이 원칙입니다. / '
        'Không đọc riêng 사이시옷; cách chính là đọc căng phụ âm đứng sau.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '사이시옷 뒤 ‘이’ 음 앞에서 [ㄴㄴ]이 나타나는 예는? / Ví dụ nào có [ㄴㄴ] trước âm 이?',
    options: ['콧등 → 코뜽', '콧날 → 콘날', '나뭇잎 → 나문닙', '뱃길 → 배낄'],
    correctAnswer: '나뭇잎 → 나문닙',
    explanation:
        '나뭇잎은 제30항 3의 [ㄴㄴ] 발음 유형입니다. / '
        '나뭇잎 thuộc khoản 3, trong đó xuất hiện cách đọc [ㄴㄴ].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘깻잎’의 규칙 유형은? / “깻잎” thuộc kiểu quy tắc nào?',
    options: ['제30항 2: ㄴ/ㅁ 앞 [ㄴ]', '연음', '제30항 1: 된소리', '제30항 3: 이 앞 [ㄴㄴ]'],
    correctAnswer: '제30항 3: 이 앞 [ㄴㄴ]',
    explanation:
        '깻잎 [깬닙]은 사이시옷 뒤 ‘이’ 음이 결합해 [ㄴㄴ]으로 발음되는 유형입니다. / '
        '깻잎 [깬닙] là trường hợp phát âm [ㄴㄴ] trước âm 이.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: 'ㄴ/ㅁ 앞에서 사이시옷을 [ㄴ]으로 읽는 예는? / Ví dụ nào đọc 사이시옷 thành [ㄴ] trước ㄴ/ㅁ?',
    options: ['햇볕 → 해뼏', '찻집 → 차찝', '콧날 → 콘날', '깻잎 → 깬닙'],
    correctAnswer: '콧날 → 콘날',
    explanation:
        '콧날은 제30항 2에 따라 [콛날]을 거쳐 [콘날]로 발음합니다. / '
        '콧날 thuộc khoản 2 và được phát âm [콘날].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘햇볕’의 원칙 발음은? / Cách phát âm chính của “햇볕”?',
    options: ['핻뼏', '해볃', '햇볕', '해뼏'],
    correctAnswer: '해뼏',
    explanation:
        '[해뼏]이 원칙이고 사이시옷을 [ㄷ]으로 읽은 [핻뼏]은 허용 발음입니다. / '
        '[해뼏] là cách chính, còn [핻뼏] là cách được chấp nhận.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '원칙 발음과 허용 발음의 짝이 바른 것은? / Cặp cách đọc chính và cách được chấp nhận nào đúng?',
    options: [
      '콧등: 원칙 [콛뜽] · 허용 [코뜽]',
      '뱃길: 원칙 [배낄] · 허용 [밷낄]',
      '깻잎: 원칙 [깬닙] · 허용 [깯닙]',
      '콧날: 원칙 [콘날] · 허용 [콛날]',
    ],
    correctAnswer: '뱃길: 원칙 [배낄] · 허용 [밷낄]',
    explanation:
        '제30항 1에서 사이시옷을 발음하지 않은 [배낄]이 원칙이고 [밷낄]은 허용입니다. / '
        '[배낄] là cách chính và [밷낄] là cách được chấp nhận.',
  ),
];
