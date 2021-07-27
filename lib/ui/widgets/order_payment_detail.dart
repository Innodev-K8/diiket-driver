import 'package:diiket_models/all.dart';
import 'package:driver/ui/common/helper.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';

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
          PaymentDetailRecord(
            title: 'Berat barang',
            value: Text('2 kg'),
          ),
          SizedBox(height: 16.0),
          PaymentDetailRecord(
            title: 'Ongkos belanja',
            value: Text('Rp. 1000'),
          ),
          SizedBox(height: 16.0),
          PaymentDetailRecord(
            title: 'Ongkos kirim',
            value: Text('Rp. 1000'),
          ),
          SizedBox(height: 16.0),
          PaymentDetailRecord(
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

class PaymentDetailRecord extends StatelessWidget {
  final String title;
  final Widget value;

  const PaymentDetailRecord({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kTextTheme.subtitle2!.copyWith(
            color: ColorPallete.darkGray,
          ),
        ),
        if (value is Text)
          Text(
            (value as Text).data ?? '',
            style: (value as Text).style,
            textAlign: TextAlign.end,
          )
        else
          value
      ],
    );
  }
}
