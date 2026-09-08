import '../models/hangul_quiz_question.dart';

const hangulRieulNasalizationQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '‘음력’에서 먼저 확인해야 할 핵심 음운 변화는? / Biến đổi âm vị cốt lõi cần xác định trước trong “음력” là gì?',
    options: [
      '받침 ㅁ 뒤의 ㄹ이 [ㄴ]으로 바뀐다.',
      'ㄹ의 영향으로 받침 ㅁ이 먼저 [ㅂ]으로 바뀐다.',
      'ㅁ+ㄹ이 일반 유음화되어 [ㄹㄹ]로 바뀐다.',
      '받침 ㅁ과 뒤의 ㄹ이 변화 없이 그대로 발음된다.',
    ],
    correctAnswer: '받침 ㅁ 뒤의 ㄹ이 [ㄴ]으로 바뀐다.',
    explanation:
        '제19항에 따라 받침 ㅁ 뒤의 ㄹ이 먼저 [ㄴ]으로 바뀌며, 그 결과 음력은 [음녁]으로 발음됩니다. / Theo Điều 19, ㄹ sau 받침 ㅁ đổi thành [ㄴ] trước, vì vậy 음력 được phát âm là [음녁].',
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
    prompt:
        '‘대통령’에 일반 유음화가 아니라 ㄹ의 비음화가 적용되는 이유는? / Vì sao “대통령” áp dụng mũi hóa ㄹ thay vì lưu âm hóa thông thường?',
    options: [
      'ㄴ+ㄹ이 만나 두 자음이 [ㄹㄹ]로 바뀌기 때문이다.',
      'ㄹ 앞의 ㅇ이 탈락하여 모음끼리 이어지기 때문이다.',
      '받침 ㅇ 뒤에 연결된 ㄹ이 [ㄴ]으로 발음되기 때문이다.',
      'ㄹ이 뒤 자음을 된소리로 만들기 때문이다.',
    ],
    correctAnswer: '받침 ㅇ 뒤에 연결된 ㄹ이 [ㄴ]으로 발음되기 때문이다.',
    explanation:
        '제19항에 따라 받침 ㅇ 뒤의 ㄹ은 [ㄴ]으로 바뀌므로 [대ː통녕]입니다. / Theo Điều 19, ㄹ sau 받침 ㅇ đổi thành [ㄴ], tạo cách đọc [대ː통녕].',
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
    prompt:
        '‘협력’에서 일어나는 연쇄 변화의 순서를 바르게 설명한 것은? / Mô tả đúng thứ tự biến đổi liên tiếp trong “협력” là gì?',
    options: ['협력 → 혐력 → 혐녁', '협력 → 협녁 → 혐녁', '협력 → 혈력 → 혐녁', '협력 → 협녁'],
    correctAnswer: '협력 → 협녁 → 혐녁',
    explanation:
        '협력 → 협녁(ㄹ→ㄴ) → 혐녁(ㅂ→ㅁ)의 순서입니다. / Thứ tự là 협력 → 협녁 (ㄹ→ㄴ) → 혐녁 (ㅂ→ㅁ).',
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
