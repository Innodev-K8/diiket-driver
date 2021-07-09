import 'package:diiket_models/all.dart';
import 'package:driver/data/network/order_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final availableOrdersProvider =
    StateNotifierProvider<AvailableOrdersNotifier, AsyncValue<List<Order>>>(
        (ref) {
  return AvailableOrdersNotifier(ref.read);
});

class AvailableOrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  Reader _read;

  AvailableOrdersNotifier(this._read) : super(AsyncValue.loading()) {
    fetchAvailableOrders();
  }

  Future<void> fetchAvailableOrders() async {
    try {
      state = AsyncValue.data(
        await _read(orderServiceProvider).getAvailableOrders(),
      );
    } catch (e) {}
  }
}
