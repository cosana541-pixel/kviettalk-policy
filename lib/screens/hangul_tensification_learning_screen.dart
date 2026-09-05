import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_tensification.dart';
import '../services/tts_service.dart';
import 'hangul_tensification_quiz_screen.dart';

class HangulTensificationLearningScreen extends StatefulWidget {
  const HangulTensificationLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulTensificationLearningScreen> createState() =>
      _HangulTensificationLearningScreenState();
}

class _HangulTensificationLearningScreenState
    extends State<HangulTensificationLearningScreen> {
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

  Future<void> _play(HangulTensificationExample example) async {
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
      appBar: AppBar(title: const Text('된소리되기 · Căng hóa phụ âm')),
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
                      'ㄱ·ㄷ·ㅂ·ㅅ·ㅈ → ㄲ·ㄸ·ㅃ·ㅆ·ㅉ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '앞 음절의 받침 뒤에서 평음 ㄱ, ㄷ, ㅂ, ㅅ, ㅈ이 '
                      '각각 된소리 [ㄲ], [ㄸ], [ㅃ], [ㅆ], [ㅉ]처럼 발음되는 현상입니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sau 받침 của âm tiết trước, các phụ âm thường ㄱ, ㄷ, ㅂ, '
                      'ㅅ, ㅈ có thể được phát âm căng lần lượt thành '
                      'ㄲ, ㄸ, ㅃ, ㅆ, ㅉ.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '학 + 교 → [학꾜]   ·   국 + 밥 → [국빱]',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  '주의: 모든 받침 뒤의 평음이 무조건 된소리가 되는 것은 아닙니다. '
                  '철자만 보고 기계적으로 바꾸지 말고, 배운 단어의 실제 발음을 함께 익히세요.\n'
                  'Lưu ý: Không phải mọi phụ âm thường sau 받침 đều tự động '
                  'căng hóa. Đừng chỉ đổi máy móc theo chữ viết; hãy học cùng '
                  'cách phát âm thực tế của từ.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '확실한 기본 예시 · Ví dụ cơ bản',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '스피커를 눌러 자연스러운 발음을 들어 보세요. / Nhấn loa để nghe phát âm.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            for (final example in hangulTensificationExamples) ...[
              _TensificationCard(
                example: example,
                playingWrittenForm: _playingWrittenForm,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-tensification-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulTensificationQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('된소리되기 퀴즈 시작 · Bắt đầu quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TensificationCard extends StatelessWidget {
  const _TensificationCard({
    required this.example,
    required this.playingWrittenForm,
    required this.onPlay,
  });

  final HangulTensificationExample example;
  final String? playingWrittenForm;
  final Future<void> Function(HangulTensificationExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWrittenForm == example.writtenForm;
    return Card(
      key: ValueKey('tensification-${example.writtenForm}'),
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
                  key: ValueKey('tensification-audio-${example.writtenForm}'),
                  tooltip: '듣기 · Nghe ${example.writtenForm}',
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
            Text(
              example.writtenStructure,
              key: ValueKey('tensification-structure-${example.writtenForm}'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Icon(Icons.arrow_downward, color: colorScheme.primary),
            const SizedBox(height: 2),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '[${example.pronunciation}]',
                key: ValueKey(
                  'tensification-pronunciation-${example.writtenForm}',
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Chip(
              visualDensity: VisualDensity.compact,
              label: Text(
                '받침 ${example.finalConsonant} → ${example.tenseConsonant}',
              ),
            ),
            const SizedBox(height: 6),
            Text(example.koreanExplanation),
            const SizedBox(height: 4),
            Text(example.vietnameseExplanation),
          ],
        ),
      ),
    );
  }
}
