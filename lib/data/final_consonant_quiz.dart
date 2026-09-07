import '../models/hangul_quiz_question.dart';

const finalConsonantQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘밖’의 표준 발음은 무엇인가요? / “밖” được phát âm chuẩn thế nào?',
    options: ['박', '밖', '밥', '받'],
    correctAnswer: '박',
    explanation:
        '받침 ㄲ은 단어 끝에서 [ㄱ]으로 발음해요. / Ở cuối từ, ㄲ được đọc thành [ㄱ]: [박].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘옷’의 표준 발음은 무엇인가요? / “옷” được phát âm chuẩn thế nào?',
    options: ['옷', '옫', '옻', '옥'],
    correctAnswer: '옫',
    explanation:
        '받침 ㅅ은 단어 끝에서 [ㄷ]으로 발음해요. / Ở cuối từ, ㅅ được đọc thành [ㄷ]: [옫].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘앞’의 표준 발음은 무엇인가요? / “앞” được phát âm chuẩn thế nào?',
    options: ['앞', '앋', '압', '악'],
    correctAnswer: '압',
    explanation:
        '받침 ㅍ은 단어 끝에서 [ㅂ]으로 발음해요. / Ở cuối từ, ㅍ được đọc thành [ㅂ]: [압].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘공’의 표준 발음은 무엇인가요? / “공” được phát âm chuẩn thế nào?',
    options: ['곤', '곰', '골', '공'],
    correctAnswer: '공',
    explanation:
        '받침 ㅇ은 단어 끝에서 [ㅇ]으로 발음해요. / Ở cuối từ, ㅇ được đọc là [ㅇ]: [공].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘문’의 표준 발음은 무엇인가요? / “문” được phát âm chuẩn thế nào?',
    options: ['문', '뭄', '물', '뭉'],
    correctAnswer: '문',
    explanation:
        '받침 ㄴ은 단어 끝에서 [ㄴ]으로 발음해요. / Ở cuối từ, ㄴ được đọc là [ㄴ]: [문].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘달’의 표준 발음은 무엇인가요? / “달” được phát âm chuẩn thế nào?',
    options: ['단', '달', '담', '당'],
    correctAnswer: '달',
    explanation: '받침 ㄹ은 단어 끝에서 [ㄹ]로 발음해요. / Ở cuối từ, ㄹ được đọc là [ㄹ]: [달].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘밤’의 표준 발음은 무엇인가요? / “밤” được phát âm chuẩn thế nào?',
    options: ['반', '발', '밤', '방'],
    correctAnswer: '밤',
    explanation:
        '받침 ㅁ은 단어 끝에서 [ㅁ]으로 발음해요. / Ở cuối từ, ㅁ được đọc là [ㅁ]: [밤].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘히읗’의 표준 발음은 무엇인가요? / “히읗” được phát âm chuẩn thế nào?',
    options: ['히읍', '히읏', '히읔', '히읃'],
    correctAnswer: '히읃',
    explanation:
        '마지막 받침 ㅎ은 [ㄷ]으로 발음해요. / ㅎ ở cuối từ được đọc thành [ㄷ]: [히읃].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: '“국”의 받침은 무엇인가요? / 받침 trong “국” là chữ nào?',
    options: ['ㄱ', 'ㄴ', 'ㄷ', 'ㅂ'],
    correctAnswer: 'ㄱ',
    explanation: '국의 받침은 ㄱ이에요. / 국 có 받침 ㄱ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: '[ㄷ] 대표음으로 발음되는 받침은? / 받침 nào được đọc bằng âm [ㄷ]?',
    options: ['ㄱ', 'ㅈ', 'ㅂ', 'ㅇ'],
    correctAnswer: 'ㅈ',
    explanation: '받침 ㅈ은 단어 끝에서 [ㄷ]으로 발음해요. / ㅈ ở cuối từ được đọc thành [ㄷ].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: '“꽃”의 받침은 무엇인가요? / 받침 trong “꽃” là chữ nào?',
    options: ['ㅈ', 'ㅌ', 'ㅊ', 'ㅍ'],
    correctAnswer: 'ㅊ',
    explanation: '꽃의 받침은 ㅊ이에요. / 꽃 có 받침 ㅊ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: '[ㄱ] 대표음으로 발음되는 받침은? / 받침 nào được đọc bằng âm [ㄱ]?',
    options: ['ㄴ', 'ㅌ', 'ㅍ', 'ㅋ'],
    correctAnswer: 'ㅋ',
    explanation: '받침 ㅋ은 단어 끝에서 [ㄱ]으로 발음해요. / ㅋ ở cuối từ được đọc thành [ㄱ].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: '[ㄷ] 대표음으로 발음되는 받침은? / 받침 nào thuộc nhóm âm [ㄷ]?',
    options: ['ㅌ', 'ㄱ', 'ㄴ', 'ㅂ'],
    correctAnswer: 'ㅌ',
    explanation: '받침 ㅌ은 단어 끝에서 [ㄷ]으로 발음해요. / ㅌ ở cuối từ được đọc thành [ㄷ].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: '“있다”의 첫 음절 받침은? / 받침 của âm tiết đầu trong “있다” là gì?',
    options: ['ㅅ', 'ㅆ', 'ㅈ', 'ㅊ'],
    correctAnswer: 'ㅆ',
    explanation: '있의 받침은 ㅆ이에요. / Âm tiết 있 có 받침 ㅆ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: '[ㅂ] 대표음으로 발음되는 받침은? / 받침 nào được đọc bằng âm [ㅂ]?',
    options: ['ㄱ', 'ㅌ', 'ㅍ', 'ㅇ'],
    correctAnswer: 'ㅍ',
    explanation: '받침 ㅍ은 단어 끝에서 [ㅂ]으로 발음해요. / ㅍ ở cuối từ được đọc thành [ㅂ].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: '“곧”의 받침은 무엇인가요? / 받침 trong “곧” là chữ nào?',
    options: ['ㄱ', 'ㄴ', 'ㅂ', 'ㄷ'],
    correctAnswer: 'ㄷ',
    explanation: '곧의 받침은 ㄷ이에요. / 곧 có 받침 ㄷ.',
  ),
];
