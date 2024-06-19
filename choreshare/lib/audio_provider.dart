import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  AudioProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setAsset('assets/background.mp3');
      await _player.setLoopMode(LoopMode.one);
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  Future<void> startPlaying() async {
    if (!_isPlaying) {
      try {
        await _player.play();
        _isPlaying = true;
        notifyListeners();
      } catch (e) {
        print('Error starting audio playback: $e');
      }
    }
  }

  Future<void> stopPlaying() async {
    if (_isPlaying) {
      try {
        await _player.stop();
        _isPlaying = false;
        notifyListeners();
      } catch (e) {
        print('Error stopping audio playback: $e');
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
