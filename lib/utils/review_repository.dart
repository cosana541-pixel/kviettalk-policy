import 'package:shared_preferences/shared_preferences.dart';

import '../models/word.dart';
import 'learning_stats_keys.dart';

class ReviewRepository {
  const ReviewRepository(this.preferences);

  final SharedPreferences preferences;

  List<Word> wrongQuizWords(List<Word> words) {
    return _wordsByIds(
      words,
      preferences.getStringList(LearningStatsKeys.quizWrongIds),
    );
  }

  List<Word> recentWords(List<Word> words) {
    return _wordsByIds(
      words,
      preferences.getStringList(LearningStatsKeys.recentWordIds),
    );
  }

  Future<void> addWrongQuizWord(Word word) async {
    await _saveWordId(LearningStatsKeys.quizWrongIds, word.id, limit: 30);
  }

  Future<void> removeWrongQuizWord(Word word) async {
    final ids =
        preferences.getStringList(LearningStatsKeys.quizWrongIds) ?? <String>[];
    ids.remove(word.id);
    await preferences.setStringList(LearningStatsKeys.quizWrongIds, ids);
  }

  Future<void> addRecentWord(Word word) async {
    await _saveWordId(LearningStatsKeys.recentWordIds, word.id, limit: 20);
  }

  Future<void> _saveWordId(String key, String id, {required int limit}) async {
    final ids = preferences.getStringList(key) ?? <String>[];
    ids.remove(id);
    ids.insert(0, id);
    await preferences.setStringList(key, ids.take(limit).toList());
  }

  List<Word> _wordsByIds(List<Word> words, List<String>? ids) {
    if (ids == null || ids.isEmpty) {
      return <Word>[];
    }

    final wordsById = {for (final word in words) word.id: word};
    return ids.map((id) => wordsById[id]).whereType<Word>().toList();
  }
}
