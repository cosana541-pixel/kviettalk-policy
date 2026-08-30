import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/basic_consonants.dart';
import '../models/hangul_letter.dart';
import '../services/tts_service.dart';
import 'consonant_quiz_screen.dart';

class ConsonantLearningScreen extends StatefulWidget {
  const ConsonantLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<ConsonantLearningScreen> createState() =>
      _ConsonantLearningScreenState();
}

class _ConsonantLearningScreenState extends State<ConsonantLearningScreen> {
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
    if (_playingAudioKey != null) {
      return;
    }

    setState(() => _playingAudioKey = audioKey);
    try {
      await _speechPlayer!.speakKorean(text);
    } finally {
      if (mounted) {
        setState(() => _playingAudioKey = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Phụ âm cơ bản')),
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
                      '14 phụ âm cơ bản',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Đọc tên, xem gợi ý phát âm và luyện với các âm tiết mẫu. '
                      'Âm tiếng Việt chỉ là cách so sánh gần đúng.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final consonant in basicConsonants) ...[
              _ConsonantCard(
                consonant: consonant,
                playingAudioKey: _playingAudioKey,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-consonant-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => const ConsonantQuizScreen()),
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

class _ConsonantCard extends StatelessWidget {
  const _ConsonantCard({
    required this.consonant,
    required this.playingAudioKey,
    required this.onPlay,
  });

  final HangulLetter consonant;
  final String? playingAudioKey;
  final Future<void> Function(String audioKey, String text) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      key: ValueKey('consonant-${consonant.character}'),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              constraints: const BoxConstraints(minHeight: 92),
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
                          'Tên: ${consonant.name}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _AudioButton(
                        key: ValueKey(
                          'consonant-name-audio-${consonant.character}',
                        ),
                        tooltip: 'Nghe tên phụ âm',
                        audioKey: '${consonant.character}-name',
                        text: consonant.name.split(' ').first,
                        playingAudioKey: playingAudioKey,
                        onPlay: onPlay,
                      ),
                    ],
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
                          'consonant-examples-audio-${consonant.character}',
                        ),
                        tooltip: 'Nghe âm tiết ví dụ',
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
