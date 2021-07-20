import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pusher_client/pusher_client.dart';

final pusherProvider = Provider<PusherClient>((ref) {
  // final String key =
  //     kReleaseMode ? '4144774926a400dddc07' : 'd244fbd9f96cbf4f69ba';
  final String key = '4144774926a400dddc07';

  final PusherOptions options = PusherOptions(cluster: 'ap1');

  final PusherClient client = PusherClient(
    key,
    options,
  );

  client.onConnectionStateChange((state) {
    print(
        "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
  });

  client.onConnectionError((error) {
    print("error: ${error?.message}");
  });

  return client;
});
