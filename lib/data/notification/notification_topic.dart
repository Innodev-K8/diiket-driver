import 'package:diiket_models/all.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> subscribeToMarketDriverNotificationTopic(User? driver) async {
  final int? marketId = driver?.driver_detail?.market_id;

  if (marketId == null) return;

  print('Subscribing to ' + 'market-$marketId.driver');

  return FirebaseMessaging.instance.subscribeToTopic('market-$marketId.driver');
}

Future<void> unSubscribeToMarketDriverNotificationTopic(User? driver) async {
  final int? marketId = driver?.driver_detail?.market_id;

  if (marketId == null) return;

  print('Unubscribing to ' + 'market-$marketId.driver');

  return FirebaseMessaging.instance
      .unsubscribeFromTopic('market-$marketId.driver');
}
