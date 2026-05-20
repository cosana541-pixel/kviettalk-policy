// 학습 방향을 한 곳에서 관리합니다.
// enum을 쓰면 문자열 오타를 줄일 수 있어 초보자에게도 안전합니다.
enum LearningDirection { koreanToVietnamese, vietnameseToKorean }

extension LearningDirectionText on LearningDirection {
  String get title {
    switch (this) {
      case LearningDirection.koreanToVietnamese:
        return 'Học tiếng Việt';
      case LearningDirection.vietnameseToKorean:
        return 'Người Việt học tiếng Hàn';
    }
  }

  String get shortTitle {
    switch (this) {
      case LearningDirection.koreanToVietnamese:
        return 'Học tiếng Việt';
      case LearningDirection.vietnameseToKorean:
        return 'Học tiếng Hàn';
    }
  }
}
