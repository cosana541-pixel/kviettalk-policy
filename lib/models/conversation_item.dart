// 상황별 회화 한 줄입니다.
class ConversationLine {
  const ConversationLine({
    required this.speaker,
    required this.ko,
    required this.vi,
    required this.koRoman,
    required this.viPronunciationHint,
  });

  final String speaker;
  final String ko;
  final String vi;
  final String koRoman;
  final String viPronunciationHint;

  factory ConversationLine.fromJson(Map<String, dynamic> json) {
    return ConversationLine(
      speaker: json['speaker'] as String,
      ko: json['ko'] as String,
      vi: json['vi'] as String,
      koRoman: json['koRoman'] as String? ?? '',
      viPronunciationHint: json['viPronunciationHint'] as String? ?? '',
    );
  }
}

// 상황별 회화 묶음입니다.
class ConversationItem {
  const ConversationItem({
    required this.id,
    required this.category,
    required this.titleKo,
    required this.titleVi,
    required this.lines,
  });

  final String id;
  final String category;
  final String titleKo;
  final String titleVi;
  final List<ConversationLine> lines;

  factory ConversationItem.fromJson(Map<String, dynamic> json) {
    final lineList = json['lines'] as List<dynamic>? ?? <dynamic>[];

    return ConversationItem(
      id: json['id'] as String,
      category: json['category'] as String,
      titleKo: json['titleKo'] as String,
      titleVi: json['titleVi'] as String,
      lines: lineList
          .map(
            (line) => ConversationLine.fromJson(line as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
