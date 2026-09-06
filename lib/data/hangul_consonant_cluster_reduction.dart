class HangulConsonantClusterReductionExample {
  const HangulConsonantClusterReductionExample({
    required this.writtenForm,
    required this.pronunciation,
    required this.cluster,
    required this.remainingFinal,
    required this.rule,
    required this.koreanExplanation,
    required this.vietnameseExplanation,
    this.chainRule,
  });

  final String writtenForm;
  final String pronunciation;
  final String cluster;
  final String remainingFinal;
  final String rule;
  final String koreanExplanation;
  final String vietnameseExplanation;
  final String? chainRule;

  bool get hasChainRule => chainRule != null;
}

const hangulConsonantClusterReductionExamples = <HangulConsonantClusterReductionExample>[
  HangulConsonantClusterReductionExample(
    writtenForm: '넋',
    pronunciation: '넉',
    cluster: 'ㄳ',
    remainingFinal: 'ㄱ',
    rule: 'ㄳ → [ㄱ]',
    koreanExplanation: '음절 끝의 겹받침 ㄳ은 표준 발음 [ㄱ]으로 소리 납니다.',
    vietnameseExplanation:
        'Ở cuối âm tiết, 받침 kép ㄳ được phát âm chuẩn thành [ㄱ].',
  ),
  HangulConsonantClusterReductionExample(
    writtenForm: '앉다',
    pronunciation: '안따',
    cluster: 'ㄵ',
    remainingFinal: 'ㄴ',
    rule: 'ㄵ → [ㄴ]: 앉다 → 안다',
    chainRule: '된소리되기: 안다 → 안따',
    koreanExplanation:
        '먼저 겹받침 ㄵ이 [ㄴ]으로 단순화됩니다. '
        '그런 다음 뒤의 ㄷ이 된소리 [ㄸ]으로 바뀌어 [안따]가 됩니다.',
    vietnameseExplanation:
        'Trước hết ㄵ được giản lược thành [ㄴ]. Sau đó ㄷ được căng hóa thành [ㄸ], tạo ra [안따].',
  ),
  HangulConsonantClusterReductionExample(
    writtenForm: '여덟',
    pronunciation: '여덜',
    cluster: 'ㄼ',
    remainingFinal: 'ㄹ',
    rule: 'ㄼ → [ㄹ]',
    koreanExplanation: '음절 끝의 겹받침 ㄼ은 표준 발음 [ㄹ]로 소리 납니다.',
    vietnameseExplanation:
        'Ở cuối âm tiết, 받침 kép ㄼ được phát âm chuẩn thành [ㄹ].',
  ),
  HangulConsonantClusterReductionExample(
    writtenForm: '핥다',
    pronunciation: '할따',
    cluster: 'ㄾ',
    remainingFinal: 'ㄹ',
    rule: 'ㄾ → [ㄹ]: 핥다 → 할다',
    chainRule: '된소리되기: 할다 → 할따',
    koreanExplanation:
        '먼저 겹받침 ㄾ이 [ㄹ]로 단순화됩니다. '
        '그런 다음 뒤의 ㄷ이 된소리 [ㄸ]으로 바뀌어 [할따]가 됩니다.',
    vietnameseExplanation:
        'Trước hết ㄾ được giản lược thành [ㄹ]. Sau đó ㄷ được căng hóa thành [ㄸ], tạo ra [할따].',
  ),
  HangulConsonantClusterReductionExample(
    writtenForm: '값',
    pronunciation: '갑',
    cluster: 'ㅄ',
    remainingFinal: 'ㅂ',
    rule: 'ㅄ → [ㅂ]',
    koreanExplanation: '음절 끝의 겹받침 ㅄ은 표준 발음 [ㅂ]으로 소리 납니다.',
    vietnameseExplanation:
        'Ở cuối âm tiết, 받침 kép ㅄ được phát âm chuẩn thành [ㅂ].',
  ),
  HangulConsonantClusterReductionExample(
    writtenForm: '닭',
    pronunciation: '닥',
    cluster: 'ㄺ',
    remainingFinal: 'ㄱ',
    rule: 'ㄺ → [ㄱ]',
    koreanExplanation: '음절 끝의 겹받침 ㄺ은 표준 발음 [ㄱ]으로 소리 납니다.',
    vietnameseExplanation:
        'Ở cuối âm tiết, 받침 kép ㄺ được phát âm chuẩn thành [ㄱ].',
  ),
  HangulConsonantClusterReductionExample(
    writtenForm: '삶',
    pronunciation: '삼ː',
    cluster: 'ㄻ',
    remainingFinal: 'ㅁ',
    rule: 'ㄻ → [ㅁ]',
    koreanExplanation:
        '음절 끝의 겹받침 ㄻ은 표준 발음 [ㅁ]으로 소리 납니다. '
        '표준 발음의 장음은 [삼ː]으로 표시합니다.',
    vietnameseExplanation:
        'Ở cuối âm tiết, 받침 kép ㄻ được phát âm chuẩn thành [ㅁ]. Dấu ː biểu thị nguyên âm dài.',
  ),
  HangulConsonantClusterReductionExample(
    writtenForm: '읊다',
    pronunciation: '읍따',
    cluster: 'ㄿ',
    remainingFinal: 'ㅂ',
    rule: 'ㄿ → [ㅂ]: 읊다 → 읍다',
    chainRule: '된소리되기: 읍다 → 읍따',
    koreanExplanation:
        '먼저 겹받침 ㄿ이 [ㅂ]으로 단순화됩니다. '
        '그런 다음 뒤의 ㄷ이 된소리 [ㄸ]으로 바뀌어 [읍따]가 됩니다.',
    vietnameseExplanation:
        'Trước hết ㄿ được giản lược thành [ㅂ]. Sau đó ㄷ được căng hóa thành [ㄸ], tạo ra [읍따].',
  ),
];
