import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_consonant_cluster_reduction.dart';
import '../services/tts_service.dart';
import 'hangul_consonant_cluster_reduction_quiz_screen.dart';

class HangulConsonantClusterReductionLearningScreen extends StatefulWidget {
  const HangulConsonantClusterReductionLearningScreen({
    super.key,
    this.speechPlayer,
  });

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulConsonantClusterReductionLearningScreen> createState() =>
      _HangulConsonantClusterReductionLearningScreenState();
}

class _HangulConsonantClusterReductionLearningScreenState
    extends State<HangulConsonantClusterReductionLearningScreen> {
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

  Future<void> _play(HangulConsonantClusterReductionExample example) async {
    if (_playingWrittenForm != null) return;
    setState(() => _playingWrittenForm = example.writtenForm);
    try {
      await _speechPlayer!.speakKorean(
        example.pronunciation.replaceAll(RegExp(r'[\[\]ː]'), ''),
      );
    } finally {
      if (mounted) setState(() => _playingWrittenForm = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('자음군 단순화 · Giản lược cụm phụ âm')),
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
                      '겹받침은 한 받침으로 발음해요',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '겹받침이 음절 끝이나 자음 앞에 오면 두 자음을 모두 '
                      '소리 내지 않고, 단어와 환경에 따라 표준 발음법에 정해진 '
                      '하나의 받침으로 발음합니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Khi 받침 kép đứng cuối âm tiết hoặc trước một phụ âm, '
                      'nó được phát âm thành một 받침 đại diện theo quy tắc phát âm chuẩn.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '이 단원 예시의 결과\n'
                      'ㄳ·ㄺ → [ㄱ]   ㄵ → [ㄴ]   ㄻ → [ㅁ]\n'
                      'ㄼ·ㄾ → [ㄹ]   ㄿ·ㅄ → [ㅂ]',
                      key: const Key('cluster-reduction-rules'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '주의: 다음 규칙이 이어질 수 있어요',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '자음군이 단순화된 뒤, 뒤 자음에 된소리되기 같은 다른 '
                      '규칙이 별도로 적용될 수 있습니다. 예를 들어 앉다는 먼저 '
                      'ㄵ → [ㄴ]으로 단순화되고, 이어서 ㄷ → [ㄸ]이 되어 [안따]입니다.\n'
                      'Sau khi cụm phụ âm được giản lược, một quy tắc khác như '
                      'căng hóa có thể tiếp tục được áp dụng. Vì vậy [안따] là kết quả của hai bước.',
                      key: const Key('cluster-reduction-chain-note'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ],
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
              '스피커를 눌러 실제 표준 발음을 들어 보세요. / '
              'Nhấn loa để nghe cách phát âm chuẩn.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            for (final example in hangulConsonantClusterReductionExamples) ...[
              _ClusterReductionCard(
                example: example,
                playingWrittenForm: _playingWrittenForm,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-cluster-reduction-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) =>
                      const HangulConsonantClusterReductionQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('자음군 단순화 퀴즈 시작 · Bắt đầu quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClusterReductionCard extends StatelessWidget {
  const _ClusterReductionCard({
    required this.example,
    required this.playingWrittenForm,
    required this.onPlay,
  });

  final HangulConsonantClusterReductionExample example;
  final String? playingWrittenForm;
  final Future<void> Function(HangulConsonantClusterReductionExample example)
  onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWrittenForm == example.writtenForm;
    return Card(
      key: ValueKey('cluster-reduction-${example.writtenForm}'),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '표기 · Cách viết',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        example.writtenForm,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: ValueKey(
                    'cluster-reduction-audio-${example.writtenForm}',
                  ),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '실제 발음 · Phát âm thực tế',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    '[${example.pronunciation}]',
                    key: ValueKey(
                      'cluster-reduction-pronunciation-${example.writtenForm}',
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '겹받침 ${example.cluster} · 남는 받침 [${example.remainingFinal}]',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Chip(
              visualDensity: VisualDensity.compact,
              label: Text(example.rule),
            ),
            if (example.chainRule case final chainRule?) ...[
              const SizedBox(height: 4),
              Chip(
                avatar: const Icon(Icons.link, size: 18),
                visualDensity: VisualDensity.compact,
                label: Text(chainRule),
              ),
            ],
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
