import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_liquidization.dart';
import '../services/tts_service.dart';
import 'hangul_liquidization_quiz_screen.dart';

class HangulLiquidizationLearningScreen extends StatefulWidget {
  const HangulLiquidizationLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulLiquidizationLearningScreen> createState() =>
      _HangulLiquidizationLearningScreenState();
}

class _HangulLiquidizationLearningScreenState
    extends State<HangulLiquidizationLearningScreen> {
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

  Future<void> _play(HangulLiquidizationExample example) async {
    if (_playingWrittenForm != null) return;
    setState(() => _playingWrittenForm = example.writtenForm);
    try {
      await _speechPlayer!.speakKorean(
        example.pronunciation.replaceAll('ː', ''),
      );
    } finally {
      if (mounted) setState(() => _playingWrittenForm = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('유음화 · Biến âm lỏng')),
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
                      'ㄴ과 ㄹ이 만나면 [ㄹㄹ]',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '유음화는 ㄴ과 ㄹ이 서로 만나면 ㄴ이 [ㄹ]로 바뀌어 '
                      '두 소리가 [ㄹㄹ]로 이어지는 현상입니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Khi ㄴ và ㄹ gặp nhau, ㄴ đổi thành [ㄹ], vì vậy '
                      'hai âm được phát âm liền thành [ㄹㄹ].',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'ㄴ + ㄹ → [ㄹㄹ]\n'
                      'ㄹ + ㄴ → [ㄹㄹ]',
                      key: const Key('liquidization-rules'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                  '팁: 모든 ㄴ+ㄹ 조합이 유음화되는 것은 아닙니다. 생산량[생산냥]처럼 '
                  'ㄹ이 [ㄴ]으로 발음되는 예외도 있으므로 사전의 표준 발음을 확인하세요. '
                  '줄넘기[줄럼끼]처럼 된소리되기가 함께 일어나는 단어는 다음 단계에서 '
                  '따로 익히는 것이 좋습니다.\n'
                  'Mẹo: Không phải mọi tổ hợp ㄴ+ㄹ đều biến thành [ㄹㄹ]. '
                  'Có ngoại lệ như 생산량[생산냥], trong đó ㄹ được đọc là [ㄴ]. '
                  'Những từ có thêm biến đổi khác nên được học riêng.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '표준 발음 예시 · Ví dụ phát âm chuẩn',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '스피커를 눌러 표시된 표준 발음을 들어 보세요. / '
              'Nhấn loa để nghe cách phát âm chuẩn.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            for (final example in hangulLiquidizationExamples) ...[
              _LiquidizationCard(
                example: example,
                playingWrittenForm: _playingWrittenForm,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-liquidization-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulLiquidizationQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('유음화 퀴즈 시작 · Bắt đầu quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiquidizationCard extends StatelessWidget {
  const _LiquidizationCard({
    required this.example,
    required this.playingWrittenForm,
    required this.onPlay,
  });

  final HangulLiquidizationExample example;
  final String? playingWrittenForm;
  final Future<void> Function(HangulLiquidizationExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWrittenForm == example.writtenForm;
    return Card(
      key: ValueKey('liquidization-${example.writtenForm}'),
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
                  key: ValueKey('liquidization-audio-${example.writtenForm}'),
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
              key: ValueKey('liquidization-structure-${example.writtenForm}'),
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
                  'liquidization-pronunciation-${example.writtenForm}',
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
              label: Text(example.rule),
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
