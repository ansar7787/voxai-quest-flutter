import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  SoundService() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _isMuted = !(prefs.getBool('sound_enabled') ?? true);
  }

  void setMuted(bool muted) {
    _isMuted = muted;
  }

  Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (e) {
      debugPrint('Error disposing audio player: $e');
    }
  }

  Future<void> playCorrect() async {
    if (_isMuted) return;
    try {
      if (_player.state == PlayerState.playing) await _player.stop();
      await _player.setSource(AssetSource('sounds/correct.mp3'));
      await _player.resume();
    } catch (e) {
      debugPrint('Error playing sound (correct): $e');
    }
  }

  Future<void> playWrong() async {
    if (_isMuted) return;
    try {
      if (_player.state == PlayerState.playing) await _player.stop();
      await _player.setSource(AssetSource('sounds/wrong.mp3'));
      await _player.resume();
    } catch (e) {
      debugPrint('Error playing sound (wrong): $e');
    }
  }

  Future<void> playClick() async {
    if (_isMuted) return;
    try {
      if (_player.state == PlayerState.playing) await _player.stop();
      await _player.setSource(
        AssetSource('sounds/correct.mp3'),
      ); // Using correct.mp3 as a generic click for now
      await _player.resume();
    } catch (e) {
      debugPrint('Error playing sound (click): $e');
    }
  }

  Future<void> playHint() async {
    if (_isMuted) return;
    try {
      if (_player.state == PlayerState.playing) await _player.stop();
      await _player.setSource(AssetSource('sounds/hint.mp3'));
      await _player.resume();
    } catch (e) {
      debugPrint('Error playing sound (hint): $e');
    }
  }

  Future<void> playLevelComplete() async {
    if (_isMuted) return;
    try {
      if (_player.state == PlayerState.playing) await _player.stop();
      await _player.setSource(AssetSource('sounds/level_completed.mp3'));
      await _player.resume();
    } catch (e) {
      debugPrint('Error playing sound (level_completed): $e');
      // Fallback
      await playCorrect();
    }
  }
}
