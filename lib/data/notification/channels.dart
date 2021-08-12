import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannels {
  NotificationChannels._();

  static const AndroidNotificationChannel defaultChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  static const AndroidNotificationDetails chat = AndroidNotificationDetails(
    'chat',
    'Chat',
    'Notifikasi chat  pelanggan',
    importance: Importance.max,
    priority: Priority.max,
    enableLights: true,
    styleInformation: BigTextStyleInformation(''),
  );
}
