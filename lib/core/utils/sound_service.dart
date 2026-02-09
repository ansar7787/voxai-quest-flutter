import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  void setMuted(bool muted) {
    _isMuted = muted;
  }

  Future<void> playCorrect() async {
    if (_isMuted) return;
    await _player.stop();
    await _player.setSource(AssetSource('sounds/correct.mp3'));
    await _player.resume();
  }

  Future<void> playWrong() async {
    if (_isMuted) return;
    await _player.stop();
    await _player.setSource(AssetSource('sounds/wrong.mp3'));
    await _player.resume();
  }

  Future<void> playLevelComplete() async {
    if (_isMuted) return;
    await _player.stop();
    await _player.setSource(AssetSource('sounds/level_complete.mp3'));
    await _player.resume();
  }
}
