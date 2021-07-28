import 'package:diiket_models/all.dart';
import 'package:driver/ui/widgets/order_checklist_item.dart';
import 'package:driver/ui/widgets/order_stall_header.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class OrderList extends StatelessWidget {
  const OrderList({
    Key? key,
    required this.order,
    this.readonly = false,
  }) : super(key: key);

  final Order order;
  final bool readonly;

  @override
  Widget build(BuildContext context) {
    return GroupedListView<OrderItem, Stall>(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      elements: order.order_items ?? [],
      groupBy: (item) => item.product!.stall!,
      groupComparator: (a, b) => 0,
      groupSeparatorBuilder: (Stall stall) => OrderStallHeader(stall: stall),
      separator: Divider(),
      itemBuilder: (context, item) => OrderChecklistItem(
        orderItem: item,
        readonly: readonly,
      ),
    );
  }
}
