import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/compound_final_consonants.dart';
import '../models/hangul_letter.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speechPlayer ??= widget.speechPlayer ?? context.read<TtsService>();
  }

  @override
  void dispose() {
    final speechPlayer = _speechPlayer;
    if (speechPlayer != null) {
      unawaited(speechPlayer.stop());
    }
    super.dispose();
  }

  Future<void> _play(String audioKey, String text) async {
    if (_playingAudioKey != null) return;

    setState(() => _playingAudioKey = audioKey);
    try {
      await _speechPlayer!.speakKorean(text);
    } finally {
      if (mounted) setState(() => _playingAudioKey = null);
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
                      '겹받침 gồm hai phụ âm nằm cùng vị trí 받침. '
                      'Khi đứng cuối âm tiết, chúng thường được đọc bằng một '
                      'âm cuối đại diện. Hãy nghe từ đại diện và ví dụ.',
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

  final HangulLetter consonant;
  final String representativeSound;
  final String? playingAudioKey;
  final Future<void> Function(String audioKey, String text) onPlay;

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
                          'Từ đại diện: ${consonant.name}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _AudioButton(
                        key: ValueKey(
                          'compound-final-consonant-syllable-audio-${consonant.character}',
                        ),
                        tooltip: 'Nghe từ đại diện',
                        audioKey: '${consonant.character}-syllable',
                        text: consonant.name,
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
                  Text(consonant.pronunciationGuide),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ví dụ: ${consonant.examples.join(', ')}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      _AudioButton(
                        key: ValueKey(
                          'compound-final-consonant-examples-audio-${consonant.character}',
                        ),
                        tooltip: 'Nghe từ ví dụ',
                        audioKey: '${consonant.character}-examples',
                        text: consonant.examples.join(', '),
                        playingAudioKey: playingAudioKey,
                        onPlay: onPlay,
                      ),
                    ],
                  ),
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
    required this.audioKey,
    required this.text,
    required this.playingAudioKey,
    required this.onPlay,
  });

  final String tooltip;
  final String audioKey;
  final String text;
  final String? playingAudioKey;
  final Future<void> Function(String audioKey, String text) onPlay;

  @override
  Widget build(BuildContext context) {
    final isPlaying = playingAudioKey == audioKey;
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      onPressed: playingAudioKey == null ? () => onPlay(audioKey, text) : null,
      icon: Icon(
        isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
        color: isPlaying ? Theme.of(context).colorScheme.primary : null,
      ),
    );
  }
}
