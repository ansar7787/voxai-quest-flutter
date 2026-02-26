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

  Future<void> playLevelComplete() async {
    if (_isMuted) return;
    try {
      if (_player.state == PlayerState.playing) await _player.stop();
      // Try playing level_complete.mp3, fallback to correct.mp3 if fails
      try {
        await _player.setSource(AssetSource('sounds/level_complete.mp3'));
        await _player.resume();
      } catch (e) {
        debugPrint('level_complete.mp3 not found, falling back to correct.mp3');
        await playCorrect();
      }
    } catch (e) {
      debugPrint('Error playing sound (level_complete): $e');
    }
  }
}
