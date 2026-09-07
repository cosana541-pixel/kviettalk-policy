import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_rieul_nasalization.dart';
import '../services/tts_service.dart';
import 'hangul_rieul_nasalization_quiz_screen.dart';

class HangulRieulNasalizationLearningScreen extends StatefulWidget {
  const HangulRieulNasalizationLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulRieulNasalizationLearningScreen> createState() =>
      _HangulRieulNasalizationLearningScreenState();
}

class _HangulRieulNasalizationLearningScreenState
    extends State<HangulRieulNasalizationLearningScreen> {
  KoreanSpeechPlayer? _speechPlayer;
  String? _playingWord;
  int _playGeneration = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _speechPlayer ??= widget.speechPlayer ?? context.read<TtsService>();
  }

  @override
  void dispose() {
    _playGeneration++;
    final speechPlayer = _speechPlayer;
    if (speechPlayer != null) unawaited(speechPlayer.stop());
    super.dispose();
  }

  Future<void> _play(HangulRieulNasalizationExample example) async {
    if (_playingWord == example.writtenForm) return;
    final shouldStopCurrent = _playingWord != null;
    final generation = ++_playGeneration;
    setState(() => _playingWord = example.writtenForm);
    try {
      if (shouldStopCurrent) await _speechPlayer!.stop();
      if (!mounted || generation != _playGeneration) return;
      await _speechPlayer!.speakKorean(example.ttsText);
    } finally {
      if (mounted && generation == _playGeneration) {
        setState(() => _playingWord = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('ㄹ의 비음화 · Mũi hóa ㄹ')),
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
                      '표준 발음법 제19항 · ㄹ → [ㄴ]',
                      key: const Key('rieul-nasalization-main-rule'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '받침 ㅁ, ㅇ 뒤에 연결되는 ㄹ은 [ㄴ]으로 발음합니다. '
                      '기존 비음화 단원의 ㄱ·ㄷ·ㅂ 계열 + ㄴ/ㅁ 규칙과 달리, 여기서는 뒤의 ㄹ이 먼저 바뀝니다.',
                      style: TextStyle(color: colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Khi ㄹ đứng sau 받침 ㅁ hoặc ㅇ, ㄹ được đọc thành [ㄴ]. '
                      'Khác với bài biến âm mũi cơ bản, chính ㄹ phía sau là âm thay đổi trước.',
                      style: TextStyle(color: colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            _RuleCard(
              key: const Key('rieul-nasalization-chain-rule'),
              title: '연쇄 변화 · Biến đổi liên tiếp',
              korean:
                  'ㄱ, ㅂ 계열 받침 뒤에서는 ㄹ이 먼저 [ㄴ]으로 바뀝니다. '
                  '그 뒤 새로 생긴 ㄴ의 영향으로 앞 받침도 ㄱ→ㅇ, ㅂ→ㅁ으로 비음화됩니다. '
                  '막론 → 막논 → [망논], 협력 → 협녁 → [혐녁] 순서입니다.',
              vietnamese:
                  'Sau 받침 thuộc nhóm ㄱ hoặc ㅂ, ㄹ đổi thành [ㄴ] trước. '
                  'Âm ㄴ mới xuất hiện tiếp tục làm âm cuối phía trước đổi thành âm mũi: '
                  'ㄱ→ㅇ, ㅂ→ㅁ. Vì vậy cần theo đúng thứ tự của từng bước.',
            ),
            const SizedBox(height: 10),
            _RuleCard(
              key: const Key('rieul-nasalization-comparison'),
              title: '유음화와 비교 · So sánh với biến âm ㄹ',
              korean: hangulRieulNasalizationComparisonKorean,
              vietnamese: hangulRieulNasalizationComparisonVietnamese,
            ),
            const SizedBox(height: 18),
            Text(
              '표준 발음 예시 · Ví dụ phát âm chuẩn',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '변화 순서를 확인하고 스피커로 최종 발음을 들어 보세요. / '
              'Xem thứ tự biến đổi rồi nhấn loa để nghe cách đọc cuối cùng.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            for (final example in hangulRieulNasalizationExamples) ...[
              _ExampleCard(
                example: example,
                playingWord: _playingWord,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-rieul-nasalization-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulRieulNasalizationQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('ㄹ의 비음화 퀴즈 시작 · Bắt đầu quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    super.key,
    required this.title,
    required this.korean,
    required this.vietnamese,
  });

  final String title;
  final String korean;
  final String vietnamese;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              korean,
              style: TextStyle(color: colorScheme.onTertiaryContainer),
            ),
            const SizedBox(height: 6),
            Text(
              vietnamese,
              style: TextStyle(color: colorScheme.onTertiaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.example,
    required this.playingWord,
    required this.onPlay,
  });

  final HangulRieulNasalizationExample example;
  final String? playingWord;
  final Future<void> Function(HangulRieulNasalizationExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWord == example.writtenForm;
    final typeLabel =
        example.ruleType == HangulRieulNasalizationRuleType.chained
        ? '연쇄 비음화 · Biến đổi liên tiếp'
        : 'ㄹ → [ㄴ]';
    return Card(
      key: ValueKey('rieul-nasalization-${example.writtenForm}'),
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
                  key: ValueKey(
                    'rieul-nasalization-audio-${example.writtenForm}',
                  ),
                  tooltip: '듣기 · Nghe ${example.writtenForm}',
                  onPressed: isPlaying ? null : () => onPlay(example),
                  icon: Icon(
                    isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
                    color: isPlaying ? colorScheme.primary : null,
                  ),
                ),
              ],
            ),
            Chip(visualDensity: VisualDensity.compact, label: Text(typeLabel)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '[${example.pronunciation}]',
                key: ValueKey(
                  'rieul-nasalization-pronunciation-${example.writtenForm}',
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              key: ValueKey(
                'rieul-nasalization-process-${example.writtenForm}',
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                example.changeProcess,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
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
