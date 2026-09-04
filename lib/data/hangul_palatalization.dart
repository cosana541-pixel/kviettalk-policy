class HangulPalatalizationExample {
  const HangulPalatalizationExample({
    required this.writtenForm,
    required this.pronunciation,
    required this.beforePart,
    required this.afterPart,
    required this.finalConsonant,
    required this.koreanExplanation,
    required this.vietnameseExplanation,
  });

  final String writtenForm;
  final String pronunciation;
  final String beforePart;
  final String afterPart;
  final String finalConsonant;
  final String koreanExplanation;
  final String vietnameseExplanation;

  String get writtenStructure => '$beforePart + $afterPart';
}

const hangulPalatalizationExamples = <HangulPalatalizationExample>[
  HangulPalatalizationExample(
    writtenForm: '굳이',
    pronunciation: '구지',
    beforePart: '굳',
    afterPart: '이',
    finalConsonant: 'ㄷ',
    koreanExplanation: '받침 ㄷ이 접미사 이와 만나 [ㅈ]으로 바뀌어 이어집니다.',
    vietnameseExplanation:
        '받침 ㄷ gặp hậu tố 이, đổi thành [ㅈ] rồi chuyển sang âm tiết sau.',
  ),
  HangulPalatalizationExample(
    writtenForm: '같이',
    pronunciation: '가치',
    beforePart: '같',
    afterPart: '이',
    finalConsonant: 'ㅌ',
    koreanExplanation: '받침 ㅌ이 접미사 이와 만나 [ㅊ]으로 바뀌어 이어집니다.',
    vietnameseExplanation:
        '받침 ㅌ gặp hậu tố 이, đổi thành [ㅊ] rồi chuyển sang âm tiết sau.',
  ),
  HangulPalatalizationExample(
    writtenForm: '밭이',
    pronunciation: '바치',
    beforePart: '밭',
    afterPart: '이',
    finalConsonant: 'ㅌ',
    koreanExplanation: '받침 ㅌ이 조사 이와 만나 [ㅊ]으로 바뀌어 이어집니다.',
    vietnameseExplanation:
        '받침 ㅌ gặp trợ từ 이, đổi thành [ㅊ] rồi chuyển sang âm tiết sau.',
  ),
  HangulPalatalizationExample(
    writtenForm: '해돋이',
    pronunciation: '해도지',
    beforePart: '해돋',
    afterPart: '이',
    finalConsonant: 'ㄷ',
    koreanExplanation: '돋의 받침 ㄷ이 접미사 이 앞에서 [ㅈ]으로 바뀝니다.',
    vietnameseExplanation:
        '받침 ㄷ của 돋 đổi thành [ㅈ] trước hậu tố 이: 해돋이 → [해도지].',
  ),
  HangulPalatalizationExample(
    writtenForm: '미닫이',
    pronunciation: '미다지',
    beforePart: '미닫',
    afterPart: '이',
    finalConsonant: 'ㄷ',
    koreanExplanation: '닫의 받침 ㄷ이 접미사 이 앞에서 [ㅈ]으로 바뀝니다.',
    vietnameseExplanation:
        '받침 ㄷ của 닫 đổi thành [ㅈ] trước hậu tố 이: 미닫이 → [미다지].',
  ),
  HangulPalatalizationExample(
    writtenForm: '맏이',
    pronunciation: '마지',
    beforePart: '맏',
    afterPart: '이',
    finalConsonant: 'ㄷ',
    koreanExplanation: '받침 ㄷ이 접미사 이와 만나 [ㅈ]으로 바뀌어 이어집니다.',
    vietnameseExplanation:
        '받침 ㄷ gặp hậu tố 이, đổi thành [ㅈ]: 맏이 được phát âm là [마지].',
  ),
  HangulPalatalizationExample(
    writtenForm: '끝이',
    pronunciation: '끄치',
    beforePart: '끝',
    afterPart: '이',
    finalConsonant: 'ㅌ',
    koreanExplanation: '받침 ㅌ이 조사 이와 만나 [ㅊ]으로 바뀌어 이어집니다.',
    vietnameseExplanation:
        '받침 ㅌ gặp trợ từ 이, đổi thành [ㅊ]: 끝이 được phát âm là [끄치].',
  ),
  HangulPalatalizationExample(
    writtenForm: '붙이다',
    pronunciation: '부치다',
    beforePart: '붙',
    afterPart: '이다',
    finalConsonant: 'ㅌ',
    koreanExplanation: '받침 ㅌ이 접미사 이와 만나 [ㅊ]으로 바뀌어 이어집니다.',
    vietnameseExplanation:
        '받침 ㅌ gặp hậu tố 이, đổi thành [ㅊ]: 붙이다 được phát âm là [부치다].',
  ),
];
