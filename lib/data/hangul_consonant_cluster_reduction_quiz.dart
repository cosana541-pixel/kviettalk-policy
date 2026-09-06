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
    options: ['안따', '안다', '앋따', '앉다'],
    correctAnswer: '안따',
    explanation:
        'ㄵ → [ㄴ]으로 단순화된 뒤 ㄷ이 [ㄸ]으로 된소리됩니다. / Sau ㄵ → [ㄴ], ㄷ tiếp tục được căng hóa thành [ㄸ]: [안따].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘여덟’의 실제 발음은? / “여덟” được phát âm thực tế như thế nào?',
    options: ['여덜', '여덥', '여덧', '여덟'],
    correctAnswer: '여덜',
    explanation:
        'ㄼ은 음절 끝에서 [ㄹ]로 발음됩니다. / ㄼ được phát âm thành [ㄹ] ở cuối âm tiết: [여덜].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘핥다’의 실제 발음은? / “핥다” được phát âm thực tế như thế nào?',
    options: ['할따', '할다', '핟따', '핥다'],
    correctAnswer: '할따',
    explanation:
        'ㄾ → [ㄹ]로 단순화된 뒤 ㄷ이 [ㄸ]으로 된소리됩니다. / Sau ㄾ → [ㄹ], ㄷ tiếp tục được căng hóa thành [ㄸ]: [할따].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘값’의 실제 발음은? / “값” được phát âm thực tế như thế nào?',
    options: ['갑', '갓', '각', '값'],
    correctAnswer: '갑',
    explanation:
        'ㅄ은 음절 끝에서 [ㅂ]으로 발음됩니다. / ㅄ được phát âm thành [ㅂ] ở cuối âm tiết: [갑].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘닭’의 실제 발음은? / “닭” được phát âm thực tế như thế nào?',
    options: ['닥', '달', '닭', '답'],
    correctAnswer: '닥',
    explanation:
        'ㄺ은 음절 끝에서 [ㄱ]으로 발음됩니다. / ㄺ được phát âm thành [ㄱ] ở cuối âm tiết: [닥].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘삶’의 실제 발음은? / “삶” được phát âm thực tế như thế nào?',
    options: ['삼ː', '살', '삽', '삶'],
    correctAnswer: '삼ː',
    explanation:
        'ㄻ은 음절 끝에서 [ㅁ]으로 발음되어 [삼ː]입니다. / ㄻ được phát âm thành [ㅁ]: [삼ː].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘읊다’의 실제 발음은? / “읊다” được phát âm thực tế như thế nào?',
    options: ['읍따', '읍다', '을따', '읊다'],
    correctAnswer: '읍따',
    explanation:
        'ㄿ → [ㅂ]으로 단순화된 뒤 ㄷ이 [ㄸ]으로 된소리됩니다. / Sau ㄿ → [ㅂ], ㄷ tiếp tục được căng hóa thành [ㄸ]: [읍따].',
  ),
];
