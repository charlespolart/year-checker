import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final _tapPlayer = AudioPlayer();
  final _erasePlayer = AudioPlayer();

  Future<void> playTap() async {
    await _tapPlayer.stop();
    await _tapPlayer.play(AssetSource('sounds/dot-tap.mp3'));
  }

  Future<void> playErase() async {
    await _erasePlayer.stop();
    await _erasePlayer.play(AssetSource('sounds/dot-erase.mp3'));
  }
}
