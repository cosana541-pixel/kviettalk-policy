import '../models/word.dart';

List<Word> sortWordsByKorean(List<Word> words) {
  final sortedWords = List<Word>.of(words);
  sortedWords.sort((a, b) => a.korean.compareTo(b.korean));
  return sortedWords;
}
