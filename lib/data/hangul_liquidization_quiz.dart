import '../models/hangul_quiz_question.dart';

const hangulLiquidizationQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘신라’의 실제 발음은? / '신라' được phát âm thực tế như thế nào?",
    options: ['실라', '신라', '심라', '신나'],
    correctAnswer: '실라',
    explanation: 'ㄴ + ㄹ이 [ㄹㄹ]로 유음화됩니다. / ㄴ + ㄹ đổi thành [ㄹㄹ]: [실라].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘난로’의 실제 발음은? / '난로' được phát âm thực tế như thế nào?",
    options: ['난로', '날ː로', '난노', '날노'],
    correctAnswer: '날ː로',
    explanation: 'ㄴ + ㄹ이 [ㄹㄹ]로 유음화됩니다. / ㄴ + ㄹ đổi thành [ㄹㄹ]: [날ː로].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘연락’의 실제 발음은? / '연락' được phát âm thực tế như thế nào?",
    options: ['연락', '연낙', '열락', '열낙'],
    correctAnswer: '열락',
    explanation: 'ㄴ + ㄹ이 [ㄹㄹ]로 유음화됩니다. / ㄴ + ㄹ đổi thành [ㄹㄹ]: [열락].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘신랑’의 실제 발음은? / '신랑' được phát âm thực tế như thế nào?",
    options: ['신랑', '신낭', '실낭', '실랑'],
    correctAnswer: '실랑',
    explanation: 'ㄴ + ㄹ이 [ㄹㄹ]로 유음화됩니다. / ㄴ + ㄹ đổi thành [ㄹㄹ]: [실랑].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘천리’에 적용되는 변화는? / Biến đổi nào được áp dụng trong '천리'?",
    options: ['ㄴ + ㄹ → [ㄹㄹ]', 'ㄴ + ㄹ → [ㄴㄴ]', 'ㄹ + ㄴ → [ㄹㄹ]', 'ㄴ + ㄹ → [ㄴㄹ]'],
    correctAnswer: 'ㄴ + ㄹ → [ㄹㄹ]',
    explanation:
        '받침 ㄴ이 뒤의 ㄹ에 동화되어 [철리]로 발음됩니다. / 받침 ㄴ đồng hóa với ㄹ phía sau, tạo cách đọc [철리].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘광한루’의 올바른 발음은? / '광한루' được phát âm đúng như thế nào?",
    options: ['광ː한루', '광ː할루', '광ː한누', '광ː할누'],
    correctAnswer: '광ː할루',
    explanation:
        '받침 ㄴ이 ㄹ 앞에서 [ㄹ]로 바뀌어 [광ː할루]가 됩니다. / 받침 ㄴ đổi thành [ㄹ] trước ㄹ: [광ː할루].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: "‘대관령’의 유음화 결과는? / Kết quả lưu âm hóa của '대관령' là gì?",
    options: ['대ː관령', '대ː관녕', '대ː괄령', '대ː괄녕'],
    correctAnswer: '대ː괄령',
    explanation:
        '받침 ㄴ이 ㄹ 앞에서 [ㄹ]로 바뀌어 [대ː괄령]이 됩니다. / 받침 ㄴ đổi thành [ㄹ] trước ㄹ: [대ː괄령].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        "‘줄넘기’의 유음화와 된소리되기가 반영된 발음은? / Cách đọc nào phản ánh cả lưu âm hóa và căng hóa trong '줄넘기'?",
    options: ['줄넘기', '준넘기', '줄럼기', '줄럼끼'],
    correctAnswer: '줄럼끼',
    explanation:
        'ㄹ + ㄴ이 [ㄹㄹ]로 유음화되고, 뒤의 ㄱ이 [ㄲ]으로 된소리되어 [줄럼끼]가 됩니다. / ㄹ + ㄴ đổi thành [ㄹㄹ], rồi ㄱ được căng hóa thành [ㄲ]: [줄럼끼].',
  ),
];
