import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_palatalization.dart';
import '../services/tts_service.dart';
import 'hangul_palatalization_quiz_screen.dart';

class HangulPalatalizationLearningScreen extends StatefulWidget {
  const HangulPalatalizationLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulPalatalizationLearningScreen> createState() =>
      _HangulPalatalizationLearningScreenState();
}

class _HangulPalatalizationLearningScreenState
    extends State<HangulPalatalizationLearningScreen> {
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

  Future<void> _play(HangulPalatalizationExample example) async {
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
      appBar: AppBar(title: const Text('구개음화 · Biến âm vòm miệng')),
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
                      'ㄷ → ㅈ, ㅌ → ㅊ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '받침 ㄷ, ㅌ(ㄾ)이 조사나 접미사의 모음 ㅣ와 결합하면 '
                      '[ㅈ], [ㅊ]으로 바뀌어 뒤 음절 첫소리로 발음됩니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Khi 받침 ㄷ, ㅌ(ㄾ) kết hợp với nguyên âm ㅣ của trợ từ '
                      'hoặc hậu tố, chúng đổi thành [ㅈ], [ㅊ] và chuyển sang '
                      'đầu âm tiết sau.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '굳 + 이 → [구지]   ·   같 + 이 → [가치]',
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
                  '주의: 철자에 ㄷ/ㅌ + 이가 보인다고 항상 구개음화되는 것은 '
                  '아닙니다. 조사·접미사와 결합하는 조건을 함께 확인하세요.\n'
                  'Lưu ý: Không phải mọi chữ viết có ㄷ/ㅌ + 이 đều biến âm. '
                  'Hãy kiểm tra 이 có phải là trợ từ hoặc hậu tố gắn với từ trước hay không.',
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
            for (final example in hangulPalatalizationExamples) ...[
              _PalatalizationCard(
                example: example,
                playingWrittenForm: _playingWrittenForm,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-palatalization-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulPalatalizationQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('구개음화 퀴즈 시작 · Bắt đầu quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PalatalizationCard extends StatelessWidget {
  const _PalatalizationCard({
    required this.example,
    required this.playingWrittenForm,
    required this.onPlay,
  });

  final HangulPalatalizationExample example;
  final String? playingWrittenForm;
  final Future<void> Function(HangulPalatalizationExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWrittenForm == example.writtenForm;
    return Card(
      key: ValueKey('palatalization-${example.writtenForm}'),
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
                  key: ValueKey('palatalization-audio-${example.writtenForm}'),
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
              key: ValueKey('palatalization-structure-${example.writtenForm}'),
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
                  'palatalization-pronunciation-${example.writtenForm}',
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
              label: Text('받침 ${example.finalConsonant}'),
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
