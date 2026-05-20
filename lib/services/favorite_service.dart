import 'package:shared_preferences/shared_preferences.dart';

// 즐겨찾기를 휴대폰 내부 저장소에 간단히 저장합니다.
class FavoriteService {
  static const String _favoriteKey = 'favorite_word_ids';
  static const String _conversationFavoriteKey = 'favorite_conversation_ids';

  Future<Set<String>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteKey)?.toSet() ?? <String>{};
  }

  Future<void> saveFavoriteIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteKey, ids.toList());
  }

  Future<Set<String>> loadConversationFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_conversationFavoriteKey)?.toSet() ?? <String>{};
  }

  Future<void> saveConversationFavoriteIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_conversationFavoriteKey, ids.toList());
  }
}
