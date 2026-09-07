import '../models/hangul_quiz_question.dart';

const compoundFinalConsonantQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘몫’의 표준 발음은 무엇인가요? / “몫” được phát âm chuẩn thế nào?',
    options: ['목', '몯', '몰', '몹'],
    correctAnswer: '목',
    explanation:
        '겹받침 ㄳ은 단어 끝에서 [ㄱ]으로 발음해요. / ㄳ ở cuối từ được đọc bằng [ㄱ]: [목].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: '“앉다”의 겹받침은? / 받침 kép trong “앉다” là gì?',
    options: ['ㄳ', 'ㄵ', 'ㄶ', 'ㄻ'],
    correctAnswer: 'ㄵ',
    explanation: '앉다의 겹받침은 ㄵ이에요. / 앉다 có 받침 kép ㄵ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘많다’의 표준 발음은 무엇인가요? / “많다” được phát âm chuẩn thế nào?',
    options: ['만다', '마나다', '만타', '만따'],
    correctAnswer: '만타',
    explanation:
        'ㄶ에서 [ㄴ]이 남고 뒤의 ㄷ은 [ㅌ]으로 들려요. / ㄶ để lại [ㄴ] và ㄷ phía sau được nghe thành [ㅌ]: [만타].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: '“닭”의 겹받침은? / 받침 kép trong “닭” là gì?',
    options: ['ㄳ', 'ㄻ', 'ㄼ', 'ㄺ'],
    correctAnswer: 'ㄺ',
    explanation: '닭의 겹받침은 ㄺ이에요. / 닭 có 받침 kép ㄺ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘삶’의 표준 발음은 무엇인가요? / “삶” được phát âm chuẩn thế nào?',
    options: ['삼ː', '살', '삽', '삭'],
    correctAnswer: '삼ː',
    explanation:
        '겹받침 ㄻ은 단어 끝에서 [ㅁ]으로 발음해요. / ㄻ ở cuối từ được đọc bằng [ㅁ]: [삼ː].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘여덟’의 표준 발음은 무엇인가요? / “여덟” được phát âm chuẩn thế nào?',
    options: ['여덥', '여덜', '여덧', '여덕'],
    correctAnswer: '여덜',
    explanation: '여덟의 ㄼ은 [ㄹ]로 발음해요. / ㄼ trong 여덟 được đọc bằng [ㄹ]: [여덜].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘외곬’의 표준 발음은 무엇인가요? / “외곬” được phát âm chuẩn thế nào?',
    options: ['외곡', '외곧', '외골', '외곱'],
    correctAnswer: '외골',
    explanation:
        '겹받침 ㄽ은 단어 끝에서 [ㄹ]로 발음해요. / ㄽ ở cuối từ được đọc bằng [ㄹ]: [외골].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: '“핥다”의 겹받침은? / 받침 kép trong “핥다” là gì?',
    options: ['ㄽ', 'ㄿ', 'ㅄ', 'ㄾ'],
    correctAnswer: 'ㄾ',
    explanation: '핥다의 겹받침은 ㄾ이에요. / 핥다 có 받침 kép ㄾ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: '“읊다”의 겹받침은? / 받침 kép trong “읊다” là gì?',
    options: ['ㄿ', 'ㄾ', 'ㅀ', 'ㅄ'],
    correctAnswer: 'ㄿ',
    explanation: '읊다의 겹받침은 ㄿ이에요. / 읊다 có 받침 kép ㄿ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘싫다’의 표준 발음은 무엇인가요? / “싫다” được phát âm chuẩn thế nào?',
    options: ['실다', '실타', '싣따', '시러'],
    correctAnswer: '실타',
    explanation:
        'ㅀ에서 [ㄹ]이 남고 뒤의 ㄷ은 [ㅌ]으로 들려요. / ㅀ để lại [ㄹ] và ㄷ phía sau được nghe thành [ㅌ]: [실타].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘값’의 표준 발음은 무엇인가요? / “값” được phát âm chuẩn thế nào?',
    options: ['각', '갓', '갑', '갈'],
    correctAnswer: '갑',
    explanation:
        '겹받침 ㅄ은 단어 끝에서 [ㅂ]으로 발음해요. / ㅄ ở cuối từ được đọc bằng [ㅂ]: [갑].',
  ),
];
