import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ActiveOrderWrapper extends HookWidget {
  final Widget Function(Order)? onHaveActiveOrder;
  final Widget Function()? onFree;

  final bool isAnimated;
  final bool showLoading;

  ActiveOrderWrapper({
    this.onHaveActiveOrder,
    this.onFree,
    this.isAnimated = true,
    this.showLoading = false,
  });

  Widget build(BuildContext context) {
    final Order? order = useProvider(activeOrderProvider);
    final bool isLoading = useProvider(activeOrderLoadingProvider).state;

    if (showLoading && isLoading)
      return Container(
        alignment: Alignment.center,
        color: ColorPallete.backgroundColor,
        child: CircularProgressIndicator(),
      );

    Widget child = order == null
        ? (onFree?.call() ?? SizedBox.shrink())
        : (onHaveActiveOrder?.call(order) ?? SizedBox.shrink());

    if (!isAnimated) {
      return ProviderListener(
        provider: activeOrderErrorProvider,
        onChange: _onError,
        child: child,
      );
    }

    return ProviderListener(
      provider: activeOrderErrorProvider,
      onChange: _onError,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: child,
      ),
    );
  }

  void _onError(context, StateController<CustomException?> exception) {
    if (exception.state != null) {
      Utils.alert(
        context,
        exception.state!.message ?? 'Terjadi kesalahan yang tidak diketahui.',
      );
    }
  }
}
