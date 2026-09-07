import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/hangul_sai_siot.dart';
import '../services/tts_service.dart';
import 'hangul_sai_siot_quiz_screen.dart';

class HangulSaiSiotLearningScreen extends StatefulWidget {
  const HangulSaiSiotLearningScreen({super.key, this.speechPlayer});

  final KoreanSpeechPlayer? speechPlayer;

  @override
  State<HangulSaiSiotLearningScreen> createState() =>
      _HangulSaiSiotLearningScreenState();
}

class _HangulSaiSiotLearningScreenState
    extends State<HangulSaiSiotLearningScreen> {
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

  Future<void> _play(HangulSaiSiotExample example) async {
    if (_playingWord == example.displayWord) return;

    final shouldStopCurrent = _playingWord != null;
    final generation = ++_playGeneration;
    setState(() => _playingWord = example.displayWord);
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
      appBar: AppBar(title: const Text('사이시옷 · Phát âm 사이시옷')),
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
                      '글자 ㅅ보다 실제 소리 변화에 집중해요',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '사이시옷은 글자 그대로 항상 [ㅅ]으로 발음되지 않습니다. '
                      '뒤 자음이 된소리가 되거나 [ㄴ], [ㄴㄴ] 소리가 나타날 수 있습니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '사이시옷 không phải lúc nào cũng được đọc thành [ㅅ]. '
                      'Tùy âm đứng sau, phụ âm có thể được đọc căng hoặc xuất hiện âm [ㄴ], [ㄴㄴ].',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const _RuleCard(
              key: Key('sai-siot-rule-tensification'),
              number: '1',
              title: '뒤 자음이 된소리가 돼요',
              korean:
                  'ㄱ, ㄷ, ㅂ, ㅅ, ㅈ 앞에서는 사이시옷을 발음하지 않고 뒤 자음만 된소리로 읽는 것이 원칙입니다. '
                  '사이시옷을 받침 [ㄷ]으로 읽는 발음도 허용됩니다.',
              vietnamese:
                  'Trước ㄱ, ㄷ, ㅂ, ㅅ, ㅈ, cách đọc chính là không phát âm riêng 사이시옷 '
                  'mà đọc căng phụ âm đứng sau. Cách đọc 사이시옷 thành âm cuối [ㄷ] cũng được chấp nhận.',
            ),
            const SizedBox(height: 10),
            const _RuleCard(
              key: Key('sai-siot-rule-n-before-n-m'),
              number: '2',
              title: 'ㄴ이나 ㅁ 앞에서는 [ㄴ]으로 읽어요',
              korean:
                  '사이시옷 뒤에 ㄴ이나 ㅁ이 오면 사이시옷은 [ㄴ]으로 발음됩니다. '
                  '콧날은 [콛날]을 거쳐 [콘날]로 소리 납니다.',
              vietnamese:
                  'Khi ㄴ hoặc ㅁ đứng sau 사이시옷, 사이시옷 được phát âm thành [ㄴ]. '
                  'Ví dụ: 콧날 được đọc là [콘날].',
            ),
            const SizedBox(height: 10),
            const _RuleCard(
              key: Key('sai-siot-rule-double-n'),
              number: '3',
              title: '‘이’ 음 앞에서는 [ㄴㄴ]이 들려요',
              korean:
                  '사이시옷 뒤에 이 또는 반모음 ㅣ 소리가 결합하면 [ㄴㄴ]으로 발음합니다. '
                  '깻잎 [깬닙], 나뭇잎 [나문닙]처럼 여러 소리 변화가 최종 발음에 함께 나타납니다.',
              vietnamese:
                  'Khi âm 이 hoặc âm lướt ㅣ đứng sau 사이시옷, cách phát âm xuất hiện hai âm ㄴ. '
                  'Ví dụ: 깻잎 [깬닙], 나뭇잎 [나문닙].',
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
              '스피커를 눌러 원칙 발음을 들어 보세요. / '
              'Nhấn loa để nghe cách phát âm chính.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            for (final example in hangulSaiSiotExamples) ...[
              _SaiSiotExampleCard(
                example: example,
                playingWord: _playingWord,
                onPlay: _play,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            FilledButton.icon(
              key: const Key('start-sai-siot-quiz'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => const HangulSaiSiotQuizScreen(),
                ),
              ),
              icon: const Icon(Icons.quiz),
              label: const Text('사이시옷 퀴즈 시작 · Bắt đầu quiz'),
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
    required this.number,
    required this.title,
    required this.korean,
    required this.vietnamese,
  });

  final String number;
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
              '$number. $title',
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

class _SaiSiotExampleCard extends StatelessWidget {
  const _SaiSiotExampleCard({
    required this.example,
    required this.playingWord,
    required this.onPlay,
  });

  final HangulSaiSiotExample example;
  final String? playingWord;
  final Future<void> Function(HangulSaiSiotExample example) onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlaying = playingWord == example.displayWord;
    return Card(
      key: ValueKey('sai-siot-${example.displayWord}'),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    example.displayWord,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  key: ValueKey('sai-siot-audio-${example.displayWord}'),
                  tooltip: '듣기 · Nghe ${example.displayWord}',
                  onPressed: isPlaying ? null : () => onPlay(example),
                  icon: Icon(
                    isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
                    color: isPlaying ? colorScheme.primary : null,
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '원칙 발음 · Cách đọc chính',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    '[${example.pronunciation}]',
                    key: ValueKey(
                      'sai-siot-pronunciation-${example.displayWord}',
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (example.allowedPronunciation case final allowed?) ...[
                    const SizedBox(height: 5),
                    Text(
                      '허용 발음 · Cách đọc được chấp nhận: [$allowed]',
                      key: ValueKey(
                        'sai-siot-allowed-${example.displayWord}',
                      ),
                      style: TextStyle(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 5),
                  Text(
                    '학습자 표시 · Cách đọc dễ nhìn: [${example.learnerPronunciation}]',
                    style: TextStyle(color: colorScheme.onSecondaryContainer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              key: ValueKey('sai-siot-process-${example.displayWord}'),
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
