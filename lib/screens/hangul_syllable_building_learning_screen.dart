import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_syllable_building.dart';
import '../services/tts_service.dart';
import 'hangul_syllable_building_quiz_screen.dart';

class HangulSyllableBuildingLearningScreen extends StatefulWidget {
  const HangulSyllableBuildingLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulSyllableBuildingLearningScreen> createState() =>
      _HangulSyllableBuildingLearningScreenState();
}

class _HangulSyllableBuildingLearningScreenState
    extends State<HangulSyllableBuildingLearningScreen> {
  KoreanSpeechPlayer? _speechPlayer;
  String? _playingSyllable;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speechPlayer ??= widget.speechPlayer ?? context.read<TtsService>();
  }

  @override
  void dispose() {
    final speechPlayer = _speechPlayer;
    if (speechPlayer != null) unawaited(speechPlayer.stop());
    super.dispose();
  }

  Future<void> _play(HangulSyllableExample example) async {
    if (_playingSyllable != null) return;
    setState(() => _playingSyllable = example.syllable);
    try {
      await _speechPlayer!.speakKorean(example.syllable);
    } finally {
      if (mounted) setState(() => _playingSyllable = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Ghép âm tiết Hangul')),
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
                      'Cấu tạo một âm tiết Hangul',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Một âm tiết được tạo bởi phụ âm đầu (초성) + nguyên âm '
                      '(중성), và có thể có thêm phụ âm cuối (종성/받침).',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            ..._buildStage(
              context,
              title: 'A. Phụ âm đầu + nguyên âm',
              subtitle: '초성 + 중성',
              stage: HangulSyllableBuildingStage.initialAndVowel,
            ),
            ..._buildStage(
              context,
              title: 'B. Thêm phụ âm cuối đơn',
              subtitle: '초성 + 중성 + 홑받침',
              stage: HangulSyllableBuildingStage.simpleFinalConsonant,
            ),
            ..._buildStage(
              context,
              title: 'C. Thêm phụ âm cuối kép',
              subtitle: '초성 + 중성 + 겹받침',
              stage: HangulSyllableBuildingStage.compoundFinalConsonant,
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-syllable-building-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulSyllableBuildingQuizScreen(),
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

  List<Widget> _buildStage(
    BuildContext context, {
    required String title,
    required String subtitle,
    required HangulSyllableBuildingStage stage,
  }) {
    final examples = hangulSyllableBuildingExamples.where(
      (example) => example.stage == stage,
    );
    return [
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 3),
      Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 10),
      for (final example in examples) ...[
        _SyllableBuildingCard(
          example: example,
          playingSyllable: _playingSyllable,
          onPlay: _play,
        ),
        const SizedBox(height: 10),
      ],
      const SizedBox(height: 8),
    ];
  }
}

class _SyllableBuildingCard extends StatelessWidget {
  const _SyllableBuildingCard({
    required this.example,
    required this.playingSyllable,
    required this.onPlay,
  });

  final HangulSyllableExample example;
  final String? playingSyllable;
  final Future<void> Function(HangulSyllableExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingSyllable == example.syllable;
    return Card(
      key: ValueKey('syllable-building-${example.syllable}'),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _PartLabel(label: '초성', value: example.initialConsonant),
                _PartLabel(label: '중성', value: example.vowel),
                if (example.finalConsonant != null)
                  _PartLabel(label: '종성', value: example.finalConsonant!),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${example.formula}  →  ${example.syllable}',
                    key: ValueKey('syllable-formula-${example.syllable}'),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  key: ValueKey('syllable-audio-${example.syllable}'),
                  tooltip: 'Nghe âm tiết ${example.syllable}',
                  onPressed: playingSyllable == null
                      ? () => onPlay(example)
                      : null,
                  icon: Icon(
                    isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
                    color: isPlaying ? colorScheme.primary : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(example.explanation),
          ],
        ),
      ),
    );
  }
}

class _PartLabel extends StatelessWidget {
  const _PartLabel({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label  $value',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
