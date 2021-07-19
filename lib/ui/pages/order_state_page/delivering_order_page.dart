import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:driver/ui/widgets/small_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text('ini Driver Delivering Order Page'),
            ),
          ),
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
