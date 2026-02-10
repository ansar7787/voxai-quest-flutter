import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();
  bool _isSttInitialized = false;

  SpeechService() {
    _initTts();
  }

  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5); // Better for learners
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    await _stt.stop();
  }

  Future<bool> initializeStt() async {
    if (_isSttInitialized) return true;

    var status = await Permission.microphone.request();
    if (status.isDenied) return false;

    _isSttInitialized = await _stt.initialize(
      onError: (val) => print('STT Error: $val'),
      onStatus: (val) => print('STT Status: $val'),
    );
    return _isSttInitialized;
  }

  void listen({
    required Function(String) onResult,
    required VoidCallback onDone,
  }) async {
    if (!_isSttInitialized) {
      bool ok = await initializeStt();
      if (!ok) return;
    }

    await _stt.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      cancelOnError: true,
      partialResults: true,
      listenMode: ListenMode.confirmation,
    );
  }

  bool get isListening => _stt.isListening;

  double get lastSoundLevel => _stt.lastSoundLevel;
}

typedef VoidCallback = void Function();
