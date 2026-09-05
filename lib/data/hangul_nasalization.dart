class HangulNasalizationExample {
  const HangulNasalizationExample({
    required this.writtenForm,
    required this.pronunciation,
    required this.beforePart,
    required this.afterPart,
    required this.finalConsonantFamily,
    required this.nasalConsonant,
    required this.koreanExplanation,
    required this.vietnameseExplanation,
  });

  final String writtenForm;
  final String pronunciation;
  final String beforePart;
  final String afterPart;
  final String finalConsonantFamily;
  final String nasalConsonant;
  final String koreanExplanation;
  final String vietnameseExplanation;

  String get writtenStructure => '$beforePart + $afterPart';
}

const hangulNasalizationExamples = <HangulNasalizationExample>[
  HangulNasalizationExample(
    writtenForm: '국물',
    pronunciation: '궁물',
    beforePart: '국',
    afterPart: '물',
    finalConsonantFamily: 'ㄱ',
    nasalConsonant: 'ㅇ',
    koreanExplanation: '받침 ㄱ이 뒤의 비음 ㅁ을 만나 [ㅇ]으로 바뀝니다.',
    vietnameseExplanation: '받침 ㄱ gặp phụ âm mũi ㅁ phía sau và đổi thành [ㅇ].',
  ),
  HangulNasalizationExample(
    writtenForm: '먹는',
    pronunciation: '멍는',
    beforePart: '먹',
    afterPart: '는',
    finalConsonantFamily: 'ㄱ',
    nasalConsonant: 'ㅇ',
    koreanExplanation: '받침 ㄱ이 뒤의 비음 ㄴ을 만나 [ㅇ]으로 바뀝니다.',
    vietnameseExplanation: '받침 ㄱ gặp phụ âm mũi ㄴ phía sau và đổi thành [ㅇ].',
  ),
  HangulNasalizationExample(
    writtenForm: '닫는',
    pronunciation: '단는',
    beforePart: '닫',
    afterPart: '는',
    finalConsonantFamily: 'ㄷ',
    nasalConsonant: 'ㄴ',
    koreanExplanation: '받침 ㄷ이 뒤의 비음 ㄴ을 만나 [ㄴ]으로 바뀝니다.',
    vietnameseExplanation: '받침 ㄷ gặp phụ âm mũi ㄴ phía sau và đổi thành [ㄴ].',
  ),
  HangulNasalizationExample(
    writtenForm: '있는',
    pronunciation: '인는',
    beforePart: '있',
    afterPart: '는',
    finalConsonantFamily: 'ㅆ([ㄷ])',
    nasalConsonant: 'ㄴ',
    koreanExplanation: '받침 ㅆ은 [ㄷ] 계열 소리이고, ㄴ 앞에서 [ㄴ]으로 바뀝니다.',
    vietnameseExplanation: '받침 ㅆ thuộc nhóm âm [ㄷ] và đổi thành [ㄴ] trước ㄴ.',
  ),
  HangulNasalizationExample(
    writtenForm: '앞문',
    pronunciation: '암문',
    beforePart: '앞',
    afterPart: '문',
    finalConsonantFamily: 'ㅍ([ㅂ])',
    nasalConsonant: 'ㅁ',
    koreanExplanation: '받침 ㅍ은 [ㅂ] 계열 소리이고, ㅁ 앞에서 [ㅁ]으로 바뀝니다.',
    vietnameseExplanation: '받침 ㅍ thuộc nhóm âm [ㅂ] và đổi thành [ㅁ] trước ㅁ.',
  ),
  HangulNasalizationExample(
    writtenForm: '밥물',
    pronunciation: '밤물',
    beforePart: '밥',
    afterPart: '물',
    finalConsonantFamily: 'ㅂ',
    nasalConsonant: 'ㅁ',
    koreanExplanation: '받침 ㅂ이 뒤의 비음 ㅁ을 만나 [ㅁ]으로 바뀝니다.',
    vietnameseExplanation: '받침 ㅂ gặp phụ âm mũi ㅁ phía sau và đổi thành [ㅁ].',
  ),
  HangulNasalizationExample(
    writtenForm: '꽃망울',
    pronunciation: '꼰망울',
    beforePart: '꽃',
    afterPart: '망울',
    finalConsonantFamily: 'ㅊ([ㄷ])',
    nasalConsonant: 'ㄴ',
    koreanExplanation: '받침 ㅊ은 [ㄷ] 계열 소리이고, ㅁ 앞에서 [ㄴ]으로 바뀝니다.',
    vietnameseExplanation: '받침 ㅊ thuộc nhóm âm [ㄷ] và đổi thành [ㄴ] trước ㅁ.',
  ),
  HangulNasalizationExample(
    writtenForm: '잡는',
    pronunciation: '잠는',
    beforePart: '잡',
    afterPart: '는',
    finalConsonantFamily: 'ㅂ',
    nasalConsonant: 'ㅁ',
    koreanExplanation: '받침 ㅂ이 뒤의 비음 ㄴ을 만나 [ㅁ]으로 바뀝니다.',
    vietnameseExplanation: '받침 ㅂ gặp phụ âm mũi ㄴ phía sau và đổi thành [ㅁ].',
  ),
];
