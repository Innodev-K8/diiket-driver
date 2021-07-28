import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/order/active_order_provider.dart';
import 'package:driver/ui/common/helper.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/widgets/checklist_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderChecklistItem extends StatelessWidget {
  final OrderItem orderItem;
  final bool readonly;

  const OrderChecklistItem({
    Key? key,
    required this.orderItem,
    this.readonly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product = orderItem.product ?? Product();

    final totalPrice = (orderItem.quantity ?? 0) * (product.price ?? 0);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.photo_url != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.network(
                product.photo_url!,
                width: 60,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '-',
                  style: kTextTheme.headline4!.copyWith(fontSize: 16),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text("${orderItem.quantity} ${product.quantity_unit}"),
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      "Rp ${Helper.fmtPrice(totalPrice)}",
                      style: kTextTheme.caption!.copyWith(
                        color: ColorPallete.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          if (!readonly)
            CheckListButton(
            initialValue: orderItem.status == OrderItemStatus.waiting
                ? null
                : orderItem.status == OrderItemStatus.picked,
            onToggled: (state) {
              late OrderItemStatus status;

              switch (state) {
                case null:
                  status = OrderItemStatus.waiting;
                  break;
                case true:
                  status = OrderItemStatus.picked;
                  break;
                case false:
                  status = OrderItemStatus.canceled;
                  break;
              }

              context
                  .read(activeOrderProvider.notifier)
                  .updateOrderItemStatus(orderItem, status);
            },
          ),
        ],
      ),
    );
  }
}
