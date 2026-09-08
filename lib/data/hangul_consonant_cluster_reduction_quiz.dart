import '../models/hangul_quiz_question.dart';

const hangulConsonantClusterReductionQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘넋’의 실제 발음은? / “넋” được phát âm thực tế như thế nào?',
    options: ['넉', '넋', '널', '넙'],
    correctAnswer: '넉',
    explanation:
        'ㄳ은 음절 끝에서 [ㄱ]으로 발음됩니다. / ㄳ được phát âm thành [ㄱ] ở cuối âm tiết: [넉].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘앉다’의 실제 발음은? / “앉다” được phát âm thực tế như thế nào?',
    options: ['안다', '안따', '앋따', '앉다'],
    correctAnswer: '안따',
    explanation:
        'ㄵ → [ㄴ]으로 단순화된 뒤 ㄷ이 [ㄸ]으로 된소리됩니다. / Sau ㄵ → [ㄴ], ㄷ tiếp tục được căng hóa thành [ㄸ]: [안따].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '‘여덟’의 ㄼ에서 자음군 단순화 뒤 남는 받침은? / Sau khi giản lược ㄼ trong “여덟”, âm cuối nào còn lại?',
    options: ['[ㄱ]', '[ㅂ]', '[ㄹ]', '[ㄷ]'],
    correctAnswer: '[ㄹ]',
    explanation:
        '여덟의 ㄼ은 음절 끝에서 [ㄹ]만 남아 [여덜]로 발음됩니다. / ㄼ trong 여덟 giữ lại [ㄹ] ở cuối âm tiết, tạo cách đọc [여덜].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘핥다’의 실제 발음은? / “핥다” được phát âm thực tế như thế nào?',
    options: ['할다', '핟따', '핥다', '할따'],
    correctAnswer: '할따',
    explanation:
        'ㄾ → [ㄹ]로 단순화된 뒤 ㄷ이 [ㄸ]으로 된소리됩니다. / Sau ㄾ → [ㄹ], ㄷ tiếp tục được căng hóa thành [ㄸ]: [할따].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '‘값’의 첫 자음군 단순화 단계는? / Bước giản lược cụm phụ âm đầu tiên của “값” là gì?',
    options: ['ㅄ → [ㅂ]', 'ㅄ → [ㅅ]', 'ㅄ → [ㄱ]', 'ㅄ → [ㄷ]'],
    correctAnswer: 'ㅄ → [ㅂ]',
    explanation:
        '겹받침 ㅄ은 음절 끝에서 [ㅂ]으로 단순화되어 값은 [갑]이 됩니다. / Cụm ㅄ được giản lược thành [ㅂ] ở cuối âm tiết, nên 값 được đọc là [갑].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '‘읽다’의 자음군 단순화와 된소리되기가 반영된 발음은? / Cách đọc nào phản ánh cả giản lược cụm phụ âm và căng hóa trong “읽다”?',
    options: ['일다', '익따', '일따', '익다'],
    correctAnswer: '익따',
    explanation:
        'ㄺ이 ㄷ 앞에서 [ㄱ]으로 단순화된 뒤 ㄷ이 [ㄸ]으로 된소리되어 [익따]가 됩니다. / ㄺ được giản lược thành [ㄱ] trước ㄷ, rồi ㄷ căng thành [ㄸ]: [익따].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘젊다’의 변화 순서로 알맞은 것은? / Thứ tự biến đổi đúng của “젊다” là gì?',
    options: [
      'ㄻ → [ㄹ] → [절따]',
      'ㄻ → [ㅂ] → [접따]',
      'ㄻ → [ㅁ] → [점따]',
      'ㄻ → [ㄴ] → [전따]',
    ],
    correctAnswer: 'ㄻ → [ㅁ] → [점따]',
    explanation:
        'ㄻ이 [ㅁ]으로 단순화된 뒤 ㄷ이 [ㄸ]으로 된소리되어 [점따]가 됩니다. / ㄻ được giản lược thành [ㅁ], rồi ㄷ căng thành [ㄸ]: [점따].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘읊다’의 실제 발음은? / “읊다” được phát âm thực tế như thế nào?',
    options: ['읍다', '을따', '읊다', '읍따'],
    correctAnswer: '읍따',
    explanation:
        'ㄿ → [ㅂ]으로 단순화된 뒤 ㄷ이 [ㄸ]으로 된소리됩니다. / Sau ㄿ → [ㅂ], ㄷ tiếp tục được căng hóa thành [ㄸ]: [읍따].',
  ),
];
