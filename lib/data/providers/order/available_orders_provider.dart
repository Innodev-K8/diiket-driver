import 'dart:async';
import 'dart:convert';

import 'package:diiket_models/all.dart';
import 'package:driver/data/network/order_service.dart';
import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:driver/data/providers/pusher_provider.dart';
import 'package:driver/helpers/casting_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pusher_client/pusher_client.dart';

final availableOrdersProvider =
    StateNotifierProvider<AvailableOrdersNotifier, AsyncValue<List<Order>>>(
        (ref) {
  return AvailableOrdersNotifier(ref.read);
});

final availableOrderEventsProvider = StateProvider<String?>((ref) {
  return null;
});

class AvailableOrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  Reader _read;

  Channel? _channel;

  AvailableOrdersNotifier(this._read) : super(AsyncValue.loading()) {
    _read(authProvider.notifier).addListener((User? user) {
      if (user?.driver_detail?.market_id != null) {
        initPusher(user!.driver_detail!.market_id!);
      }
    });

    fetchAvailableOrders();
  }

  Future<void> initPusher(int marketId) async {
    await _read(pusherProvider).connect();

    PusherClient pusher = _read(pusherProvider);

    _channel = pusher.subscribe('market.$marketId.orders');

    await bindEvents();
  }

  Future<void> bindEvents() async {
    if (_channel == null) return;

    await Future.wait([
      _channel!.bind('order-created', _onNewOrder),
      _channel!.bind('order-canceled', _onOrderCanceled),
      _channel!.bind('order-claimed', _onOrderCanceled),
    ]);
  }

  // call this if we doesn't want to listen to events anymore
  Future<void> unbindEvents() async {
    if (_channel == null) return;

    await Future.wait([
      _channel!.unbind('order-created'),
      _channel!.unbind('order-canceled'),
      _channel!.unbind('order-claimed'),
    ]);
  }

  @override
  void dispose() {
    unbindEvents();
    super.dispose();
  }

  Future<void> fetchAvailableOrders() async {
    try {
      state = AsyncValue.data(
        await _read(orderServiceProvider).getAvailableOrders(),
      );
    } catch (e) {}
  }

  void addOrderToList(Order order) {
    final currentOrders = state.data?.value ?? [];

    state = AsyncValue.data(
      currentOrders..add(order),
    );

    _read(availableOrderEventsProvider).state = 'Terdapat pesanan baru!';
  }

  void removeOrderFromList(Order order) {
    final currentOrders = state.data?.value ?? [];

    state = AsyncValue.data(
      currentOrders..removeWhere((o) => o.id == order.id),
    );
  }

  // events to bind on
  void _onNewOrder(event) {
    final dynamic response = jsonDecode(event?.data ?? '');

    if (response['order'] == null) return;

    final Order order = Order.fromJson(
      castOrFallback(response['order'], {}),
    );

    addOrderToList(order);
  }

  void _onOrderCanceled(event) {
    final dynamic response = jsonDecode(event?.data ?? '');

    if (response['order'] == null) return;

    final Order order = Order.fromJson(
      castOrFallback(response['order'], {}),
    );

    removeOrderFromList(order);
  }
}
