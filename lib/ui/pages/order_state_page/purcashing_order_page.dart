import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:driver/ui/widgets/customer_detail.dart';
import 'package:driver/ui/widgets/order_checklist_item.dart';
import 'package:driver/ui/widgets/order_payment_detail.dart';
import 'package:driver/ui/widgets/order_stall_header.dart';
import 'package:driver/ui/widgets/small_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PurcashingOrderPage extends HookWidget {
  final Order order;

  const PurcashingOrderPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);

    void completePurcashe() {
      _confirmReadyToDeliver(context, () async {
        isLoading.value = true;

        await context.read(activeOrderProvider.notifier).deliverOrder();

        isLoading.value = false;
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
            SizedBox(
              height: 20,
            ),
            OrderStallHeader(),
            OrderChecklistItem(),
            Container(
              width: double.infinity,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              margin: const EdgeInsets.only(bottom: 24),
              child: ElevatedButton(
                child: isLoading.value
                    ? SmallLoading()
                    : Text('Selesai Membeli Pesanan'),
                onPressed: isLoading.value ? null : completePurcashe,
              ),
            ),
          ],
        ),
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
