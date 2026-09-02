class HangulLiaisonExample {
  const HangulLiaisonExample({
    required this.writtenForm,
    required this.pronunciation,
    required this.beforePart,
    required this.afterPart,
    required this.finalConsonant,
    required this.explanation,
    this.note,
  });

  final String writtenForm;
  final String pronunciation;
  final String beforePart;
  final String afterPart;
  final String finalConsonant;
  final String explanation;
  final String? note;

  String get writtenStructure => '$beforePart + $afterPart';
}

const hangulLiaisonExamples = <HangulLiaisonExample>[
  HangulLiaisonExample(
    writtenForm: '먹어요',
    pronunciation: '머거요',
    beforePart: '먹',
    afterPart: '어요',
    finalConsonant: 'ㄱ',
    explanation:
        '받침 ㄱ được nối sang trước nguyên âm ㅓ của âm tiết sau, vì vậy 먹어요 được đọc gần như [머거요].',
  ),
  HangulLiaisonExample(
    writtenForm: '문을',
    pronunciation: '무늘',
    beforePart: '문',
    afterPart: '을',
    finalConsonant: 'ㄴ',
    explanation:
        '받침 ㄴ chuyển sang đầu âm tiết 을 và giữ nguyên âm ㄴ: 문을 → [무늘].',
  ),
  HangulLiaisonExample(
    writtenForm: '닫아요',
    pronunciation: '다다요',
    beforePart: '닫',
    afterPart: '아요',
    finalConsonant: 'ㄷ',
    explanation:
        '받침 ㄷ được nối sang trước nguyên âm ㅏ, nên 닫아요 được phát âm là [다다요].',
  ),
  HangulLiaisonExample(
    writtenForm: '달이',
    pronunciation: '다리',
    beforePart: '달',
    afterPart: '이',
    finalConsonant: 'ㄹ',
    explanation:
        '받침 ㄹ được nối sang âm tiết 이 và trở thành âm đầu của 리: 달이 → [다리].',
  ),
  HangulLiaisonExample(
    writtenForm: '밤에',
    pronunciation: '바메',
    beforePart: '밤',
    afterPart: '에',
    finalConsonant: 'ㅁ',
    explanation:
        '받침 ㅁ được nối sang trước nguyên âm ㅔ, vì vậy 밤에 được đọc là [바메].',
  ),
  HangulLiaisonExample(
    writtenForm: '집에',
    pronunciation: '지베',
    beforePart: '집',
    afterPart: '에',
    finalConsonant: 'ㅂ',
    explanation:
        '받침 ㅂ được nối sang âm tiết 에 và phát âm bằng đúng âm ㅂ: 집에 → [지베].',
  ),
  HangulLiaisonExample(
    writtenForm: '옷이',
    pronunciation: '오시',
    beforePart: '옷',
    afterPart: '이',
    finalConsonant: 'ㅅ',
    explanation:
        '받침 ㅅ được nối sang âm tiết 이 và trở thành âm đầu của 시: 옷이 → [오시].',
  ),
  HangulLiaisonExample(
    writtenForm: '낮에',
    pronunciation: '나제',
    beforePart: '낮',
    afterPart: '에',
    finalConsonant: 'ㅈ',
    explanation:
        '받침 ㅈ được nối sang trước nguyên âm ㅔ, nên 낮에 được phát âm là [나제].',
  ),
  HangulLiaisonExample(
    writtenForm: '꽃을',
    pronunciation: '꼬츨',
    beforePart: '꽃',
    afterPart: '을',
    finalConsonant: 'ㅊ',
    explanation: '받침 ㅊ được nối sang âm tiết 을 và giữ nguyên âm ㅊ: 꽃을 → [꼬츨].',
  ),
  HangulLiaisonExample(
    writtenForm: '부엌에',
    pronunciation: '부어케',
    beforePart: '부엌',
    afterPart: '에',
    finalConsonant: 'ㅋ',
    explanation:
        '받침 ㅋ được nối sang trước nguyên âm ㅔ, vì vậy 부엌에 được đọc là [부어케].',
  ),
  HangulLiaisonExample(
    writtenForm: '밭에',
    pronunciation: '바테',
    beforePart: '밭',
    afterPart: '에',
    finalConsonant: 'ㅌ',
    explanation:
        '받침 ㅌ được nối sang trước nguyên âm ㅔ và giữ nguyên âm ㅌ: 밭에 → [바테].',
  ),
  HangulLiaisonExample(
    writtenForm: '앞에',
    pronunciation: '아페',
    beforePart: '앞',
    afterPart: '에',
    finalConsonant: 'ㅍ',
    explanation:
        '받침 ㅍ được nối sang trước nguyên âm ㅔ, nên 앞에 được phát âm là [아페].',
  ),
];
