enum HangulSaiSiotRuleType {
  tensification,
  nBeforeNOrM,
  doubleNBeforeI,
}

class HangulSaiSiotExample {
  const HangulSaiSiotExample({
    required this.displayWord,
    required this.pronunciation,
    required this.learnerPronunciation,
    required this.koreanExplanation,
    required this.vietnameseExplanation,
    required this.ruleType,
    required this.ttsText,
    required this.changeProcess,
    this.allowedPronunciation,
  });

  final String displayWord;
  final String pronunciation;
  final String learnerPronunciation;
  final String koreanExplanation;
  final String vietnameseExplanation;
  final HangulSaiSiotRuleType ruleType;
  final String ttsText;
  final String changeProcess;
  final String? allowedPronunciation;

  bool get hasAllowedPronunciation => allowedPronunciation != null;
}

const hangulSaiSiotExamples = <HangulSaiSiotExample>[
  HangulSaiSiotExample(
    displayWord: '찻집',
    pronunciation: '차찝',
    learnerPronunciation: '차-찝',
    allowedPronunciation: '찯찝',
    ruleType: HangulSaiSiotRuleType.tensification,
    ttsText: '차찝',
    changeProcess: '원칙 [차찝] · 허용 [찯찝]',
    koreanExplanation:
        '사이시옷을 소리 내지 않고 집의 ㅈ만 ㅉ으로 발음하는 [차찝]이 원칙입니다. '
        '사이시옷을 받침 [ㄷ]으로 발음한 [찯찝]도 허용됩니다.',
    vietnameseExplanation:
        'Cách đọc chính là [차찝]: không đọc riêng ㅅ mà đọc căng ㅈ của 집 thành ㅉ. '
        'Cách đọc [찯찝] với âm cuối [ㄷ] cũng được chấp nhận.',
  ),
  HangulSaiSiotExample(
    displayWord: '냇가',
    pronunciation: '내ː까',
    learnerPronunciation: '내ː-까',
    allowedPronunciation: '낻ː까',
    ruleType: HangulSaiSiotRuleType.tensification,
    ttsText: '내까',
    changeProcess: '원칙 [내ː까] · 허용 [낻ː까]',
    koreanExplanation:
        '사이시옷을 소리 내지 않고 가의 ㄱ만 ㄲ으로 발음하는 [내ː까]가 원칙입니다. '
        '사이시옷을 [ㄷ]으로 발음한 [낻ː까]도 허용됩니다.',
    vietnameseExplanation:
        'Cách đọc chính là [내ː까], với ㄱ của 가 được đọc căng thành ㄲ. '
        'Cách đọc [낻ː까] có âm cuối [ㄷ] cũng được chấp nhận.',
  ),
  HangulSaiSiotExample(
    displayWord: '콧등',
    pronunciation: '코뜽',
    learnerPronunciation: '코-뜽',
    allowedPronunciation: '콛뜽',
    ruleType: HangulSaiSiotRuleType.tensification,
    ttsText: '코뜽',
    changeProcess: '원칙 [코뜽] · 허용 [콛뜽]',
    koreanExplanation:
        '등의 ㄷ만 ㄸ으로 발음하는 [코뜽]이 원칙이며, '
        '사이시옷을 [ㄷ]으로 발음한 [콛뜽]도 허용됩니다.',
    vietnameseExplanation:
        'Cách đọc chính là [코뜽], trong đó ㄷ của 등 chuyển thành ㄸ. '
        'Cách đọc [콛뜽] có âm cuối [ㄷ] cũng được chấp nhận.',
  ),
  HangulSaiSiotExample(
    displayWord: '뱃길',
    pronunciation: '배낄',
    learnerPronunciation: '배-낄',
    allowedPronunciation: '밷낄',
    ruleType: HangulSaiSiotRuleType.tensification,
    ttsText: '배낄',
    changeProcess: '원칙 [배낄] · 허용 [밷낄]',
    koreanExplanation:
        '길의 ㄱ만 ㄲ으로 발음하는 [배낄]이 원칙이며, '
        '사이시옷을 [ㄷ]으로 발음한 [밷낄]도 허용됩니다.',
    vietnameseExplanation:
        'Cách đọc chính là [배낄], với ㄱ của 길 được đọc căng thành ㄲ. '
        'Cách đọc [밷낄] có âm cuối [ㄷ] cũng được chấp nhận.',
  ),
  HangulSaiSiotExample(
    displayWord: '햇볕',
    pronunciation: '해뼏',
    learnerPronunciation: '해-뼏',
    allowedPronunciation: '핻뼏',
    ruleType: HangulSaiSiotRuleType.tensification,
    ttsText: '해뼏',
    changeProcess: '원칙 [해뼏] · 허용 [핻뼏]',
    koreanExplanation:
        '볕의 ㅂ만 ㅃ으로 발음하고 끝소리 ㅌ을 [ㄷ]으로 읽은 [해뼏]이 원칙입니다. '
        '사이시옷까지 [ㄷ]으로 발음한 [핻뼏]도 허용됩니다.',
    vietnameseExplanation:
        'Cách đọc chính là [해뼏]: ㅂ của 볕 thành ㅃ và ㅌ cuối đọc là [ㄷ]. '
        'Cách đọc [핻뼏] có thêm âm cuối [ㄷ] cũng được chấp nhận.',
  ),
  HangulSaiSiotExample(
    displayWord: '나뭇잎',
    pronunciation: '나문닙',
    learnerPronunciation: '나-문-닙',
    ruleType: HangulSaiSiotRuleType.doubleNBeforeI,
    ttsText: '나문닙',
    changeProcess: '제30항 3: [나묻닙] → [나문닙]',
    koreanExplanation:
        '사이시옷 뒤에 ‘이’ 음이 결합하여 [ㄴㄴ]으로 발음하는 유형입니다. '
        '규정에 제시된 과정은 [나묻닙]을 거쳐 [나문닙]이 되는 것입니다.',
    vietnameseExplanation:
        'Đây là trường hợp âm 이 sau 사이시옷 được phát âm với hai âm ㄴ. '
        'Quá trình được trình bày là [나묻닙] rồi thành [나문닙].',
  ),
  HangulSaiSiotExample(
    displayWord: '깻잎',
    pronunciation: '깬닙',
    learnerPronunciation: '깬-닙',
    ruleType: HangulSaiSiotRuleType.doubleNBeforeI,
    ttsText: '깬닙',
    changeProcess: '제30항 3: [깯닙] → [깬닙]',
    koreanExplanation:
        '사이시옷 뒤에 ‘이’ 음이 결합하여 [ㄴㄴ]으로 발음하는 유형입니다. '
        '규정에 제시된 과정은 [깯닙]을 거쳐 [깬닙]이 되는 것입니다.',
    vietnameseExplanation:
        'Đây là trường hợp âm 이 sau 사이시옷 được phát âm với hai âm ㄴ. '
        'Quá trình được trình bày là [깯닙] rồi thành [깬닙].',
  ),
  HangulSaiSiotExample(
    displayWord: '콧날',
    pronunciation: '콘날',
    learnerPronunciation: '콘-날',
    ruleType: HangulSaiSiotRuleType.nBeforeNOrM,
    ttsText: '콘날',
    changeProcess: '제30항 2: [콛날] → [콘날]',
    koreanExplanation:
        '사이시옷 뒤에 ㄴ이 결합하면 사이시옷을 [ㄴ]으로 발음합니다. '
        '[콛날]의 받침 [ㄷ]이 뒤의 ㄴ과 만나 비음 [ㄴ]으로 바뀐 결과가 [콘날]입니다.',
    vietnameseExplanation:
        'Khi ㄴ đứng sau 사이시옷, 사이시옷 được phát âm thành [ㄴ]. '
        'Có thể hiểu quá trình là [콛날] → [콘날], khi [ㄷ] biến thành ㄴ trước ㄴ.',
  ),
];
