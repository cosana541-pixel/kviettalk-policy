enum HangulQuizQuestionType {
  matchingCharacter,
  initialConsonant,
  startingSyllable,
  vowelInSyllable,
  syllableWithVowel,
  pronunciationGuide,
}

class HangulQuizQuestion {
  const HangulQuizQuestion({
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  final HangulQuizQuestionType type;
  final String prompt;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
}
