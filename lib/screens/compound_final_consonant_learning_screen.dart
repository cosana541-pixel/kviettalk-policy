import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/compound_final_consonants.dart';
import '../services/tts_service.dart';
import 'compound_final_consonant_quiz_screen.dart';

class CompoundFinalConsonantLearningScreen extends StatefulWidget {
  const CompoundFinalConsonantLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<CompoundFinalConsonantLearningScreen> createState() =>
      _CompoundFinalConsonantLearningScreenState();
}

class _CompoundFinalConsonantLearningScreenState
    extends State<CompoundFinalConsonantLearningScreen> {
  KoreanSpeechPlayer? _speechPlayer;
  String? _playingAudioKey;
  int _playGeneration = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speechPlayer ??= widget.speechPlayer ?? context.read<TtsService>();
  }

  @override
  void dispose() {
    _playGeneration++;
    final speechPlayer = _speechPlayer;
    if (speechPlayer != null) {
      unawaited(speechPlayer.stop());
    }
    super.dispose();
  }

  Future<void> _play(CompoundFinalConsonantLearningItem consonant) async {
    final audioKey = consonant.character;
    if (_playingAudioKey == audioKey) return;
    final shouldStopCurrent = _playingAudioKey != null;
    final generation = ++_playGeneration;
    setState(() => _playingAudioKey = audioKey);
    try {
      if (shouldStopCurrent) await _speechPlayer!.stop();
      if (!mounted || generation != _playGeneration) return;
      await _speechPlayer!.speakKorean(
        consonant.ttsText.replaceAll(RegExp(r'[\[\]ː]'), ''),
      );
    } finally {
      if (mounted && generation == _playGeneration) {
        setState(() => _playingAudioKey = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Phụ âm cuối kép')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '11 phụ âm cuối kép (겹받침)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '겹받침은 두 자음이 한 받침 자리에 모인 글자예요. '
                      '여기서는 글자와 기본 받침 소리만 익히고, 자세한 변화는 중급에서 배워요.\n'
                      '겹받침 gồm hai phụ âm ở cùng vị trí 받침. '
                      'Bài này học mặt chữ và âm cuối cơ bản; các biến đổi chi tiết sẽ học ở trình độ trung cấp.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final consonant in compoundFinalConsonants) ...[
              _CompoundFinalConsonantCard(
                consonant: consonant,
                representativeSound:
                    compoundFinalConsonantSoundGroups[consonant.character]!,
                playingAudioKey: _playingAudioKey,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-compound-final-consonant-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const CompoundFinalConsonantQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('Bắt đầu quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompoundFinalConsonantCard extends StatelessWidget {
  const _CompoundFinalConsonantCard({
    required this.consonant,
    required this.representativeSound,
    required this.playingAudioKey,
    required this.onPlay,
  });

  final CompoundFinalConsonantLearningItem consonant;
  final String representativeSound;
  final String? playingAudioKey;
  final Future<void> Function(CompoundFinalConsonantLearningItem consonant)
  onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      key: ValueKey('compound-final-consonant-${consonant.character}'),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              constraints: const BoxConstraints(minHeight: 110),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                consonant.character,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '예시 · Ví dụ: ${consonant.name}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _AudioButton(
                        key: ValueKey(
                          'compound-final-consonant-syllable-audio-${consonant.character}',
                        ),
                        tooltip: '듣기 · Nghe ${consonant.name}',
                        consonant: consonant,
                        playingAudioKey: playingAudioKey,
                        onPlay: onPlay,
                      ),
                    ],
                  ),
                  Text(
                    'Âm cuối đại diện: [$representativeSound]',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    key: ValueKey(
                      'compound-final-consonant-pronunciation-${consonant.character}',
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${consonant.name} → [${consonant.pronunciation}]',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(consonant.koreanExplanation),
                  const SizedBox(height: 4),
                  Text(consonant.vietnameseExplanation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioButton extends StatelessWidget {
  const _AudioButton({
    super.key,
    required this.tooltip,
    required this.consonant,
    required this.playingAudioKey,
    required this.onPlay,
  });

  final String tooltip;
  final CompoundFinalConsonantLearningItem consonant;
  final String? playingAudioKey;
  final Future<void> Function(CompoundFinalConsonantLearningItem consonant)
  onPlay;

  @override
  Widget build(BuildContext context) {
    final isPlaying = playingAudioKey == consonant.character;
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      onPressed: isPlaying ? null : () => onPlay(consonant),
      icon: Icon(
        isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
        color: isPlaying ? Theme.of(context).colorScheme.primary : null,
      ),
    );
  }
}
