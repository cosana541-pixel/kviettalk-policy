class HangulLetter {
  const HangulLetter({
    required this.character,
    required this.name,
    required this.pronunciationGuide,
    required this.examples,
  });

  final String character;
  final String name;
  final String pronunciationGuide;
  final List<String> examples;
}
