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
      appBar: AppBar(title: const Text('ㄴ 첨가 · Thêm âm ㄴ')),
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
                      '형태소 경계에서 ㄴ 소리가 더해져요',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '합성어나 파생어에서 앞말이 자음으로 끝나고 뒷말이 '
                      '이, 야, 여, 요, 유로 시작할 때 일정한 조건에서 철자에 없는 '
                      'ㄴ 소리가 첨가될 수 있습니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
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
                      '받침 + 이/야/여/요/유 → ㄴ 소리 첨가',
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
                      '주의: 모든 비슷한 단어에 적용하지 않아요',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '주로 형태소 경계가 있는 합성어·파생어에서 나타나며, '
                      'ㄴ 첨가 뒤에 비음화나 유음화가 이어질 수 있습니다. '
                      '비슷한 모양의 모든 단어에 무조건 적용되는 규칙은 아닙니다.\n'
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
              '표준 발음 예시 · Ví dụ phát âm chuẩn',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '스피커를 눌러 최종 표준 발음을 들어 보세요. / '
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
              label: const Text('ㄴ 첨가 퀴즈 시작 · Bắt đầu quiz'),
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
                    '표준 발음 · Phát âm chuẩn',
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
            Text(example.koreanExplanation),
            const SizedBox(height: 4),
            Text(example.vietnameseExplanation),
          ],
        ),
      ),
    );
  }
}
