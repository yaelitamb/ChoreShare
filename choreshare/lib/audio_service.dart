import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  late AudioPlayer _audioPlayer;

  AudioService._internal() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);  // Uso correcto de ReleaseMode
  }

  Future<void> playBackgroundMusic() async {
    await _audioPlayer.play(AssetSource('assets/background.mp3'));
  }

  Future<void> stopBackgroundMusic() async {
    await _audioPlayer.stop();
  }
}
