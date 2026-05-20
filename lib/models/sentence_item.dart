import '../utils/learning_direction.dart';

// 문장 학습용 데이터 모델입니다.
// 단어 모델과 섞지 않아 초보자도 파일 역할을 쉽게 구분할 수 있습니다.
class SentenceItem {
  const SentenceItem({
    required this.id,
    required this.category,
    required this.ko,
    required this.vi,
    required this.koRoman,
    required this.viPronunciationHint,
  });

  final String id;
  final String category;
  final String ko;
  final String vi;
  final String koRoman;
  final String viPronunciationHint;

  factory SentenceItem.fromJson(Map<String, dynamic> json) {
    return SentenceItem(
      id: json['id'] as String,
      category: json['category'] as String,
      ko: json['ko'] as String,
      vi: json['vi'] as String,
      koRoman: json['koRoman'] as String? ?? '',
      viPronunciationHint: json['viPronunciationHint'] as String? ?? '',
    );
  }

  String questionText(LearningDirection direction) {
    return direction == LearningDirection.koreanToVietnamese ? ko : vi;
  }

  String answerText(LearningDirection direction) {
    return direction == LearningDirection.koreanToVietnamese ? vi : ko;
  }
}
