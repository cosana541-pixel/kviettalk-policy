import '../models/hangul_quiz_question.dart';

const hangulNInsertionQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘솜이불’의 올바른 발음은? / “솜이불” được phát âm đúng như thế nào?',
    options: ['소미불', '솜니불', '솜이불', '손니불'],
    correctAnswer: '솜니불',
    explanation:
        '솜 + 이불의 경계에서 ㄴ이 첨가되어 [솜니불]입니다. / ㄴ được thêm ở ranh giới 솜 + 이불: [솜니불].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘맨입’의 올바른 발음은? / “맨입” được phát âm đúng như thế nào?',
    options: ['맨입', '매닙', '맨닙', '맬립'],
    correctAnswer: '맨닙',
    explanation: '맨 + 입의 경계에서 ㄴ이 첨가되어 [맨닙]입니다. / ㄴ được thêm trước 입: [맨닙].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘꽃잎’의 올바른 발음은? / “꽃잎” được phát âm đúng như thế nào?',
    options: ['꼰닙', '꼬칩', '꽃입', '꼰입'],
    correctAnswer: '꼰닙',
    explanation:
        'ㄴ 첨가 뒤에 비음화가 이어져 [꼰닙]입니다. / Sau khi thêm ㄴ, biến âm mũi tiếp tục tạo ra [꼰닙].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘깻잎’의 올바른 발음은? / “깻잎” được phát âm đúng như thế nào?',
    options: ['깨닙', '깬닙', '깻입', '깬입'],
    correctAnswer: '깬닙',
    explanation:
        '깻닙에서 비음화가 이어져 [깬닙]입니다. / Sau khi thêm ㄴ, biến âm mũi tạo ra [깬닙].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘한여름’의 올바른 발음은? / “한여름” được phát âm đúng như thế nào?',
    options: ['한여름', '하녀름', '할려름', '한녀름'],
    correctAnswer: '한녀름',
    explanation: '여 앞에 ㄴ이 첨가되어 [한녀름]입니다. / ㄴ được thêm trước 여: [한녀름].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘색연필’의 올바른 발음은? / “색연필” được phát âm đúng như thế nào?',
    options: ['생년필', '새견필', '색년필', '색연필'],
    correctAnswer: '생년필',
    explanation:
        'ㄴ 첨가 뒤에 비음화가 이어져 [생년필]입니다. / Sau khi thêm ㄴ, biến âm mũi tạo ra [생년필].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘담요’의 올바른 발음은? / “담요” được phát âm đúng như thế nào?',
    options: ['담요', '단뇨', '담뇨', '다묘'],
    correctAnswer: '담뇨',
    explanation: '요 앞에 ㄴ이 첨가되어 [담뇨]입니다. / ㄴ được thêm trước 요: [담뇨].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘식용유’의 올바른 발음은? / “식용유” được phát âm đúng như thế nào?',
    options: ['시굥유', '식용유', '식용뉴', '시굥뉴'],
    correctAnswer: '시굥뉴',
    explanation:
        '연음과 ㄴ 첨가가 함께 반영되어 [시굥뉴]입니다. / Nối âm và thêm ㄴ cùng tạo ra cách đọc [시굥뉴].',
  ),
];
