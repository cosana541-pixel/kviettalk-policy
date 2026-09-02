import '../models/hangul_quiz_question.dart';

const hangulLiaisonQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "'먹어요' được phát âm gần với cách nào?",
    options: ['머거요', '먹어요', '머꺼요', '멍어요'],
    correctAnswer: '머거요',
    explanation:
        '받침 ㄱ được nối sang âm tiết 어, vì vậy 먹어요 được phát âm là [머거요].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "'옷이' được phát âm gần với cách nào?",
    options: ['오시', '오디', '옷이', '오치'],
    correctAnswer: '오시',
    explanation:
        '받침 ㅅ được nối sang âm tiết 이 và trở thành âm đầu của 시: [오시].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "'앞에' được phát âm gần với cách nào?",
    options: ['아페', '아베', '압에', '아테'],
    correctAnswer: '아페',
    explanation: '받침 ㅍ được nối sang âm tiết 에 và giữ nguyên âm ㅍ: [아페].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: "Phát âm '바메' tương ứng với cách viết nào?",
    options: ['밤에', '밥에', '바메', '밭에'],
    correctAnswer: '밤에',
    explanation: 'Trong 밤에, 받침 ㅁ được nối sang âm tiết 에 nên phát âm là [바메].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: "Phát âm '나제' tương ứng với cách viết nào?",
    options: ['낮에', '낫에', '나제', '낮이'],
    correctAnswer: '낮에',
    explanation: 'Trong 낮에, 받침 ㅈ được nối sang âm tiết 에 nên phát âm là [나제].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.matchingCharacter,
    prompt: "Phát âm '부어케' tương ứng với cách viết nào?",
    options: ['부엌에', '부어게', '부엌이', '부어케'],
    correctAnswer: '부엌에',
    explanation:
        'Trong 부엌에, 받침 ㅋ được nối sang âm tiết 에 nên phát âm là [부어케].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: "Trong '문을', 받침 nào được nối sang âm tiết sau?",
    options: ['ㄴ', 'ㄱ', 'ㅁ', 'ㄹ'],
    correctAnswer: 'ㄴ',
    explanation: '받침 ㄴ của 문 được nối sang 을: 문을 → [무늘].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: "Trong '집에', 받침 nào được nối sang âm tiết sau?",
    options: ['ㅂ', 'ㄱ', 'ㄴ', 'ㅍ'],
    correctAnswer: 'ㅂ',
    explanation: '받침 ㅂ của 집 được nối sang 에: 집에 → [지베].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.finalConsonant,
    prompt: "Trong '꽃을', 받침 nào được nối sang âm tiết sau?",
    options: ['ㅊ', 'ㅈ', 'ㅅ', 'ㅌ'],
    correctAnswer: 'ㅊ',
    explanation: '받침 ㅊ của 꽃 được nối sang 을: 꽃을 → [꼬츨].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.combiningSyllable,
    prompt: '달 + 이 được nối âm như thế nào?',
    options: ['다리', '달이', '다니', '다미'],
    correctAnswer: '다리',
    explanation: '받침 ㄹ được nối sang 이, tạo cách phát âm [다리].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.combiningSyllable,
    prompt: '밭 + 에 được nối âm như thế nào?',
    options: ['바테', '바데', '바세', '밭에'],
    correctAnswer: '바테',
    explanation: '받침 ㅌ được nối sang 에, tạo cách phát âm [바테].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.combiningSyllable,
    prompt: '닫 + 아요 được nối âm như thế nào?',
    options: ['다다요', '다라요', '닫아요', '다타요'],
    correctAnswer: '다다요',
    explanation: '받침 ㄷ được nối sang 아요, tạo cách phát âm [다다요].',
  ),
];
