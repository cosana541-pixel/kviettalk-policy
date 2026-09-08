import '../models/hangul_quiz_question.dart';

const hangulSaiSiotQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '‘찻집’의 원칙 발음이 만들어지는 단계는? / Các bước tạo cách phát âm chính của “찻집” là gì?',
    options: [
      '사이시옷은 따로 소리 내지 않고 뒤의 ㅈ을 ㅉ으로 바꾸어 [차찝]으로 발음한다.',
      '사이시옷을 [ㄴ]으로 바꾼 뒤 [찬집]으로 발음한다.',
      '사이시옷을 [ㄷ]으로만 읽고 뒤의 ㅈ은 그대로 두어 [찯집]으로 발음한다.',
      '뒤의 ㅈ을 ㅊ으로 바꾸어 [차칩]으로 발음한다.',
    ],
    correctAnswer: '사이시옷은 따로 소리 내지 않고 뒤의 ㅈ을 ㅉ으로 바꾸어 [차찝]으로 발음한다.',
    explanation:
        '제30항 1에 따라 사이시옷은 따로 발음하지 않고 뒤 자음 ㅈ만 된소리 ㅉ으로 읽는 것이 원칙입니다. / '
        'Theo khoản 1 Điều 30, không đọc riêng 사이시옷; chỉ đọc căng ㅈ phía sau thành ㅉ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '‘냇가’의 원칙 발음과 허용 발음을 바르게 구분한 것은? / Phân biệt đúng cách đọc chính và cách đọc được chấp nhận của “냇가”?',
    options: [
      '원칙 [낻ː까] · 허용 [내ː까]',
      '원칙 [내ː까] · 허용 [낻ː까]',
      '원칙 [내ː가] · 허용 [낻ː가]',
      '원칙 [냇ː까] · 허용 [내ː가]',
    ],
    correctAnswer: '원칙 [내ː까] · 허용 [낻ː까]',
    explanation:
        '뒤의 ㄱ만 ㄲ으로 읽은 [내ː까]가 원칙이고, 사이시옷을 [ㄷ]으로 읽은 [낻ː까]도 허용됩니다. / '
        '[내ː까], chỉ đọc căng ㄱ thành ㄲ, là cách chính; [낻ː까] với 사이시옷 đọc thành [ㄷ] cũng được chấp nhận.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '제30항 1의 원칙을 바르게 설명한 것은? / Mô tả đúng về khoản 1?',
    options: [
      '사이시옷을 항상 [ㅅ]으로 읽는다',
      '항상 [ㄴㄴ]을 덧낸다',
      '뒤 자음만 된소리로 읽는다',
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
    options: ['콧등 → 코뜽', '콧날 → 콘날', '뱃길 → 배낄', '나뭇잎 → 나문닙'],
    correctAnswer: '나뭇잎 → 나문닙',
    explanation:
        '나뭇잎은 제30항 3의 [ㄴㄴ] 발음 유형입니다. / '
        '나뭇잎 thuộc khoản 3, trong đó xuất hiện cách đọc [ㄴㄴ].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘깻잎’의 규칙 유형은? / “깻잎” thuộc kiểu quy tắc nào?',
    options: ['제30항 3: 이 앞 [ㄴㄴ]', '연음', '제30항 1: 된소리', '제30항 2: ㄴ/ㅁ 앞 [ㄴ]'],
    correctAnswer: '제30항 3: 이 앞 [ㄴㄴ]',
    explanation:
        '깻잎 [깬닙]은 사이시옷 뒤 ‘이’ 음이 결합해 [ㄴㄴ]으로 발음되는 유형입니다. / '
        '깻잎 [깬닙] là trường hợp phát âm [ㄴㄴ] trước âm 이.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        'ㄴ/ㅁ 앞에서 사이시옷을 [ㄴ]으로 읽는 예는? / Ví dụ nào đọc 사이시옷 thành [ㄴ] trước ㄴ/ㅁ?',
    options: ['햇볕 → 해뼏', '콧날 → 콘날', '찻집 → 차찝', '깻잎 → 깬닙'],
    correctAnswer: '콧날 → 콘날',
    explanation:
        '콧날은 제30항 2에 따라 [콛날]을 거쳐 [콘날]로 발음합니다. / '
        '콧날 thuộc khoản 2 và được phát âm [콘날].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '사이시옷 발음 규칙을 잘못 적용한 설명은? / Mô tả nào áp dụng sai quy tắc phát âm 사이시옷?',
    options: [
      '찻집은 뒤의 ㅈ만 된소리로 읽는 [차찝]이 원칙이다.',
      '콧날은 사이시옷 뒤에 ㄴ이 와서 [콘날]로 발음한다.',
      '깻잎은 제30항 1의 된소리형이므로 뒤 자음만 세게 읽는다.',
      '나뭇잎은 이 음 앞에서 [ㄴㄴ]이 나타나 [나문닙]으로 발음한다.',
    ],
    correctAnswer: '깻잎은 제30항 1의 된소리형이므로 뒤 자음만 세게 읽는다.',
    explanation:
        '깻잎은 제30항 3의 이 음 앞 [ㄴㄴ] 유형으로 [깯닙]을 거쳐 [깬닙]으로 발음합니다. / '
        '깻잎 thuộc khoản 3, kiểu [ㄴㄴ] trước âm 이, và được phát âm [깬닙] qua bước [깯닙].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '원칙 발음과 허용 발음의 짝이 바른 것은? / Cặp cách đọc chính và cách được chấp nhận nào đúng?',
    options: [
      '콧등: 원칙 [콛뜽] · 허용 [코뜽]',
      '깻잎: 원칙 [깬닙] · 허용 [깯닙]',
      '콧날: 원칙 [콘날] · 허용 [콛날]',
      '뱃길: 원칙 [배낄] · 허용 [밷낄]',
    ],
    correctAnswer: '뱃길: 원칙 [배낄] · 허용 [밷낄]',
    explanation:
        '제30항 1에서 사이시옷을 발음하지 않은 [배낄]이 원칙이고 [밷낄]은 허용입니다. / '
        '[배낄] là cách chính và [밷낄] là cách được chấp nhận.',
  ),
];
