import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  /// Reproduce un sonido desde assets
  static Future<void> playSound(String assetPath) async {
    try {
      // Detener audio previo antes de reproducir uno nuevo
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      print('Error reproduciendo sonido: $e');
    }
  }

  /// Detiene el audio actualmente en reproducción
  static Future<void> stopSound() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error deteniendo el sonido: $e');
    }
  }
}
