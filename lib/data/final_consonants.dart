import '../models/hangul_letter.dart';

const finalConsonantSoundGroups = <String, String>{
  'ㄱ': 'ㄱ',
  'ㄲ': 'ㄱ',
  'ㄴ': 'ㄴ',
  'ㄷ': 'ㄷ',
  'ㄹ': 'ㄹ',
  'ㅁ': 'ㅁ',
  'ㅂ': 'ㅂ',
  'ㅅ': 'ㄷ',
  'ㅆ': 'ㄷ',
  'ㅇ': 'ㅇ',
  'ㅈ': 'ㄷ',
  'ㅊ': 'ㄷ',
  'ㅋ': 'ㄱ',
  'ㅌ': 'ㄷ',
  'ㅍ': 'ㅂ',
  'ㅎ': 'ㄷ',
};

const finalConsonants = <HangulLetter>[
  HangulLetter(
    character: 'ㄱ',
    name: '각',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄱ, ㄲ, ㅋ cùng có âm cuối [ㄱ], dừng ngắn ở cuối.',
    examples: ['각', '국'],
  ),
  HangulLetter(
    character: 'ㄲ',
    name: '밖',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄱ, ㄲ, ㅋ cùng có âm cuối [ㄱ], dừng ngắn ở cuối.',
    examples: ['밖', '닦다'],
  ),
  HangulLetter(
    character: 'ㄴ',
    name: '간',
    pronunciationGuide:
        'Nằm dưới âm tiết và có âm cuối [ㄴ], gần với âm n trong tiếng Việt.',
    examples: ['산', '문'],
  ),
  HangulLetter(
    character: 'ㄷ',
    name: '곧',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄷ, ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅎ cùng có âm cuối [ㄷ], dừng ngắn ở cuối.',
    examples: ['곧', '믿다'],
  ),
  HangulLetter(
    character: 'ㄹ',
    name: '갈',
    pronunciationGuide:
        'Nằm dưới âm tiết và có âm cuối [ㄹ], đầu lưỡi chạm nhẹ phía trên.',
    examples: ['달', '길'],
  ),
  HangulLetter(
    character: 'ㅁ',
    name: '감',
    pronunciationGuide:
        'Nằm dưới âm tiết và có âm cuối [ㅁ], gần với âm m trong tiếng Việt.',
    examples: ['감', '밤'],
  ),
  HangulLetter(
    character: 'ㅂ',
    name: '갑',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㅂ, ㅍ cùng có âm cuối [ㅂ], khép môi và dừng ngắn.',
    examples: ['갑', '밥'],
  ),
  HangulLetter(
    character: 'ㅅ',
    name: '갓',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄷ, ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅎ cùng có âm cuối [ㄷ], dừng ngắn ở cuối.',
    examples: ['갓', '옷'],
  ),
  HangulLetter(
    character: 'ㅆ',
    name: '갔',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄷ, ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅎ cùng có âm cuối [ㄷ], dừng ngắn ở cuối.',
    examples: ['갔다', '있다'],
  ),
  HangulLetter(
    character: 'ㅇ',
    name: '강',
    pronunciationGuide:
        'Nằm dưới âm tiết và có âm cuối [ㅇ], gần với âm ng trong tiếng Việt.',
    examples: ['강', '공'],
  ),
  HangulLetter(
    character: 'ㅈ',
    name: '낮',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄷ, ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅎ cùng có âm cuối [ㄷ], dừng ngắn ở cuối.',
    examples: ['낮', '빚'],
  ),
  HangulLetter(
    character: 'ㅊ',
    name: '빛',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄷ, ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅎ cùng có âm cuối [ㄷ], dừng ngắn ở cuối.',
    examples: ['빛', '꽃'],
  ),
  HangulLetter(
    character: 'ㅋ',
    name: '부엌',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄱ, ㄲ, ㅋ cùng có âm cuối [ㄱ], dừng ngắn ở cuối.',
    examples: ['부엌'],
  ),
  HangulLetter(
    character: 'ㅌ',
    name: '밭',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄷ, ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅎ cùng có âm cuối [ㄷ], dừng ngắn ở cuối.',
    examples: ['밭', '끝'],
  ),
  HangulLetter(
    character: 'ㅍ',
    name: '앞',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㅂ, ㅍ cùng có âm cuối [ㅂ], khép môi và dừng ngắn.',
    examples: ['앞', '숲'],
  ),
  HangulLetter(
    character: 'ㅎ',
    name: '좋',
    pronunciationGuide:
        'Nằm dưới âm tiết. Ở 받침, ㄷ, ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅎ cùng được xếp vào âm cuối đại diện [ㄷ].',
    examples: ['좋'],
  ),
];
