import '../models/hangul_quiz_question.dart';

const hangulRieulNasalizationQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘음력’의 표준 발음은? / Cách phát âm chuẩn của “음력” là gì?',
    options: ['음녁', '음력', '음력끄', '읍녁'],
    correctAnswer: '음녁',
    explanation:
        '받침 ㅁ 뒤의 ㄹ은 [ㄴ]으로 발음되어 [음녁]입니다. / ㄹ sau 받침 ㅁ đổi thành [ㄴ], nên đọc là [음녁].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘침략’에서 일어나는 핵심 변화는? / Biến đổi chính trong “침략” là gì?',
    options: ['ㅁ → ㅂ', 'ㄹ → ㄴ', 'ㄹ → ㄹㄹ', 'ㄴ → ㄹ'],
    correctAnswer: 'ㄹ → ㄴ',
    explanation:
        'ㅁ 뒤의 ㄹ이 [ㄴ]으로 바뀌어 [침ː냑]이 됩니다. / ㄹ sau ㅁ đổi thành [ㄴ], tạo cách đọc [침ː냑].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘대통령’의 표준 발음은? / Cách phát âm chuẩn của “대통령” là gì?',
    options: ['대통령', '대ː통령', '대ː통녕', '대통렬'],
    correctAnswer: '대ː통녕',
    explanation:
        'ㅇ 뒤의 ㄹ이 [ㄴ]으로 바뀌어 [대ː통녕]입니다. / ㄹ sau ㅇ đổi thành [ㄴ], nên đọc là [대ː통녕].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: 'ㄹ의 비음화를 바르게 설명한 것은? / Mô tả nào đúng về mũi hóa ㄹ?',
    options: [
      '모든 ㄹ이 항상 [ㄴ]으로 바뀐다.',
      'ㄴ과 ㄹ은 언제나 [ㄹㄹ]로만 발음한다.',
      '받침 ㅁ, ㅇ 뒤의 ㄹ은 [ㄹ] 그대로 발음한다.',
      '받침 ㅁ, ㅇ 뒤에 연결되는 ㄹ은 [ㄴ]으로 발음한다.',
    ],
    correctAnswer: '받침 ㅁ, ㅇ 뒤에 연결되는 ㄹ은 [ㄴ]으로 발음한다.',
    explanation:
        '표준 발음법 제19항의 핵심 규칙입니다. / Đây là quy tắc chính của Điều 19: ㄹ sau 받침 ㅁ hoặc ㅇ được đọc thành [ㄴ].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘막론’의 올바른 변화 과정은? / Quá trình biến âm đúng của “막론” là gì?',
    options: ['막론 → 막논 → 망논', '막론 → 망론 → 망논', '막론 → 말론 → 말논', '막론 → 막론 → 망론'],
    correctAnswer: '막론 → 막논 → 망논',
    explanation: '먼저 ㄹ→ㄴ, 다음에 ㄱ→ㅇ 순서로 바뀝니다. / Trước tiên ㄹ→ㄴ, sau đó ㄱ→ㅇ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘협력’의 연쇄 비음화 결과는? / Kết quả biến âm mũi liên tiếp của “협력” là gì?',
    options: ['협녁', '혐녁', '혐력', '현녁'],
    correctAnswer: '혐녁',
    explanation:
        '협력 → 협녁(ㄹ→ㄴ) → 혐녁(ㅂ→ㅁ)입니다. / 협력 đổi thành 협녁 rồi 혐녁: ㄹ→ㄴ, sau đó ㅂ→ㅁ.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '일반 유음화와 다른 [ㄴㄴ] 발음의 예는? / Từ nào có [ㄴㄴ], khác với biến âm [ㄹㄹ] thông thường?',
    options: ['신라 [실라]', '설날 [설ː랄]', '생산량 [생산냥]', '연락 [열락]'],
    correctAnswer: '생산량 [생산냥]',
    explanation:
        '생산량은 ㄹ이 [ㄴ]으로 바뀌어 [생산냥]입니다. / Trong 생산량, ㄹ đổi thành [ㄴ], nên đọc là [생산냥].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘의견란’의 표준 발음은? / Cách phát âm chuẩn của “의견란” là gì?',
    options: ['의견란', '의ː결란', '의ː결난', '의ː견난'],
    correctAnswer: '의ː견난',
    explanation:
        '이 단어에서는 ㄴ+ㄹ이 [ㄹㄹ]이 아니라 [ㄴㄴ]으로 발음됩니다. / Ở từ này, ㄴ+ㄹ được đọc thành [ㄴㄴ], không phải [ㄹㄹ].',
  ),
];
