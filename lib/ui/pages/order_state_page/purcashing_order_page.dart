import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:driver/ui/widgets/customer_detail.dart';
import 'package:driver/ui/widgets/order_checklist_item.dart';
import 'package:driver/ui/widgets/order_payment_detail.dart';
import 'package:driver/ui/widgets/order_stall_header.dart';
import 'package:driver/ui/widgets/small_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StallOrder {
  final Stall? stall;
  final List<OrderItem>? items;

  StallOrder({this.stall, this.items});
}

class PurcashingOrderPage extends HookWidget {
  final Order order;

  const PurcashingOrderPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final isMounted = useIsMounted();

    void cancelOrder() {
      _confirmCancelOrder(context, () async {
        isLoading.value = true;

        await context.read(activeOrderProvider.notifier).cancelOrder();

        if (isMounted()) isLoading.value = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengambilan Pesanan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: CustomerDetail(order: order),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
              child: OrderPaymentDetail(order: order),
            ),
            SizedBox(height: 20),
            GroupedListView<OrderItem, Stall>(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              elements: order.order_items ?? [],
              groupBy: (item) => item.product!.stall!,
              groupComparator: (a, b) => 0,
              groupSeparatorBuilder: (Stall stall) =>
                  OrderStallHeader(stall: stall),
              separator: Divider(),
              itemBuilder: (context, item) => OrderChecklistItem(
                orderItem: item,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: ColorPallete.errorColor,
                ),
                child:
                    isLoading.value ? SmallLoading() : Text('Batalkan Pesanan'),
                onPressed: isLoading.value ? null : cancelOrder,
              ),
            ),
            SizedBox(height: 8),
            DonePurchasingButton(isLoading: isLoading),
          ],
        ),
      ),
    );
  }

  void _confirmCancelOrder(BuildContext context, Future Function() onConfirm) {
    Utils.prompt(
      context,
      title: 'Perhatian',
      description: 'Apa Anda yakin ingin membatalkan pesanan ini?.',
      cancelText: 'Tidak',
      confirmText: 'Ya',
      onConfirm: onConfirm,
    );
  }
}

class DonePurchasingButton extends HookWidget {
  const DonePurchasingButton({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  final ValueNotifier<bool> isLoading;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final isMounted = useIsMounted();

    // disable the button if every order items are not checked
    final isChecked = useProvider(activeOrderProvider.notifier).isChecked;

    void completePurcashe() {
      _confirmReadyToDeliver(context, () async {
        if (isMounted()) isLoading.value = true;

        await context.read(activeOrderProvider.notifier).deliverOrder();

        if (isMounted()) isLoading.value = false;
      });
    }

    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.only(bottom: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: ColorPallete.primaryColor,
          onSurface: ColorPallete.darkGray,
        ),
        child:
            isLoading.value ? SmallLoading()
            : Text('Selesai Membeli Barang'),
        onPressed: isLoading.value || !isChecked ? null : completePurcashe,
      ),
    );
  }

  void _confirmReadyToDeliver(
    BuildContext context,
    Future Function() onConfirm,
  ) {
    Utils.prompt(
      context,
      title: 'Perhatian',
      description:
          'Pastikan barang pesanan sudah berada di tangan dan siap diantar.',
      cancelText: 'Tidak',
      confirmText: 'Ya',
      onConfirm: onConfirm,
    );
  }
}
