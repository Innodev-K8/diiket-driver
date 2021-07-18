import 'dart:async';
import 'dart:convert';

import 'package:diiket_models/all.dart';
import 'package:driver/data/network/order_service.dart';
import 'package:driver/data/providers/pusher_provider.dart';
import 'package:driver/helpers/casting_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pusher_client/pusher_client.dart';

final availableOrdersProvider =
    StateNotifierProvider<AvailableOrdersNotifier, AsyncValue<List<Order>>>(
        (ref) {
  ref.watch(pusherProvider);

  return AvailableOrdersNotifier(ref.read);
});

final availableOrderEventsProvider = StateProvider<String?>((ref) {
  return null;
});

class AvailableOrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  Reader _read;

  Channel? _channel;

  AvailableOrdersNotifier(this._read) : super(AsyncValue.loading()) {
    initPusher();

    fetchAvailableOrders();
  }
  Future<void> initPusher() async {
    await _read(pusherProvider).connect();

    PusherClient pusher = _read(pusherProvider);

    _channel = pusher.subscribe('orders');

    _channel!.bind('order-created', _onNewOrder);
    _channel!.bind('order-canceled', _onOrderCanceled);
    _channel!.bind('order-claimed', _onOrderCanceled);
  }

  @override
  void dispose() {
    _channel?.cancelEventChannelStream();
    super.dispose();
  }

  void _onNewOrder(event) {
    final dynamic response = jsonDecode(event?.data ?? '');

    if (response['order'] == null) return;

    final Order order = Order.fromJson(
      castOrFallback(response['order'], {}),
    );

    final currentOrders = state.data?.value ?? [];

    state = AsyncValue.data(
      currentOrders..add(order),
    );

    _read(availableOrderEventsProvider).state = 'Terdapat orderan  baru!';
  }

  void _onOrderCanceled(event) {
    final dynamic response = jsonDecode(event?.data ?? '');

    if (response['order'] == null) return;

    final Order order = Order.fromJson(
      castOrFallback(response['order'], {}),
    );

    final currentOrders = state.data?.value ?? [];

    state = AsyncValue.data(
      currentOrders..removeWhere((o) => o.id == order.id),
    );

    _read(availableOrderEventsProvider).state = 'Terdapat orderan dibatalkan!';
  }

  Future<void> fetchAvailableOrders() async {
    try {
      state = AsyncValue.data(
        await _read(orderServiceProvider).getAvailableOrders(),
      );
    } catch (e) {}
  }
}
