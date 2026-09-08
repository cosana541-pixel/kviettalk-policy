class HangulNInsertionExample {
  const HangulNInsertionExample({
    required this.writtenForm,
    required this.pronunciation,
    required this.wordBoundary,
    required this.koreanExplanation,
    required this.vietnameseExplanation,
    this.changeProcess,
  });

  final String writtenForm;
  final String pronunciation;
  final String wordBoundary;
  final String koreanExplanation;
  final String vietnameseExplanation;
  final String? changeProcess;

  bool get hasChangeProcess => changeProcess != null;
}

const hangulNInsertionExamples = <HangulNInsertionExample>[
  HangulNInsertionExample(
    writtenForm: '솜이불',
    pronunciation: '솜니불',
    wordBoundary: '솜 + 이불',
    koreanExplanation: '합성어의 경계에서 이불의 이 앞에 ㄴ 소리가 첨가됩니다.',
    vietnameseExplanation:
        'Ở ranh giới từ ghép, âm ㄴ được thêm trước 이 của từ 이불.',
  ),
  HangulNInsertionExample(
    writtenForm: '맨입',
    pronunciation: '맨닙',
    wordBoundary: '맨 + 입',
    koreanExplanation: '앞말이 자음으로 끝나고 뒷말이 이로 시작하여 ㄴ 소리가 첨가됩니다.',
    vietnameseExplanation:
        'Từ trước kết thúc bằng phụ âm và từ sau bắt đầu bằng 이, nên âm ㄴ được thêm vào.',
  ),
  HangulNInsertionExample(
    writtenForm: '꽃잎',
    pronunciation: '꼰닙',
    wordBoundary: '꽃 + 잎',
    changeProcess: '꽃 + 잎 → 꽃닙 → 꼰닙',
    koreanExplanation: '먼저 잎 앞에 ㄴ이 첨가되어 [꽃닙]이 되고, 받침 발음과 비음화가 이어져 [꼰닙]이 됩니다.',
    vietnameseExplanation:
        'Trước hết ㄴ được thêm trước 잎 tạo thành [꽃닙], sau đó biến âm mũi tiếp tục tạo ra [꼰닙].',
  ),
  HangulNInsertionExample(
    writtenForm: '내복약',
    pronunciation: '내ː봉냑',
    wordBoundary: '내복 + 약',
    changeProcess: '내복 + 약 → 내복냑 → 내ː봉냑',
    koreanExplanation:
        '먼저 약 앞에 ㄴ이 첨가되어 [내복냑]이 되고, 새로 생긴 ㄴ 앞에서 받침 ㄱ이 ㅇ으로 비음화되어 [내ː봉냑]이 됩니다.',
    vietnameseExplanation:
        'Trước hết ㄴ được thêm trước 약, tạo thành [내복냑]. Sau đó, ㄱ cuối âm tiết đổi thành âm mũi ㅇ trước ㄴ mới xuất hiện, tạo ra [내ː봉냑].',
  ),
  HangulNInsertionExample(
    writtenForm: '한여름',
    pronunciation: '한녀름',
    wordBoundary: '한 + 여름',
    koreanExplanation: '합성어의 경계에서 여 앞에 ㄴ 소리가 첨가되어 [녀]로 발음됩니다.',
    vietnameseExplanation:
        'Ở ranh giới từ ghép, âm ㄴ được thêm trước 여 nên âm tiết này được đọc là [녀].',
  ),
  HangulNInsertionExample(
    writtenForm: '색연필',
    pronunciation: '생년필',
    wordBoundary: '색 + 연필',
    changeProcess: '색 + 연필 → 색년필 → 생년필',
    koreanExplanation: '먼저 연필 앞에 ㄴ이 첨가되어 [색년필]이 되고, 비음화가 이어져 [생년필]이 됩니다.',
    vietnameseExplanation:
        'Trước hết ㄴ được thêm trước 연필 tạo thành [색년필], rồi biến âm mũi tạo ra [생년필].',
  ),
  HangulNInsertionExample(
    writtenForm: '담요',
    pronunciation: '담뇨',
    wordBoundary: '담 + 요',
    koreanExplanation: '합성어의 경계에서 요 앞에 ㄴ 소리가 첨가되어 [뇨]로 발음됩니다.',
    vietnameseExplanation:
        'Ở ranh giới từ ghép, âm ㄴ được thêm trước 요 nên âm tiết này được đọc là [뇨].',
  ),
  HangulNInsertionExample(
    writtenForm: '식용유',
    pronunciation: '시굥뉴',
    wordBoundary: '식용 + 유',
    koreanExplanation: '식용과 유의 경계에서 ㄴ이 첨가되고 앞부분의 연음까지 반영되어 [시굥뉴]로 발음됩니다.',
    vietnameseExplanation:
        'ㄴ được thêm ở ranh giới giữa 식용 và 유; cùng với nối âm ở phần trước, cách đọc cuối cùng là [시굥뉴].',
  ),
];
