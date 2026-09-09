List<String> createShuffledHangulQuizOptions(List<String> options) {
  final shuffledOptions = List<String>.of(options);
  shuffledOptions.shuffle();
  return shuffledOptions;
}
