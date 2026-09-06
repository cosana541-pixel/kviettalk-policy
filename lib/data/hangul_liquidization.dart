class HangulLiquidizationExample {
  const HangulLiquidizationExample({
    required this.writtenForm,
    required this.pronunciation,
    required this.beforePart,
    required this.afterPart,
    required this.rule,
    required this.koreanExplanation,
    required this.vietnameseExplanation,
  });

  final String writtenForm;
  final String pronunciation;
  final String beforePart;
  final String afterPart;
  final String rule;
  final String koreanExplanation;
  final String vietnameseExplanation;

  String get writtenStructure => '$beforePart + $afterPart';
}

const hangulLiquidizationExamples = <HangulLiquidizationExample>[
  HangulLiquidizationExample(
    writtenForm: '신라',
    pronunciation: '실라',
    beforePart: '신',
    afterPart: '라',
    rule: 'ㄴ + ㄹ → [ㄹㄹ]',
    koreanExplanation: '받침 ㄴ이 뒤의 ㄹ을 만나 [ㄹ]로 바뀝니다.',
    vietnameseExplanation: '받침 ㄴ gặp ㄹ phía sau và đổi thành [ㄹ].',
  ),
  HangulLiquidizationExample(
    writtenForm: '난로',
    pronunciation: '날ː로',
    beforePart: '난',
    afterPart: '로',
    rule: 'ㄴ + ㄹ → [ㄹㄹ]',
    koreanExplanation: '받침 ㄴ과 뒤의 ㄹ이 이어져 [ㄹㄹ]로 발음됩니다.',
    vietnameseExplanation: 'ㄴ cuối và ㄹ phía sau được phát âm thành [ㄹㄹ].',
  ),
  HangulLiquidizationExample(
    writtenForm: '연락',
    pronunciation: '열락',
    beforePart: '연',
    afterPart: '락',
    rule: 'ㄴ + ㄹ → [ㄹㄹ]',
    koreanExplanation: '받침 ㄴ이 ㄹ 앞에서 [ㄹ]로 바뀌어 [열락]이 됩니다.',
    vietnameseExplanation: 'ㄴ đổi thành [ㄹ] trước ㄹ, tạo cách đọc [열락].',
  ),
  HangulLiquidizationExample(
    writtenForm: '신랑',
    pronunciation: '실랑',
    beforePart: '신',
    afterPart: '랑',
    rule: 'ㄴ + ㄹ → [ㄹㄹ]',
    koreanExplanation: '받침 ㄴ이 ㄹ 앞에서 [ㄹ]로 바뀌어 [실랑]이 됩니다.',
    vietnameseExplanation: 'ㄴ đổi thành [ㄹ] trước ㄹ, tạo cách đọc [실랑].',
  ),
  HangulLiquidizationExample(
    writtenForm: '설날',
    pronunciation: '설ː랄',
    beforePart: '설',
    afterPart: '날',
    rule: 'ㄹ + ㄴ → [ㄹㄹ]',
    koreanExplanation: '뒤의 ㄴ이 받침 ㄹ을 만나 [ㄹ]로 바뀝니다.',
    vietnameseExplanation: 'ㄴ phía sau gặp 받침 ㄹ và đổi thành [ㄹ].',
  ),
  HangulLiquidizationExample(
    writtenForm: '칼날',
    pronunciation: '칼랄',
    beforePart: '칼',
    afterPart: '날',
    rule: 'ㄹ + ㄴ → [ㄹㄹ]',
    koreanExplanation: '받침 ㄹ 뒤의 ㄴ이 [ㄹ]로 바뀌어 [칼랄]이 됩니다.',
    vietnameseExplanation: 'ㄴ sau 받침 ㄹ đổi thành [ㄹ], tạo cách đọc [칼랄].',
  ),
  HangulLiquidizationExample(
    writtenForm: '물난리',
    pronunciation: '물랄리',
    beforePart: '물',
    afterPart: '난리',
    rule: 'ㄹ + ㄴ → [ㄹㄹ]',
    koreanExplanation: '물의 ㄹ과 난리의 ㄴ이 만나 [ㄹㄹ]로 발음됩니다.',
    vietnameseExplanation: 'ㄹ trong 물 gặp ㄴ trong 난리 và được đọc thành [ㄹㄹ].',
  ),
  HangulLiquidizationExample(
    writtenForm: '실내',
    pronunciation: '실래',
    beforePart: '실',
    afterPart: '내',
    rule: 'ㄹ + ㄴ → [ㄹㄹ]',
    koreanExplanation: '받침 ㄹ 뒤의 ㄴ이 [ㄹ]로 바뀌어 [실래]가 됩니다.',
    vietnameseExplanation: 'ㄴ sau 받침 ㄹ đổi thành [ㄹ], tạo cách đọc [실래].',
  ),
];
