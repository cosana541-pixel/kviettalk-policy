import 'package:flutter/material.dart';

import '../models/word.dart';
import '../services/favorite_service.dart';
import '../services/word_repository.dart';
import '../utils/learning_direction.dart';

// 앱 전체에서 공유하는 상태입니다.
// Provider가 이 클래스를 화면에 전달해 줍니다.
class AppState extends ChangeNotifier {
  AppState({
    required WordRepository wordRepository,
    required FavoriteService favoriteService,
  }) : _wordRepository = wordRepository,
       _favoriteService = favoriteService;

  final WordRepository _wordRepository;
  final FavoriteService _favoriteService;

  List<Word> _allWords = <Word>[];
  List<Word> _words = <Word>[];
  Set<String> _favoriteIds = <String>{};
  LearningDirection? _direction = LearningDirection.vietnameseToKorean;
  bool _isLoading = true;

  List<Word> get words => _words;
  LearningDirection? get direction => _direction;
  bool get isLoading => _isLoading;

  List<String> get categories {
    final values = _words.map((word) => word.category).toSet().toList();
    values.sort();
    return values;
  }

  List<Word> get favoriteWords {
    return _words.where((word) => _favoriteIds.contains(word.id)).toList();
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _allWords = await _wordRepository.loadWords();
    _words = _allWords.where((word) => word.isAvailableForLearning).toList();
    _favoriteIds = await _favoriteService.loadFavoriteIds();
    _direction ??= LearningDirection.vietnameseToKorean;

    _isLoading = false;
    notifyListeners();
  }

  void selectDirection(LearningDirection direction) {
    _direction = direction;
    notifyListeners();
  }

  bool isFavorite(Word word) {
    return _favoriteIds.contains(word.id);
  }

  Future<void> toggleFavorite(Word word) async {
    if (_favoriteIds.contains(word.id)) {
      _favoriteIds.remove(word.id);
    } else {
      _favoriteIds.add(word.id);
    }

    await _favoriteService.saveFavoriteIds(_favoriteIds);
    notifyListeners();
  }
}
