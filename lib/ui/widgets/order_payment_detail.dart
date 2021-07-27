import 'package:diiket_models/all.dart';
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
            title: 'Berat barang',
            value: Text('2 kg'),
          ),
          SizedBox(height: 16.0),
          DetailItem(
            title: 'Ongkos belanja',
            value: Text('Rp. 1000'),
          ),
          SizedBox(height: 16.0),
          DetailItem(
            title: 'Ongkos kirim',
            value: Text('Rp. 1000'),
          ),
          SizedBox(height: 16.0),
          DetailItem(
            title: 'Biaya Layanan',
            value: Text('Rp. 1000'),
          ),
          SizedBox(height: 16.0),
          Divider(
            thickness: 1,
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total harga', style: kTextTheme.headline5),
              Text(
                'Rp. 123',
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
