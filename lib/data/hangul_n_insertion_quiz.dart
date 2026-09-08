import '../models/hangul_quiz_question.dart';

const hangulNInsertionQuizQuestions = <HangulQuizQuestion>[
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        'ㄴ 첨가가 일어날 수 있는 기본 조건은? / Điều kiện cơ bản để có thể thêm âm ㄴ là gì?',
    options: [
      '합성어·파생어에서 앞말이 자음으로 끝나고 뒷말이 이/야/여/요/유로 시작한다.',
      '형태소 경계와 관계없이 받침 뒤에 ㅣ계열 모음이 오면 항상 적용한다.',
      '합성어에서 앞말이 자음으로 끝나고 뒷말이 모든 종류의 모음으로 시작하면 적용한다.',
      '합성어에서 앞말이 자음으로 끝나고 뒷말이 ㄴ이나 ㅁ으로 시작하면 적용한다.',
    ],
    correctAnswer: '합성어·파생어에서 앞말이 자음으로 끝나고 뒷말이 이/야/여/요/유로 시작한다.',
    explanation:
        '형태소 경계에서 앞말의 받침과 뒷말의 이/야/여/요/유가 만나는 것이 핵심 조건입니다. / Điều kiện cốt lõi là ranh giới hình vị: phần trước kết thúc bằng phụ âm và phần sau bắt đầu bằng 이/야/여/요/유.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt: '‘꽃잎’의 올바른 변화 순서는? / Thứ tự biến đổi đúng của “꽃잎” là gì?',
    options: ['꽃잎 → 꽃입 → 꽃닙', '꽃잎 → 꽃닙 → 꼰닙', '꽃잎 → 꼰입 → 꼰닙', '꽃잎 → 꼳닙 → 꼰입'],
    correctAnswer: '꽃잎 → 꽃닙 → 꼰닙',
    explanation:
        '먼저 ㄴ이 첨가되어 [꽃닙]이 되고, 다음에 받침 ㄷ이 ㄴ 앞에서 비음 [ㄴ]으로 바뀌어 [꼰닙]이 됩니다. / Trước hết thêm ㄴ để tạo [꽃닙], sau đó ㄷ cuối âm tiết bị mũi hóa thành ㄴ trước ㄴ, tạo [꼰닙].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '‘색연필’의 ㄴ 첨가 직후 중간 발음과 최종 발음의 짝은? / Cặp dạng trung gian ngay sau khi thêm ㄴ và dạng cuối của “색연필” là gì?',
    options: [
      '중간 [색연필] · 최종 [새견필]',
      '중간 [생년필] · 최종 [색년필]',
      '중간 [색년필] · 최종 [생년필]',
      '중간 [색녀필] · 최종 [생녀필]',
    ],
    correctAnswer: '중간 [색년필] · 최종 [생년필]',
    explanation:
        '연 앞에 ㄴ이 첨가된 중간형은 [색년필]이고, ㄴ 앞의 ㄱ이 ㅇ으로 비음화된 최종형은 [생년필]입니다. / Dạng trung gian sau khi thêm ㄴ là [색년필]; sau khi ㄱ bị mũi hóa thành ㅇ, dạng cuối là [생년필].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '‘내복약’에서 ㄴ 첨가 뒤에 이어지는 변화를 바르게 설명한 것은? / Mô tả đúng biến đổi tiếp theo sau khi thêm ㄴ trong “내복약” là gì?',
    options: [
      'ㄴ 첨가 뒤 ㄴ이 ㄹ로 바뀌어 [내볼략]이 된다.',
      'ㄴ 첨가 뒤 ㅇ이 연음되어 [내보객]이 된다.',
      'ㄴ 첨가 뒤 ㄱ이 ㄲ으로 된소리되어 [내복깍]이 된다.',
      'ㄴ 첨가로 [내복냑]이 된 뒤 ㄱ이 ㅇ으로 비음화되어 [내ː봉냑]이 된다.',
    ],
    correctAnswer: 'ㄴ 첨가로 [내복냑]이 된 뒤 ㄱ이 ㅇ으로 비음화되어 [내ː봉냑]이 된다.',
    explanation:
        '내복+약에 ㄴ이 첨가된 뒤, 새로 생긴 ㄴ 앞에서 받침 ㄱ이 비음 [ㅇ]으로 바뀝니다. / Sau khi thêm ㄴ vào 내복+약, ㄱ cuối âm tiết đổi thành âm mũi ㅇ trước ㄴ mới.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '학습 화면에 없던 ‘직행열차’에 ㄴ 첨가와 관련 음운 변화를 적용한 표준 발음은? / Phát âm chuẩn của từ mới “직행열차” sau khi áp dụng thêm ㄴ và các biến đổi liên quan là gì?',
    options: ['지캥녈차', '직행녈차', '지캥열차', '직행년차'],
    correctAnswer: '지캥녈차',
    explanation:
        '표준 발음법 제29항의 예시로, 열 앞에 ㄴ이 첨가되고 앞부분의 발음 변화까지 반영되어 [지캥녈차]입니다. / Đây là ví dụ của Điều 29: ㄴ được thêm trước 열 và các biến đổi ở phần trước cũng được phản ánh, tạo [지캥녈차].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '받침+이/야/여/요/유 모양이 보여도 ㄴ 첨가를 무조건 적용하면 안 되는 이유는? / Vì sao không thể tự động thêm ㄴ chỉ vì thấy dạng phụ âm cuối + 이/야/여/요/유?',
    options: [
      'ㄴ 첨가는 한자어에서만 허용되는 규칙이기 때문이다.',
      '합성어·파생어의 형태소 경계인지 등 적용 조건을 함께 확인해야 하기 때문이다.',
      '뒷말이 독립적으로 쓰이는 명사일 때에는 ㄴ 첨가가 항상 금지되기 때문이다.',
      '받침을 일곱 대표음으로 바꾼 뒤에는 ㄴ 첨가를 적용할 수 없기 때문이다.',
    ],
    correctAnswer: '합성어·파생어의 형태소 경계인지 등 적용 조건을 함께 확인해야 하기 때문이다.',
    explanation:
        'ㄴ 첨가는 주로 합성어·파생어의 형태소 경계에서 일어나므로 글자 모양만으로 판단하지 않습니다. / Việc thêm ㄴ chủ yếu xảy ra ở ranh giới hình vị trong từ ghép hoặc từ phái sinh, vì vậy không thể chỉ nhìn hình thức chữ viết.',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '‘식용유 [시굥뉴]’에 함께 반영된 규칙의 짝은? / Cặp quy tắc nào cùng được phản ánh trong “식용유 [시굥뉴]”?',
    options: ['유음화 + 된소리되기', '구개음화 + ㅎ 탈락', '연음 + ㄴ 첨가', '자음군 단순화 + 거센소리되기'],
    correctAnswer: '연음 + ㄴ 첨가',
    explanation:
        '식용의 받침 ㄱ이 뒤 모음으로 이어져 [시굥]이 되고, 식용+유의 경계에서 ㄴ이 첨가되어 [시굥뉴]입니다. / ㄱ cuối của 식 nối sang nguyên âm sau, tạo [시굥]; sau đó ㄴ được thêm ở ranh giới 식용+유, tạo [시굥뉴].',
  ),
  HangulQuizQuestion(
    type: HangulQuizQuestionType.pronunciationGuide,
    prompt:
        '다음 중 ㄴ 첨가 뒤에 받침의 비음화까지 이어지는 예는? / Ví dụ nào tiếp tục có biến âm mũi của phụ âm cuối sau khi thêm ㄴ?',
    options: ['솜이불 → 솜니불', '한여름 → 한녀름', '담요 → 담뇨', '꽃잎 → 꽃닙 → 꼰닙'],
    correctAnswer: '꽃잎 → 꽃닙 → 꼰닙',
    explanation:
        '꽃잎은 ㄴ 첨가로 [꽃닙]이 된 뒤 받침 ㄷ이 ㄴ 앞에서 비음 [ㄴ]으로 바뀌어 [꼰닙]이 됩니다. / Trong 꽃잎, sau khi thêm ㄴ tạo [꽃닙], ㄷ cuối âm tiết bị mũi hóa thành ㄴ, tạo [꼰닙].',
  ),
];
