import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_nasalization.dart';
import '../services/tts_service.dart';
import 'hangul_nasalization_quiz_screen.dart';

class HangulNasalizationLearningScreen extends StatefulWidget {
  const HangulNasalizationLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulNasalizationLearningScreen> createState() =>
      _HangulNasalizationLearningScreenState();
}

class _HangulNasalizationLearningScreenState
    extends State<HangulNasalizationLearningScreen> {
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

  Future<void> _play(HangulNasalizationExample example) async {
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
      appBar: AppBar(title: const Text('비음화 · Biến âm mũi')),
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
                      'ㄱ·ㄷ·ㅂ 계열 + ㄴ/ㅁ → ㅇ·ㄴ·ㅁ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '받침의 ㄱ, ㄷ, ㅂ 계열 소리가 뒤의 비음 ㄴ 또는 ㅁ을 만나면 '
                      '각각 [ㅇ], [ㄴ], [ㅁ]으로 바뀌어 발음됩니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Khi âm cuối thuộc nhóm ㄱ, ㄷ, ㅂ gặp phụ âm mũi ㄴ hoặc '
                      'ㅁ phía sau, chúng lần lượt đổi thành [ㅇ], [ㄴ], [ㅁ].',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'ㄱ 계열 + ㄴ/ㅁ → [ㅇ]\n'
                      'ㄷ 계열 + ㄴ/ㅁ → [ㄴ]\n'
                      'ㅂ 계열 + ㄴ/ㅁ → [ㅁ]',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '국 + 물 → [궁물]   ·   밥 + 물 → [밤물]',
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
                  '팁: 철자에 ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅍ이 보여도 받침에서는 '
                  '[ㄷ] 또는 [ㅂ] 계열 소리가 될 수 있습니다. 먼저 뒤에 ㄴ/ㅁ이 '
                  '오는지 확인하고 실제 발음을 함께 익히세요.\n'
                  'Mẹo: Một số 받침 được viết là ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅍ nhưng '
                  'có thể thuộc nhóm âm [ㄷ] hoặc [ㅂ]. Hãy kiểm tra xem phía '
                  'sau có ㄴ/ㅁ hay không và học cùng cách phát âm thực tế.',
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
            for (final example in hangulNasalizationExamples) ...[
              _NasalizationCard(
                example: example,
                playingWrittenForm: _playingWrittenForm,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-nasalization-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulNasalizationQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('비음화 퀴즈 시작 · Bắt đầu quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NasalizationCard extends StatelessWidget {
  const _NasalizationCard({
    required this.example,
    required this.playingWrittenForm,
    required this.onPlay,
  });

  final HangulNasalizationExample example;
  final String? playingWrittenForm;
  final Future<void> Function(HangulNasalizationExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWrittenForm == example.writtenForm;
    return Card(
      key: ValueKey('nasalization-${example.writtenForm}'),
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
                  key: ValueKey('nasalization-audio-${example.writtenForm}'),
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
              key: ValueKey('nasalization-structure-${example.writtenForm}'),
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
                  'nasalization-pronunciation-${example.writtenForm}',
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
                '받침 ${example.finalConsonantFamily} → ${example.nasalConsonant}',
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
