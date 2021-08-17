import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  static AudioCache player = AudioCache(prefix: 'assets/audio/');

  static Future<AudioPlayer> playNewOrderNotification() {
    return player.play('new_order_notification.mp3');
  }
}
