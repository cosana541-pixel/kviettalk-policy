import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_n_insertion.dart';
import '../services/tts_service.dart';
import 'hangul_n_insertion_quiz_screen.dart';

class HangulNInsertionLearningScreen extends StatefulWidget {
  const HangulNInsertionLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulNInsertionLearningScreen> createState() =>
      _HangulNInsertionLearningScreenState();
}

class _HangulNInsertionLearningScreenState
    extends State<HangulNInsertionLearningScreen> {
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

  Future<void> _play(HangulNInsertionExample example) async {
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
      appBar: AppBar(title: const Text('Thêm âm ㄴ')),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 24),
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
                      'Âm ㄴ được thêm ở ranh giới thành tố',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Trong từ ghép hoặc từ phái sinh, khi phần trước kết thúc '
                      'bằng phụ âm và phần sau bắt đầu bằng 이, 야, 여, 요 hoặc 유, '
                      'âm ㄴ không có trong chữ viết có thể được thêm khi phát âm.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Phụ âm cuối + 이/야/여/요/유\n→ thêm âm ㄴ',
                      key: const Key('n-insertion-rules'),
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
                      'Lưu ý: Không áp dụng cho mọi từ có dạng tương tự',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Hiện tượng này chủ yếu xuất hiện ở ranh giới thành tố của '
                      'từ ghép hoặc từ phái sinh. Sau khi thêm ㄴ, biến âm mũi '
                      'hoặc lưu âm hóa có thể tiếp tục xảy ra. Không áp dụng máy '
                      'móc cho mọi từ có hình thức giống nhau.',
                      key: const Key('n-insertion-chain-note'),
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
              'Ví dụ phát âm chuẩn',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Nhấn loa để nghe cách phát âm chuẩn cuối cùng.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            for (final example in hangulNInsertionExamples) ...[
              _NInsertionCard(
                example: example,
                playingWrittenForm: _playingWrittenForm,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-n-insertion-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulNInsertionQuizScreen(),
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

class _NInsertionCard extends StatelessWidget {
  const _NInsertionCard({
    required this.example,
    required this.playingWrittenForm,
    required this.onPlay,
  });

  final HangulNInsertionExample example;
  final String? playingWrittenForm;
  final Future<void> Function(HangulNInsertionExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWrittenForm == example.writtenForm;
    return Card(
      key: ValueKey('n-insertion-${example.writtenForm}'),
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
                        example.writtenForm,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        example.wordBoundary,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: ValueKey('n-insertion-audio-${example.writtenForm}'),
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
                    'Phát âm chuẩn',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    '[${example.pronunciation}]',
                    key: ValueKey(
                      'n-insertion-pronunciation-${example.writtenForm}',
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (example.changeProcess case final changeProcess?) ...[
              const SizedBox(height: 10),
              Container(
                key: ValueKey('n-insertion-process-${example.writtenForm}'),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  changeProcess,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(example.vietnameseExplanation),
          ],
        ),
      ),
    );
  }
}
