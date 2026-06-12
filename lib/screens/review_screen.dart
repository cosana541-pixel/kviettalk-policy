import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_state.dart';
import '../models/word.dart';
import '../utils/learning_direction.dart';
import '../utils/review_repository.dart';
import '../widgets/illustration_placeholder.dart';
import '../widgets/word_card.dart';
import 'word_detail_screen.dart';

enum _ReviewMode { wrongQuiz, favorites, recent }

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.direction});

  final LearningDirection direction;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  _ReviewMode _mode = _ReviewMode.wrongQuiz;
  late Future<SharedPreferences> _preferencesFuture;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return FutureBuilder<SharedPreferences>(
      future: _preferencesFuture,
      builder: (context, snapshot) {
        final preferences = snapshot.data;
        final reviewRepository = preferences == null
            ? null
            : ReviewRepository(preferences);
        final words = _reviewWords(appState, reviewRepository);

        return Column(
          children: [
            _ReviewHeader(
              mode: _mode,
              onChanged: (mode) {
                setState(() => _mode = mode);
              },
            ),
            Expanded(
              child: preferences == null
                  ? const Center(child: CircularProgressIndicator())
                  : words.isEmpty
                  ? _ReviewEmptyState(mode: _mode)
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        final word = words[index];

                        return WordCard(
                          word: word,
                          direction: widget.direction,
                          onTap: () => _openDetail(context, word),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  List<Word> _reviewWords(
    AppState appState,
    ReviewRepository? reviewRepository,
  ) {
    switch (_mode) {
      case _ReviewMode.wrongQuiz:
        return reviewRepository?.wrongQuizWords(appState.words) ?? <Word>[];
      case _ReviewMode.favorites:
        return appState.favoriteWords;
      case _ReviewMode.recent:
        return reviewRepository?.recentWords(appState.words) ?? <Word>[];
    }
  }

  void _openDetail(BuildContext context, Word word) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            WordDetailScreen(word: word, direction: widget.direction),
      ),
    );
  }
}

class _ReviewHeader extends StatelessWidget {
  const _ReviewHeader({required this.mode, required this.onChanged});

  final _ReviewMode mode;
  final ValueChanged<_ReviewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ôn tập',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Xem lại từ cần luyện thêm sau mỗi buổi học.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _ReviewChoice(
                  label: 'Quiz sai',
                  icon: Icons.quiz_outlined,
                  selected: mode == _ReviewMode.wrongQuiz,
                  onTap: () => onChanged(_ReviewMode.wrongQuiz),
                ),
                _ReviewChoice(
                  label: 'Yêu thích',
                  icon: Icons.star_border,
                  selected: mode == _ReviewMode.favorites,
                  onTap: () => onChanged(_ReviewMode.favorites),
                ),
                _ReviewChoice(
                  label: 'Gần đây',
                  icon: Icons.history,
                  selected: mode == _ReviewMode.recent,
                  onTap: () => onChanged(_ReviewMode.recent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewChoice extends StatelessWidget {
  const _ReviewChoice({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _ReviewEmptyState extends StatelessWidget {
  const _ReviewEmptyState({required this.mode});

  final _ReviewMode mode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IllustrationPlaceholder(
              icon: _icon,
              assetPath: 'assets/images/review/review.png',
              size: 72,
            ),
            const SizedBox(height: 12),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    switch (mode) {
      case _ReviewMode.wrongQuiz:
        return Icons.celebration_outlined;
      case _ReviewMode.favorites:
        return Icons.star_border;
      case _ReviewMode.recent:
        return Icons.history;
    }
  }

  String get _message {
    switch (mode) {
      case _ReviewMode.wrongQuiz:
        return 'Chưa có câu quiz sai.\nLàm quiz để tạo danh sách ôn tập.';
      case _ReviewMode.favorites:
        return 'Chưa có từ yêu thích.\nHãy nhấn ngôi sao để lưu từ cần nhớ.';
      case _ReviewMode.recent:
        return 'Chưa có từ học gần đây.\nMở một từ để lưu vào danh sách này.';
    }
  }
}
