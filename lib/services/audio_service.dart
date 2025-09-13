import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  // Método estático para reproducir sonido
  static Future<void> playSound(String assetPath) async {
    try {
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      print('Error reproduciendo sonido: $e');
    }
  }
}
