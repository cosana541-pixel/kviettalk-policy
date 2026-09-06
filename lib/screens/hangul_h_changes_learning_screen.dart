import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_h_changes.dart';
import '../services/tts_service.dart';
import 'hangul_h_changes_quiz_screen.dart';

class HangulHChangesLearningScreen extends StatefulWidget {
  const HangulHChangesLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulHChangesLearningScreen> createState() =>
      _HangulHChangesLearningScreenState();
}

class _HangulHChangesLearningScreenState
    extends State<HangulHChangesLearningScreen> {
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

  Future<void> _play(HangulHChangeExample example) async {
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
      appBar: AppBar(title: const Text('ㅎ 발음 변화 · Biến đổi âm ㅎ')),
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
                      'ㅎ과 만나면 거센소리',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '받침 ㅎ, ㄶ, ㅀ 뒤에 ㄱ, ㄷ, ㅈ이 오거나 '
                      'ㄱ, ㄷ, ㅂ, ㅈ 계열 받침 뒤에 ㅎ이 오면 '
                      '두 소리가 합쳐져 거센소리로 발음됩니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Khi ㅎ đứng cạnh một phụ âm phù hợp, hai âm kết hợp '
                      'và tạo thành âm bật hơi. Hãy nghe âm chuẩn thay vì đọc từng chữ.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'ㅎ + ㄱ/ㄷ/ㅈ → [ㅋ/ㅌ/ㅊ]\n'
                      'ㄱ/ㄷ/ㅂ/ㅈ + ㅎ → [ㅋ/ㅌ/ㅍ/ㅊ]',
                      key: const Key('h-changes-rules'),
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
                      '주의: 모음 앞에서는 ㅎ이 탈락해요',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '받침 ㅎ, ㄶ, ㅀ 뒤에 모음으로 시작하는 어미나 접미사가 오면 '
                      'ㅎ을 발음하지 않습니다. 놓아[노아], 많아[마ː나]처럼 들립니다.\n'
                      'Chú ý: Trước đuôi bắt đầu bằng nguyên âm, ㅎ cuối '
                      'không được phát âm, như 놓아[노아] và 많아[마ː나].',
                      key: const Key('h-deletion-note'),
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
              '스피커를 눌러 표시된 표준 발음을 들어 보세요. / '
              'Nhấn loa để nghe cách phát âm chuẩn.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            for (final example in hangulHChangeExamples) ...[
              _HChangeCard(
                example: example,
                playingWrittenForm: _playingWrittenForm,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-h-changes-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulHChangesQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('ㅎ 발음 변화 퀴즈 시작 · Bắt đầu quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HChangeCard extends StatelessWidget {
  const _HChangeCard({
    required this.example,
    required this.playingWrittenForm,
    required this.onPlay,
  });

  final HangulHChangeExample example;
  final String? playingWrittenForm;
  final Future<void> Function(HangulHChangeExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWrittenForm == example.writtenForm;
    return Card(
      key: ValueKey('h-change-${example.writtenForm}'),
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
                  key: ValueKey('h-change-audio-${example.writtenForm}'),
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
              key: ValueKey('h-change-structure-${example.writtenForm}'),
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
                key: ValueKey('h-change-pronunciation-${example.writtenForm}'),
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
