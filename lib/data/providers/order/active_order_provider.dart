import 'package:diiket_models/all.dart';
import 'package:driver/data/network/order_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final activeOrderErrorProvider = StateProvider<CustomException?>((ref) {
  return null;
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
    } catch (e) {
      _read(activeOrderErrorProvider).state = e as CustomException;
    }
  }

  Future<void> claimOrder(Order order) async {
    if (order.id == null) return;

    try {
      await _read(orderServiceProvider).claimOrder(order.id!);
      await fetchActiveOrder();
    } catch (e) {
      _read(activeOrderErrorProvider).state = e as CustomException;
    }
  }

  Future<void> deliverOrder() async {
    try {
      await _read(orderServiceProvider).deliverOrder();
      await fetchActiveOrder();
    } catch (e) {
      _read(activeOrderErrorProvider).state = e as CustomException;
    }
  }

  Future<void> completeOrder() async {
    try {
      await _read(orderServiceProvider).completeOrder();
      await fetchActiveOrder();
    } catch (e) {
      _read(activeOrderErrorProvider).state = e as CustomException;
    }
  }
}
