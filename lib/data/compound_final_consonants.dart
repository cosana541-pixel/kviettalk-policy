import '../models/hangul_letter.dart';

class CompoundFinalConsonantLearningItem extends HangulLetter {
  const CompoundFinalConsonantLearningItem({
    required super.character,
    required super.name,
    required super.pronunciationGuide,
    required super.examples,
    required this.pronunciation,
    required this.ttsText,
    required this.koreanExplanation,
    required this.vietnameseExplanation,
  });

  final String pronunciation;
  final String ttsText;
  final String koreanExplanation;
  final String vietnameseExplanation;
}

const compoundFinalConsonantSoundGroups = <String, String>{
  'ㄳ': 'ㄱ',
  'ㄵ': 'ㄴ',
  'ㄶ': 'ㄴ',
  'ㄺ': 'ㄱ',
  'ㄻ': 'ㅁ',
  'ㄼ': 'ㄹ',
  'ㄽ': 'ㄹ',
  'ㄾ': 'ㄹ',
  'ㄿ': 'ㅂ',
  'ㅀ': 'ㄹ',
  'ㅄ': 'ㅂ',
};

const compoundFinalConsonants = <CompoundFinalConsonantLearningItem>[
  CompoundFinalConsonantLearningItem(
    character: 'ㄳ',
    name: '넋',
    pronunciation: '넉',
    ttsText: '넉',
    pronunciationGuide: 'Ở cuối từ, ㄳ được đọc bằng âm cuối [ㄱ].',
    koreanExplanation: '겹받침 ㄳ은 단어 끝에서 [ㄱ]으로 발음해요.',
    vietnameseExplanation: 'Ở cuối từ, 받침 kép ㄳ được đọc bằng âm cuối [ㄱ].',
    examples: ['넋'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㄵ',
    name: '앉다',
    pronunciation: '안따',
    ttsText: '안따',
    pronunciationGuide: 'ㄵ để lại âm cuối [ㄴ]; âm sau nghe căng hơn.',
    koreanExplanation: 'ㄵ의 기본 받침 소리는 [ㄴ]이에요. 뒤의 소리가 세지는 자세한 과정은 중급에서 배워요.',
    vietnameseExplanation:
        'Âm cuối cơ bản của ㄵ là [ㄴ]. Quá trình làm âm sau căng hơn sẽ học ở trình độ trung cấp.',
    examples: ['앉다'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㄶ',
    name: '많다',
    pronunciation: '만타',
    ttsText: '만타',
    pronunciationGuide: 'ㄶ để lại [ㄴ]; ㅎ làm âm ㄷ phía sau thành [ㅌ].',
    koreanExplanation: 'ㄶ의 기본 받침 소리는 [ㄴ]이에요. ㅎ 때문에 뒤의 ㄷ은 [ㅌ]으로 들려요.',
    vietnameseExplanation:
        'Âm cuối cơ bản của ㄶ là [ㄴ]. Do ㅎ, ㄷ phía sau được nghe thành [ㅌ].',
    examples: ['많다'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㄺ',
    name: '닭',
    pronunciation: '닥',
    ttsText: '닥',
    pronunciationGuide: 'Ở cuối từ, ㄺ thường được đọc bằng âm cuối [ㄱ].',
    koreanExplanation: '겹받침 ㄺ은 단어 끝에서 보통 [ㄱ]으로 발음해요.',
    vietnameseExplanation:
        'Ở cuối từ, 받침 kép ㄺ thường được đọc bằng âm cuối [ㄱ].',
    examples: ['닭'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㄻ',
    name: '삶',
    pronunciation: '삼ː',
    ttsText: '삼',
    pronunciationGuide: 'Ở cuối từ, ㄻ được đọc bằng âm cuối [ㅁ].',
    koreanExplanation: '겹받침 ㄻ은 단어 끝에서 [ㅁ]으로 발음해요. ː는 긴소리 표시예요.',
    vietnameseExplanation:
        'Ở cuối từ, 받침 kép ㄻ được đọc bằng âm cuối [ㅁ]. Dấu ː chỉ âm dài.',
    examples: ['삶'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㄼ',
    name: '여덟',
    pronunciation: '여덜',
    ttsText: '여덜',
    pronunciationGuide: 'Trong 여덟, ㄼ được đọc bằng âm cuối [ㄹ].',
    koreanExplanation: '여덟의 겹받침 ㄼ은 [ㄹ]로 발음해요.',
    vietnameseExplanation: 'Trong từ 여덟, 받침 kép ㄼ được đọc bằng âm cuối [ㄹ].',
    examples: ['여덟'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㄽ',
    name: '외곬',
    pronunciation: '외골',
    ttsText: '외골',
    pronunciationGuide: 'Ở cuối từ, ㄽ được đọc bằng âm cuối [ㄹ].',
    koreanExplanation: '겹받침 ㄽ은 단어 끝에서 [ㄹ]로 발음해요.',
    vietnameseExplanation: 'Ở cuối từ, 받침 kép ㄽ được đọc bằng âm cuối [ㄹ].',
    examples: ['외곬'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㄾ',
    name: '핥다',
    pronunciation: '할따',
    ttsText: '할따',
    pronunciationGuide: 'ㄾ để lại âm cuối [ㄹ]; âm sau nghe căng hơn.',
    koreanExplanation: 'ㄾ의 기본 받침 소리는 [ㄹ]이에요. 뒤의 소리가 세지는 자세한 과정은 중급에서 배워요.',
    vietnameseExplanation:
        'Âm cuối cơ bản của ㄾ là [ㄹ]. Quá trình làm âm sau căng hơn sẽ học ở trình độ trung cấp.',
    examples: ['핥다'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㄿ',
    name: '읊다',
    pronunciation: '읍따',
    ttsText: '읍따',
    pronunciationGuide: 'ㄿ để lại âm cuối [ㅂ]; âm sau nghe căng hơn.',
    koreanExplanation: 'ㄿ의 기본 받침 소리는 [ㅂ]이에요. 뒤의 소리가 세지는 자세한 과정은 중급에서 배워요.',
    vietnameseExplanation:
        'Âm cuối cơ bản của ㄿ là [ㅂ]. Quá trình làm âm sau căng hơn sẽ học ở trình độ trung cấp.',
    examples: ['읊다'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㅀ',
    name: '싫다',
    pronunciation: '실타',
    ttsText: '실타',
    pronunciationGuide: 'ㅀ để lại [ㄹ]; ㅎ làm âm ㄷ phía sau thành [ㅌ].',
    koreanExplanation: 'ㅀ의 기본 받침 소리는 [ㄹ]이에요. ㅎ 때문에 뒤의 ㄷ은 [ㅌ]으로 들려요.',
    vietnameseExplanation:
        'Âm cuối cơ bản của ㅀ là [ㄹ]. Do ㅎ, ㄷ phía sau được nghe thành [ㅌ].',
    examples: ['싫다'],
  ),
  CompoundFinalConsonantLearningItem(
    character: 'ㅄ',
    name: '값',
    pronunciation: '갑',
    ttsText: '갑',
    pronunciationGuide: 'Ở cuối từ, ㅄ được đọc bằng âm cuối [ㅂ].',
    koreanExplanation: '겹받침 ㅄ은 단어 끝에서 [ㅂ]으로 발음해요.',
    vietnameseExplanation: 'Ở cuối từ, 받침 kép ㅄ được đọc bằng âm cuối [ㅂ].',
    examples: ['값'],
  ),
];
