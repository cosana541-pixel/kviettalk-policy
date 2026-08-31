import '../models/hangul_letter.dart';

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

const compoundFinalConsonants = <HangulLetter>[
  HangulLetter(
    character: 'ㄳ',
    name: '넋',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㄳ có âm cuối đại diện [ㄱ]; phần ㅅ không phát âm riêng.',
    examples: ['넋', '몫'],
  ),
  HangulLetter(
    character: 'ㄵ',
    name: '앉',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㄵ có âm cuối đại diện [ㄴ]; phần ㅈ không phát âm riêng.',
    examples: ['앉다', '얹다'],
  ),
  HangulLetter(
    character: 'ㄶ',
    name: '많',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㄶ có âm cuối đại diện [ㄴ]; phần ㅎ không phát âm riêng.',
    examples: ['많다', '않다'],
  ),
  HangulLetter(
    character: 'ㄺ',
    name: '닭',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㄺ thường có âm cuối đại diện [ㄱ]; phần ㄹ không phát âm riêng.',
    examples: ['닭', '흙'],
  ),
  HangulLetter(
    character: 'ㄻ',
    name: '삶',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㄻ có âm cuối đại diện [ㅁ]; phần ㄹ không phát âm riêng.',
    examples: ['삶', '젊다'],
  ),
  HangulLetter(
    character: 'ㄼ',
    name: '여덟',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㄼ thường có âm cuối đại diện [ㄹ]; một số từ có cách đọc ngoại lệ.',
    examples: ['여덟', '넓다'],
  ),
  HangulLetter(
    character: 'ㄽ',
    name: '곬',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㄽ có âm cuối đại diện [ㄹ]; phần ㅅ không phát âm riêng.',
    examples: ['곬', '외곬'],
  ),
  HangulLetter(
    character: 'ㄾ',
    name: '핥',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㄾ có âm cuối đại diện [ㄹ]; phần ㅌ không phát âm riêng.',
    examples: ['핥다'],
  ),
  HangulLetter(
    character: 'ㄿ',
    name: '읊',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㄿ có âm cuối đại diện [ㅂ]; phần ㄹ không phát âm riêng.',
    examples: ['읊다'],
  ),
  HangulLetter(
    character: 'ㅀ',
    name: '싫',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㅀ có âm cuối đại diện [ㄹ]; phần ㅎ không phát âm riêng.',
    examples: ['싫다', '옳다'],
  ),
  HangulLetter(
    character: 'ㅄ',
    name: '값',
    pronunciationGuide:
        'Khi đứng ở cuối âm tiết, ㅄ có âm cuối đại diện [ㅂ]; phần ㅅ không phát âm riêng.',
    examples: ['값', '없다'],
  ),
];
