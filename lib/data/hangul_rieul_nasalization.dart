enum HangulRieulNasalizationRuleType { direct, chained }

class HangulRieulNasalizationExample {
  const HangulRieulNasalizationExample({
    required this.writtenForm,
    required this.pronunciation,
    required this.ttsText,
    required this.changeProcess,
    required this.ruleType,
    required this.koreanExplanation,
    required this.vietnameseExplanation,
  });

  final String writtenForm;
  final String pronunciation;
  final String ttsText;
  final String changeProcess;
  final HangulRieulNasalizationRuleType ruleType;
  final String koreanExplanation;
  final String vietnameseExplanation;
}

const hangulRieulNasalizationExamples = <HangulRieulNasalizationExample>[
  HangulRieulNasalizationExample(
    writtenForm: '음력',
    pronunciation: '음녁',
    ttsText: '음녁',
    changeProcess: '음력 → 음녁 → [음녁]',
    ruleType: HangulRieulNasalizationRuleType.direct,
    koreanExplanation: '받침 ㅁ 뒤의 ㄹ이 비음 [ㄴ]으로 바뀝니다.',
    vietnameseExplanation:
        'Sau 받침 ㅁ, ㄹ đổi thành âm mũi [ㄴ], vì vậy 음력 được đọc là [음녁].',
  ),
  HangulRieulNasalizationExample(
    writtenForm: '침략',
    pronunciation: '침ː냑',
    ttsText: '침냑',
    changeProcess: '침략 → 침냑 → [침ː냑]',
    ruleType: HangulRieulNasalizationRuleType.direct,
    koreanExplanation: '받침 ㅁ 뒤의 ㄹ이 [ㄴ]으로 바뀌며 첫 음절은 길게 발음합니다.',
    vietnameseExplanation:
        'ㄹ sau 받침 ㅁ đổi thành [ㄴ]. Âm tiết đầu được phát âm dài: [침ː냑].',
  ),
  HangulRieulNasalizationExample(
    writtenForm: '대통령',
    pronunciation: '대ː통녕',
    ttsText: '대통녕',
    changeProcess: '대통령 → 대통녕 → [대ː통녕]',
    ruleType: HangulRieulNasalizationRuleType.direct,
    koreanExplanation: '받침 ㅇ 뒤의 ㄹ이 [ㄴ]으로 바뀌며 대는 길게 발음합니다.',
    vietnameseExplanation:
        'ㄹ sau 받침 ㅇ đổi thành [ㄴ]; âm 대 được phát âm dài: [대ː통녕].',
  ),
  HangulRieulNasalizationExample(
    writtenForm: '종로',
    pronunciation: '종노',
    ttsText: '종노',
    changeProcess: '종로 → 종노 → [종노]',
    ruleType: HangulRieulNasalizationRuleType.direct,
    koreanExplanation: '받침 ㅇ 뒤의 ㄹ이 비음 [ㄴ]으로 바뀝니다.',
    vietnameseExplanation:
        'Sau 받침 ㅇ, ㄹ đổi thành âm mũi [ㄴ], nên 종로 được đọc là [종노].',
  ),
  HangulRieulNasalizationExample(
    writtenForm: '항로',
    pronunciation: '항ː노',
    ttsText: '항노',
    changeProcess: '항로 → 항노 → [항ː노]',
    ruleType: HangulRieulNasalizationRuleType.direct,
    koreanExplanation: '받침 ㅇ 뒤의 ㄹ이 [ㄴ]으로 바뀌며 항은 길게 발음합니다.',
    vietnameseExplanation:
        'ㄹ sau 받침 ㅇ đổi thành [ㄴ]; âm 항 được phát âm dài: [항ː노].',
  ),
  HangulRieulNasalizationExample(
    writtenForm: '막론',
    pronunciation: '망논',
    ttsText: '망논',
    changeProcess: '막론 → 막논(ㄹ → ㄴ) → [망논](ㄱ → ㅇ)',
    ruleType: HangulRieulNasalizationRuleType.chained,
    koreanExplanation: 'ㄱ 뒤의 ㄹ이 먼저 [ㄴ]으로 바뀌고, 새로 생긴 ㄴ 때문에 앞의 ㄱ도 [ㅇ]으로 비음화됩니다.',
    vietnameseExplanation:
        'Trước hết ㄹ sau ㄱ đổi thành [ㄴ]. Sau đó âm ㄴ mới làm ㄱ phía trước tiếp tục đổi thành âm mũi [ㅇ].',
  ),
  HangulRieulNasalizationExample(
    writtenForm: '협력',
    pronunciation: '혐녁',
    ttsText: '혐녁',
    changeProcess: '협력 → 협녁(ㄹ → ㄴ) → [혐녁](ㅂ → ㅁ)',
    ruleType: HangulRieulNasalizationRuleType.chained,
    koreanExplanation: 'ㅂ 뒤의 ㄹ이 먼저 [ㄴ]으로 바뀌고, 그 ㄴ 때문에 앞의 ㅂ도 [ㅁ]으로 비음화됩니다.',
    vietnameseExplanation:
        'Trước hết ㄹ sau ㅂ đổi thành [ㄴ]. Sau đó ㄴ làm ㅂ phía trước tiếp tục đổi thành âm mũi [ㅁ].',
  ),
  HangulRieulNasalizationExample(
    writtenForm: '석류',
    pronunciation: '성뉴',
    ttsText: '성뉴',
    changeProcess: '석류 → 석뉴(ㄹ → ㄴ) → [성뉴](ㄱ → ㅇ)',
    ruleType: HangulRieulNasalizationRuleType.chained,
    koreanExplanation: 'ㄱ 뒤의 ㄹ이 먼저 [ㄴ]으로 바뀐 뒤, 앞의 ㄱ도 [ㅇ]으로 비음화됩니다.',
    vietnameseExplanation:
        'ㄹ sau ㄱ đổi thành [ㄴ] trước, rồi ㄱ phía trước cũng đổi thành âm mũi [ㅇ].',
  ),
];

const hangulRieulNasalizationComparisonKorean =
    '일반 유음화는 ㄴ+ㄹ 또는 ㄹ+ㄴ이 [ㄹㄹ]로 바뀝니다. 그러나 일부 단어는 '
    'ㄹ이 [ㄴ]으로 바뀌어 생산량[생산냥], 의견란[의ː견난]처럼 [ㄴㄴ]으로 발음합니다.';

const hangulRieulNasalizationComparisonVietnamese =
    'Trong biến âm ㄹ thông thường, ㄴ+ㄹ hoặc ㄹ+ㄴ thường trở thành [ㄹㄹ]. '
    'Tuy nhiên, ở một số từ, ㄹ lại đổi thành [ㄴ], tạo cách đọc [ㄴㄴ], ví dụ '
    '생산량 [생산냥] và 의견란 [의ː견난].';
