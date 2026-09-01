enum HangulSyllableBuildingStage {
  initialAndVowel,
  simpleFinalConsonant,
  compoundFinalConsonant,
}

class HangulSyllableExample {
  const HangulSyllableExample({
    required this.stage,
    required this.initialConsonant,
    required this.vowel,
    this.finalConsonant,
    required this.syllable,
    required this.explanation,
  });

  final HangulSyllableBuildingStage stage;
  final String initialConsonant;
  final String vowel;
  final String? finalConsonant;
  final String syllable;
  final String explanation;

  String get formula => [
    initialConsonant,
    vowel,
    if (finalConsonant != null) finalConsonant!,
  ].join(' + ');
}

const hangulSyllableBuildingExamples = <HangulSyllableExample>[
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.initialAndVowel,
    initialConsonant: 'ㄱ',
    vowel: 'ㅏ',
    syllable: '가',
    explanation:
        "Âm tiết '가' gồm phụ âm đầu ㄱ và nguyên âm ㅏ. Không có phụ âm cuối.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.initialAndVowel,
    initialConsonant: 'ㄴ',
    vowel: 'ㅓ',
    syllable: '너',
    explanation:
        "Âm tiết '너' gồm phụ âm đầu ㄴ và nguyên âm ㅓ. Không có phụ âm cuối.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.initialAndVowel,
    initialConsonant: 'ㅁ',
    vowel: 'ㅜ',
    syllable: '무',
    explanation:
        "Âm tiết '무' gồm phụ âm đầu ㅁ và nguyên âm ㅜ. Không có phụ âm cuối.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.initialAndVowel,
    initialConsonant: 'ㅅ',
    vowel: 'ㅣ',
    syllable: '시',
    explanation:
        "Âm tiết '시' gồm phụ âm đầu ㅅ và nguyên âm ㅣ. Không có phụ âm cuối.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.simpleFinalConsonant,
    initialConsonant: 'ㄱ',
    vowel: 'ㅏ',
    finalConsonant: 'ㄴ',
    syllable: '간',
    explanation: "Âm tiết '간' gồm phụ âm đầu ㄱ, nguyên âm ㅏ và phụ âm cuối ㄴ.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.simpleFinalConsonant,
    initialConsonant: 'ㅂ',
    vowel: 'ㅏ',
    finalConsonant: 'ㅂ',
    syllable: '밥',
    explanation: "Âm tiết '밥' gồm phụ âm đầu ㅂ, nguyên âm ㅏ và phụ âm cuối ㅂ.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.simpleFinalConsonant,
    initialConsonant: 'ㅎ',
    vowel: 'ㅏ',
    finalConsonant: 'ㄴ',
    syllable: '한',
    explanation: "Âm tiết '한' gồm phụ âm đầu ㅎ, nguyên âm ㅏ và phụ âm cuối ㄴ.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.simpleFinalConsonant,
    initialConsonant: 'ㅁ',
    vowel: 'ㅜ',
    finalConsonant: 'ㄹ',
    syllable: '물',
    explanation: "Âm tiết '물' gồm phụ âm đầu ㅁ, nguyên âm ㅜ và phụ âm cuối ㄹ.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.compoundFinalConsonant,
    initialConsonant: 'ㄷ',
    vowel: 'ㅏ',
    finalConsonant: 'ㄺ',
    syllable: '닭',
    explanation:
        "Âm tiết '닭' gồm phụ âm đầu ㄷ, nguyên âm ㅏ và phụ âm cuối kép ㄺ.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.compoundFinalConsonant,
    initialConsonant: 'ㄱ',
    vowel: 'ㅏ',
    finalConsonant: 'ㅄ',
    syllable: '값',
    explanation:
        "Âm tiết '값' gồm phụ âm đầu ㄱ, nguyên âm ㅏ và phụ âm cuối kép ㅄ.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.compoundFinalConsonant,
    initialConsonant: 'ㅅ',
    vowel: 'ㅏ',
    finalConsonant: 'ㄻ',
    syllable: '삶',
    explanation:
        "Âm tiết '삶' gồm phụ âm đầu ㅅ, nguyên âm ㅏ và phụ âm cuối kép ㄻ.",
  ),
  HangulSyllableExample(
    stage: HangulSyllableBuildingStage.compoundFinalConsonant,
    initialConsonant: 'ㅁ',
    vowel: 'ㅗ',
    finalConsonant: 'ㄳ',
    syllable: '몫',
    explanation:
        "Âm tiết '몫' gồm phụ âm đầu ㅁ, nguyên âm ㅗ và phụ âm cuối kép ㄳ.",
  ),
];
