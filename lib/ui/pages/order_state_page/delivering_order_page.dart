import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:driver/ui/widgets/customer_detail.dart';
import 'package:driver/ui/widgets/order_list.dart';
import 'package:driver/ui/widgets/order_payment_detail.dart';
import 'package:driver/ui/widgets/small_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maps_launcher/maps_launcher.dart';

class DeliveringOrderPage extends HookWidget {
  final Order order;

  const DeliveringOrderPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoadingCompleting = useState<bool>(false);

    void completeOrder() async {
      _confirm(context, () async {
        isLoadingCompleting.value = true;

        await context.read(activeOrderProvider.notifier).completeOrder();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengantaran Pesanan'),
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
            SizedBox(height: 18),
            Container(
              color: ColorPallete.blueishGray,
              width: double.infinity,
              height: 20,
            ),
            Container(
              color: ColorPallete.darkGray,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Text(
                'List Pesanan',
                style: kTextTheme.headline5!.copyWith(color: Colors.white),
              ),
            ),
            OrderList(
              order: order,
              readonly: true,
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: ColorPallete.secondaryColor,
                ),
                child: isLoadingCompleting.value
                    ? SmallLoading()
                    : Text('Lihat rute tujuan'),
                onPressed: () {
                  // check order location_lat and location_lng
                  if (order.location_lat == null ||
                      order.location_lng == null) {
                    Utils.alert(context, 'Tidak dapat menampilkan rute tujuan');
                    return;
                  }

                  MapsLauncher.launchCoordinates(
                    double.tryParse(order.location_lat!) ?? 0,
                    double.tryParse(order.location_lng!) ?? 0,
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              margin: const EdgeInsets.only(bottom: 24),
              child: ElevatedButton(
                child: isLoadingCompleting.value
                    ? SmallLoading()
                    : Text('Selesai mengantar pesanan'),
                onPressed: isLoadingCompleting.value ? null : completeOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm(BuildContext context, Future Function() onConfirm) {
    Utils.prompt(
      context,
      title: 'Perhatian',
      description: 'Pastikan pemesan sudah membayar semua tagihan.',
      cancelText: 'Tidak',
      confirmText: 'Ya',
      onConfirm: onConfirm,
    );
  }
}
