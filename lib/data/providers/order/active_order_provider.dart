import 'package:diiket_models/all.dart';
import 'package:driver/data/network/order_service.dart';
import 'package:driver/data/providers/order/available_orders_provider.dart';
import 'package:driver/data/providers/order/chat/chat_channel_provider.dart';
import 'package:driver/helpers/casting_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final activeOrderErrorProvider = StateProvider<CustomException?>((ref) {
  return null;
});

final activeOrderLoadingProvider = StateProvider<bool>((ref) {
  return true;
});

final activeOrderProvider =
    StateNotifierProvider<ActiveOrderNotifier, Order?>((ref) {
  return ActiveOrderNotifier(ref.read);
});

class ActiveOrderNotifier extends StateNotifier<Order?> {
  Reader _read;

  ActiveOrderNotifier(this._read) : super(null) {
    fetchActiveOrder();
  }

  Future<void> fetchActiveOrder() async {
    try {
      state = await _read(orderServiceProvider).getActiveOrder();


      // make sure to disconnect from pusher when we have active order
      if (state != null) {
        _read(availableOrdersProvider.notifier).disconnectFromPusher();
      }
    } catch (exception) {
      _read(activeOrderErrorProvider).state = castOrFallback(
        exception,
        CustomException(
          message: exception.toString(),
        ),
      );
    } finally {
      _read(activeOrderLoadingProvider).state = false;
    }
  }

  Future<void> claimOrder(Order order) async {
    if (order.id == null) return;

    try {
      await _read(orderServiceProvider).claimOrder(order.id!);
      await fetchActiveOrder();

      _read(availableOrdersProvider.notifier).disconnectFromPusher();
      _read(availableOrdersProvider.notifier).removeOrderFromList(order);
    } catch (exception) {
      _read(activeOrderErrorProvider).state = exception as CustomException;
    }
  }

  Future<void> deliverOrder() async {
    try {
      await _read(orderServiceProvider).deliverOrder();
      await fetchActiveOrder();
    } catch (exception) {
      _read(activeOrderErrorProvider).state = exception as CustomException;
    }
  }

  Future<void> completeOrder() async {
    try {
      await _read(orderServiceProvider).completeOrder();
      await _read(orderChatChannelProvider.notifier).disconnect();
      
      // we know if this code is excecuted, completeOrder was successfuly executed
      state = null;

      // get fresh available orders and
      // reconnect to pusher if we done with current order
      await _read(availableOrdersProvider.notifier).fetchAvailableOrders();
      await _read(availableOrdersProvider.notifier).connectToPusher();
    } catch (e) {
      _read(activeOrderErrorProvider).state = e as CustomException;
    }
  }
}
