import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_liaison.dart';
import '../services/tts_service.dart';
import 'hangul_liaison_quiz_screen.dart';

class HangulLiaisonLearningScreen extends StatefulWidget {
  const HangulLiaisonLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulLiaisonLearningScreen> createState() =>
      _HangulLiaisonLearningScreenState();
}

class _HangulLiaisonLearningScreenState
    extends State<HangulLiaisonLearningScreen> {
  KoreanSpeechPlayer? _speechPlayer;
  String? _playingWrittenForm;

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

  Future<void> _play(HangulLiaisonExample example) async {
    if (_playingWrittenForm != null) return;
    setState(() => _playingWrittenForm = example.writtenForm);
    try {
      await _speechPlayer!.speakKorean(example.writtenForm);
    } finally {
      if (mounted) setState(() => _playingWrittenForm = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Nối âm trong tiếng Hàn (연음)')),
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
                      '받침 nối sang âm tiết tiếp theo',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Khi một âm tiết có 받침 và phần tiếp theo bắt đầu bằng '
                      'nguyên âm, phụ âm cuối thường được nối sang đầu âm tiết '
                      'tiếp theo khi phát âm.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Cách viết: 먹 + 어요  →  Phát âm: 머거요',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ví dụ cơ bản',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Nhấn biểu tượng loa để nghe cách phát âm tự nhiên của từ.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            for (final example in hangulLiaisonExamples) ...[
              _LiaisonCard(
                example: example,
                playingWrittenForm: _playingWrittenForm,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-liaison-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulLiaisonQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('Bắt đầu quiz nối âm'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiaisonCard extends StatelessWidget {
  const _LiaisonCard({
    required this.example,
    required this.playingWrittenForm,
    required this.onPlay,
  });

  final HangulLiaisonExample example;
  final String? playingWrittenForm;
  final Future<void> Function(HangulLiaisonExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWrittenForm == example.writtenForm;
    return Card(
      key: ValueKey('liaison-${example.writtenForm}'),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    example.writtenForm,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  key: ValueKey('liaison-audio-${example.writtenForm}'),
                  tooltip: 'Nghe ${example.writtenForm}',
                  onPressed: playingWrittenForm == null
                      ? () => onPlay(example)
                      : null,
                  icon: Icon(
                    isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
                    color: isPlaying ? colorScheme.primary : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Cách viết',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              example.writtenStructure,
              key: ValueKey('liaison-structure-${example.writtenForm}'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Icon(Icons.arrow_downward, color: colorScheme.primary),
            const SizedBox(height: 2),
            Text(
              'Phát âm',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                example.pronunciation,
                key: ValueKey('liaison-pronunciation-${example.writtenForm}'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Chip(
              visualDensity: VisualDensity.compact,
              label: Text('받침 ${example.finalConsonant}'),
            ),
            const SizedBox(height: 6),
            Text(example.explanation),
            if (example.note != null) ...[
              const SizedBox(height: 6),
              Text(
                example.note!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
