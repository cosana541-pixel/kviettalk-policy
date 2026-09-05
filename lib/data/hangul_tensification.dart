class HangulTensificationExample {
  const HangulTensificationExample({
    required this.writtenForm,
    required this.pronunciation,
    required this.beforePart,
    required this.afterPart,
    required this.finalConsonant,
    required this.tenseConsonant,
    required this.koreanExplanation,
    required this.vietnameseExplanation,
  });

  final String writtenForm;
  final String pronunciation;
  final String beforePart;
  final String afterPart;
  final String finalConsonant;
  final String tenseConsonant;
  final String koreanExplanation;
  final String vietnameseExplanation;

  String get writtenStructure => '$beforePart + $afterPart';
}

const hangulTensificationExamples = <HangulTensificationExample>[
  HangulTensificationExample(
    writtenForm: '학교',
    pronunciation: '학꾜',
    beforePart: '학',
    afterPart: '교',
    finalConsonant: 'ㄱ',
    tenseConsonant: 'ㄲ',
    koreanExplanation: '받침 ㄱ 뒤의 ㄱ이 된소리 [ㄲ]로 발음됩니다.',
    vietnameseExplanation: 'Sau 받침 ㄱ, phụ âm ㄱ được phát âm căng thành [ㄲ].',
  ),
  HangulTensificationExample(
    writtenForm: '국밥',
    pronunciation: '국빱',
    beforePart: '국',
    afterPart: '밥',
    finalConsonant: 'ㄱ',
    tenseConsonant: 'ㅃ',
    koreanExplanation: '받침 ㄱ 뒤의 ㅂ이 된소리 [ㅃ]로 발음됩니다.',
    vietnameseExplanation: 'Sau 받침 ㄱ, phụ âm ㅂ được phát âm căng thành [ㅃ].',
  ),
  HangulTensificationExample(
    writtenForm: '책상',
    pronunciation: '책쌍',
    beforePart: '책',
    afterPart: '상',
    finalConsonant: 'ㄱ',
    tenseConsonant: 'ㅆ',
    koreanExplanation: '받침 ㄱ 뒤의 ㅅ이 된소리 [ㅆ]로 발음됩니다.',
    vietnameseExplanation: 'Sau 받침 ㄱ, phụ âm ㅅ được phát âm căng thành [ㅆ].',
  ),
  HangulTensificationExample(
    writtenForm: '식당',
    pronunciation: '식땅',
    beforePart: '식',
    afterPart: '당',
    finalConsonant: 'ㄱ',
    tenseConsonant: 'ㄸ',
    koreanExplanation: '받침 ㄱ 뒤의 ㄷ이 된소리 [ㄸ]로 발음됩니다.',
    vietnameseExplanation: 'Sau 받침 ㄱ, phụ âm ㄷ được phát âm căng thành [ㄸ].',
  ),
  HangulTensificationExample(
    writtenForm: '옷감',
    pronunciation: '옫깜',
    beforePart: '옷',
    afterPart: '감',
    finalConsonant: 'ㅅ([ㄷ])',
    tenseConsonant: 'ㄲ',
    koreanExplanation: '옷의 받침 ㅅ은 [ㄷ]으로 소리 나고, 뒤의 ㄱ은 [ㄲ]가 됩니다.',
    vietnameseExplanation:
        '받침 ㅅ của 옷 được đọc là [ㄷ], rồi ㄱ phía sau căng thành [ㄲ].',
  ),
  HangulTensificationExample(
    writtenForm: '입구',
    pronunciation: '입꾸',
    beforePart: '입',
    afterPart: '구',
    finalConsonant: 'ㅂ',
    tenseConsonant: 'ㄲ',
    koreanExplanation: '받침 ㅂ 뒤의 ㄱ이 된소리 [ㄲ]로 발음됩니다.',
    vietnameseExplanation: 'Sau 받침 ㅂ, phụ âm ㄱ được phát âm căng thành [ㄲ].',
  ),
  HangulTensificationExample(
    writtenForm: '잡지',
    pronunciation: '잡찌',
    beforePart: '잡',
    afterPart: '지',
    finalConsonant: 'ㅂ',
    tenseConsonant: 'ㅉ',
    koreanExplanation: '받침 ㅂ 뒤의 ㅈ이 된소리 [ㅉ]로 발음됩니다.',
    vietnameseExplanation: 'Sau 받침 ㅂ, phụ âm ㅈ được phát âm căng thành [ㅉ].',
  ),
  HangulTensificationExample(
    writtenForm: '꽃병',
    pronunciation: '꼳뼝',
    beforePart: '꽃',
    afterPart: '병',
    finalConsonant: 'ㅊ([ㄷ])',
    tenseConsonant: 'ㅃ',
    koreanExplanation: '꽃의 받침 ㅊ은 [ㄷ]으로 소리 나고, 뒤의 ㅂ은 [ㅃ]이 됩니다.',
    vietnameseExplanation:
        '받침 ㅊ của 꽃 được đọc là [ㄷ], rồi ㅂ phía sau căng thành [ㅃ].',
  ),
];
