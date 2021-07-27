import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/firebase_provider.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:driver/ui/pages/order_state_page/delivering_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'order_state_page/purcashing_order_page.dart';

class OrderPage extends HookWidget {
  static String route = 'driver/order';

  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeOrder = useProvider(activeOrderProvider);

    late Widget pageState;

    switch (activeOrder?.status) {
      case OrderStatus.delivering:
        pageState = DeliveringOrderPage(order: activeOrder!);
        break;
      case OrderStatus.purchasing:
        pageState = PurcashingOrderPage(order: activeOrder!);
        break;
      default:
        pageState = _buildWrongOrderStatus(activeOrder);
    }

    return ProviderListener(
      provider: activeOrderErrorProvider,
      onChange: (context, StateController<CustomException?> exception) {
        if (exception.state != null) {
          Utils.alert(
            context,
            exception.state!.message ??
                'Terjadi  kesalahan yang tidak diketahui',
          );

          context.read(crashlyticsProvider).recordError(
                exception.state,
                exception.state?.stackTrace,
              );
        }
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        child: pageState,
      ),
    );
  }

  Scaffold _buildWrongOrderStatus(Order? activeOrder) {
    return Scaffold(
      body: Container(
        color: ColorPallete.backgroundColor,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Text(
          'Tipe Order (${activeOrder?.id}) tidak diketahui (${activeOrder?.status}), harap laporkan ke developer',
        ),
      ),
    );
  }
}
