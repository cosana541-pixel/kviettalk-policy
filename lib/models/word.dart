import '../utils/learning_direction.dart';

// JSON 한 항목을 Dart 객체로 바꿔서 앱 전체에서 사용합니다.
class Word {
  const Word({
    required this.korean,
    required this.vietnamese,
    required this.koreanPronunciation,
    required this.vietnamesePronunciation,
    required this.category,
  });

  final String korean;
  final String vietnamese;
  final String koreanPronunciation;
  final String vietnamesePronunciation;
  final String category;

  // 즐겨찾기 저장용 고유 값입니다. 서버가 없으므로 두 언어 값을 조합합니다.
  String get id => '$korean|$vietnamese';

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      korean: json['korean'] as String,
      vietnamese: json['vietnamese'] as String,
      koreanPronunciation: json['koreanPronunciation'] as String,
      vietnamesePronunciation: json['vietnamesePronunciation'] as String,
      category: json['category'] as String,
    );
  }

  // 현재 학습 방향에 따라 카드의 큰 글자와 뜻을 바꿉니다.
  String questionText(LearningDirection direction) {
    return direction == LearningDirection.koreanToVietnamese
        ? korean
        : vietnamese;
  }

  String answerText(LearningDirection direction) {
    return direction == LearningDirection.koreanToVietnamese
        ? vietnamese
        : korean;
  }

  String pronunciationText(LearningDirection direction) {
    return direction == LearningDirection.koreanToVietnamese
        ? vietnamesePronunciation
        : koreanPronunciation;
  }
}
