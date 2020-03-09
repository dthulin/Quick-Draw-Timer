import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioController {
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  void playFile(String fileName) async {
    await this.audioPlayer.stop();
    this.audioPlayer = await this.audioCache.play('audio/' + fileName + '.wav');
  }

  void playFileLoop(String fileName) async {
    await this.audioPlayer.stop();
    this.audioPlayer = await this.audioCache.loop('audio/' + fileName + '.wav');
  }

  void stop() async {
    await this.audioPlayer.stop();
  }
}
