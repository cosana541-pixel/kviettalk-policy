import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/final_consonants.dart';
import '../services/tts_service.dart';
import 'final_consonant_quiz_screen.dart';

class FinalConsonantLearningScreen extends StatefulWidget {
  const FinalConsonantLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<FinalConsonantLearningScreen> createState() =>
      _FinalConsonantLearningScreenState();
}

class _FinalConsonantLearningScreenState
    extends State<FinalConsonantLearningScreen> {
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

  Future<void> _play(FinalConsonantLearningItem consonant) async {
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
      appBar: AppBar(title: const Text('Phụ âm cuối đơn')),
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
                      '16 phụ âm cuối đơn (홑받침)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '받침 là phụ âm cuối nằm dưới một âm tiết Hangeul. '
                      'Dù có nhiều chữ, âm cuối đại diện được gom thành 7 nhóm: '
                      '[ㄱ], [ㄴ], [ㄷ], [ㄹ], [ㅁ], [ㅂ], [ㅇ]. '
                      'Hình chữ và âm cuối thực tế đôi khi khác nhau.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final consonant in finalConsonants) ...[
              _FinalConsonantCard(
                consonant: consonant,
                representativeSound:
                    finalConsonantSoundGroups[consonant.character]!,
                playingAudioKey: _playingAudioKey,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-final-consonant-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const FinalConsonantQuizScreen(),
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

class _FinalConsonantCard extends StatelessWidget {
  const _FinalConsonantCard({
    required this.consonant,
    required this.representativeSound,
    required this.playingAudioKey,
    required this.onPlay,
  });

  final FinalConsonantLearningItem consonant;
  final String representativeSound;
  final String? playingAudioKey;
  final Future<void> Function(FinalConsonantLearningItem consonant) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      key: ValueKey('final-consonant-${consonant.character}'),
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
                          'final-consonant-syllable-audio-${consonant.character}',
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
                      'final-consonant-pronunciation-${consonant.character}',
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
  final FinalConsonantLearningItem consonant;
  final String? playingAudioKey;
  final Future<void> Function(FinalConsonantLearningItem consonant) onPlay;

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
