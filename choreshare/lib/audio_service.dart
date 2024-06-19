import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();

  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  Future<void> playBackgroundMusic() async {
    _audioPlayer = AudioPlayer();

    _audioPlayer.setReleaseMode(ReleaseMode.LOOP); // Reproducción en bucle

    int result = await _audioPlayer.play('assets/background.mp3', isLocal: true);

    if (result == 1) {
      _isPlaying = true;
    } else {
      print('Error al reproducir audio');
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }
}
