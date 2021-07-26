import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:driver/ui/pages/chat/chat_driver_button.dart';
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
    final isMounted = useIsMounted();

    void completePurchase() {
      _confirmComplete(context, () async {
        isLoading.value = true;

        await context.read(activeOrderProvider.notifier).deliverOrder();

        if (isMounted()) isLoading.value = false;
      });
    }

    void cancelOrder() {
      _confirmCancel(context, () async {
        isLoading.value = true;

        await context.read(activeOrderProvider.notifier).cancelOrder();

        if (isMounted()) isLoading.value = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengambilan Pesanan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text('ini Driver Purcashing Order Page'),
            ),
          ),
          Container(
            width: double.infinity,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ColorPallete.errorColor,
              ),
              child:
                  isLoading.value ? SmallLoading() : Text('Batalkan Pesanan'),
              onPressed: isLoading.value ? null : cancelOrder,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10.0),
            child: ChatCustomerButton(),
          ),
          Container(
            width: double.infinity,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            margin: const EdgeInsets.only(bottom: 24),
            child: ElevatedButton(
              child: isLoading.value
                  ? SmallLoading()
                  : Text('Selesai Membeli Pesanan'),
              onPressed: isLoading.value ? null : completePurchase,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmComplete(BuildContext context, Future Function() onConfirm) {
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

  void _confirmCancel(BuildContext context, Future Function() onConfirm) {
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
