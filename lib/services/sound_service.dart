import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;

  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playDTMFTone(String digit) async {
    String audioAsset = 'sounds/dtmf_$digit.wav';
    await _audioPlayer.play(AssetSource(audioAsset));
  }
}
