import 'package:audioplayers/audioplayers.dart';

class AudioController {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  Future<void> playBackground() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('audio/background.mp3'));
    isPlaying = true;
  }

  void toggle() {
    if (isPlaying) {
      _player.pause();
    } else {
      _player.resume();
    }
    isPlaying = !isPlaying;
  }

  void stop() {
    _player.stop();
    isPlaying = false;
  }
}
