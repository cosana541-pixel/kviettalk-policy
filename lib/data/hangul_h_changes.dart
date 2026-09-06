class HangulHChangeExample {
  const HangulHChangeExample({
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

const hangulHChangeExamples = <HangulHChangeExample>[
  HangulHChangeExample(
    writtenForm: '놓고',
    pronunciation: '노코',
    beforePart: '놓',
    afterPart: '고',
    rule: 'ㅎ + ㄱ → [ㅋ]',
    koreanExplanation: '받침 ㅎ과 뒤의 ㄱ이 합쳐져 거센소리 [ㅋ]으로 발음됩니다.',
    vietnameseExplanation:
        'ㅎ cuối kết hợp với ㄱ phía sau và được phát âm thành âm bật hơi [ㅋ].',
  ),
  HangulHChangeExample(
    writtenForm: '좋던',
    pronunciation: '조ː턴',
    beforePart: '좋',
    afterPart: '던',
    rule: 'ㅎ + ㄷ → [ㅌ]',
    koreanExplanation: '받침 ㅎ과 뒤의 ㄷ이 합쳐져 거센소리 [ㅌ]으로 발음됩니다.',
    vietnameseExplanation:
        'ㅎ cuối kết hợp với ㄷ phía sau và được phát âm thành âm bật hơi [ㅌ].',
  ),
  HangulHChangeExample(
    writtenForm: '쌓지',
    pronunciation: '싸치',
    beforePart: '쌓',
    afterPart: '지',
    rule: 'ㅎ + ㅈ → [ㅊ]',
    koreanExplanation: '받침 ㅎ과 뒤의 ㅈ이 합쳐져 거센소리 [ㅊ]으로 발음됩니다.',
    vietnameseExplanation:
        'ㅎ cuối kết hợp với ㅈ phía sau và được phát âm thành âm bật hơi [ㅊ].',
  ),
  HangulHChangeExample(
    writtenForm: '먹히다',
    pronunciation: '머키다',
    beforePart: '먹',
    afterPart: '히다',
    rule: 'ㄱ + ㅎ → [ㅋ]',
    koreanExplanation: '받침 ㄱ과 뒤의 ㅎ이 합쳐져 거센소리 [ㅋ]으로 발음됩니다.',
    vietnameseExplanation:
        'ㄱ cuối kết hợp với ㅎ phía sau và được phát âm thành âm bật hơi [ㅋ].',
  ),
  HangulHChangeExample(
    writtenForm: '좁히다',
    pronunciation: '조피다',
    beforePart: '좁',
    afterPart: '히다',
    rule: 'ㅂ + ㅎ → [ㅍ]',
    koreanExplanation: '받침 ㅂ과 뒤의 ㅎ이 합쳐져 거센소리 [ㅍ]으로 발음됩니다.',
    vietnameseExplanation:
        'ㅂ cuối kết hợp với ㅎ phía sau và được phát âm thành âm bật hơi [ㅍ].',
  ),
  HangulHChangeExample(
    writtenForm: '꽂히다',
    pronunciation: '꼬치다',
    beforePart: '꽂',
    afterPart: '히다',
    rule: 'ㅈ + ㅎ → [ㅊ]',
    koreanExplanation: '받침 ㅈ과 뒤의 ㅎ이 합쳐져 거센소리 [ㅊ]으로 발음됩니다.',
    vietnameseExplanation:
        'ㅈ cuối kết hợp với ㅎ phía sau và được phát âm thành âm bật hơi [ㅊ].',
  ),
  HangulHChangeExample(
    writtenForm: '놓아',
    pronunciation: '노아',
    beforePart: '놓',
    afterPart: '아',
    rule: 'ㅎ + 모음 → ㅎ 탈락',
    koreanExplanation: '받침 ㅎ 뒤에 모음으로 시작하는 어미가 와서 ㅎ이 발음되지 않습니다.',
    vietnameseExplanation:
        'Khi đuôi bắt đầu bằng nguyên âm theo sau, ㅎ cuối không được phát âm.',
  ),
  HangulHChangeExample(
    writtenForm: '많아',
    pronunciation: '마ː나',
    beforePart: '많',
    afterPart: '아',
    rule: 'ㄶ + 모음 → ㅎ 탈락',
    koreanExplanation: '겹받침 ㄶ 뒤에 모음으로 시작하는 어미가 와서 ㅎ은 탈락하고 ㄴ은 이어집니다.',
    vietnameseExplanation:
        'Khi đuôi bắt đầu bằng nguyên âm theo sau ㄶ, ㅎ mất đi còn ㄴ được nối sang.',
  ),
];
