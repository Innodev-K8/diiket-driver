import 'package:diiket_models/all.dart';
import 'package:driver/ui/common/helper.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';

import 'detail_item.dart';

class OrderPaymentDetail extends StatelessWidget {
  final Order order;

  const OrderPaymentDetail({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBorderedDecoration,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DetailItem(
            title: 'Harga barang',
            value: Text('Rp. ${Helper.fmtPrice(order.products_price)}'),
          ),
          SizedBox(height: 16.0),
          DetailItem(
            title: 'Ongkos belanja',
            value: Text('Rp. ${Helper.fmtPrice(order.pickup_fee)}'),
          ),
          SizedBox(height: 16.0),
          DetailItem(
            title: 'Ongkos kirim',
            value: Text('Rp. ${Helper.fmtPrice(order.delivery_fee)}'),
          ),
          SizedBox(height: 16.0),
          DetailItem(
            title: 'Biaya Layanan',
            value: Text('Rp. ${Helper.fmtPrice(order.service_fee)}'),
          ),
          SizedBox(height: 16.0),
          Divider(
            thickness: 1,
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total tagihan', style: kTextTheme.headline5),
              Text(
                'Rp. ${Helper.fmtPrice(order.total_price)}',
                textAlign: TextAlign.end,
                style: kTextTheme.headline5!.copyWith(
                  color: ColorPallete.secondaryColor,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
