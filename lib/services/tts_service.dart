import 'package:flutter_tts/flutter_tts.dart';

abstract interface class KoreanSpeechPlayer {
  Future<void> speakKorean(String text);

  Future<void> stop();
}

// TTS 관련 코드를 화면에서 분리했습니다.
// 화면은 "읽어줘"만 요청하고, 실제 설정은 이 클래스가 담당합니다.
class TtsService implements KoreanSpeechPlayer {
  TtsService() {
    _initialization = _initializeTts();
  }

  static const String _koreanLanguageCode = 'ko-KR';
  final FlutterTts _tts = FlutterTts();
  late final Future<void> _initialization;

  Future<void> _initializeTts() async {
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  @override
  Future<void> speakKorean(String text) async {
    // 한국어 TTS는 실제 한국어 텍스트를 ko-KR 음성으로 읽습니다.
    await _initialization;
    await _tts.stop();
    await _tts.setLanguage(_koreanLanguageCode);
    await _tts.speak(text);
  }

  Future<void> speakVietnamese(String text) async {
    // API는 남겨 두지만 현재 앱 UI에서는 베트남어 TTS를 사용하지 않습니다.
    return;
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}
