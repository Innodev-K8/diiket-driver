import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'channels.dart';

class NotificationService {
  static NotificationService? _notificationService;

  factory NotificationService() {
    return _notificationService ?? NotificationService._();
  }

  late FlutterLocalNotificationsPlugin instance;

  NotificationService._() {
    instance = FlutterLocalNotificationsPlugin();
  }

  Future<bool?> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await instance
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationChannels.defaultChannel);

    return instance.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {},
    );
  }
}
