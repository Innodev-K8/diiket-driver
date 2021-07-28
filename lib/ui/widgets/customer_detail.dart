import 'package:diiket_models/all.dart';
import 'package:driver/ui/common/helper.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';

import 'detail_item.dart';

class CustomerDetail extends StatelessWidget {
  final Order order;

  const CustomerDetail({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 2),
      decoration: kBorderedDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detail Penerima",
            style: kTextTheme.headline3,
          ),
          SizedBox(
            height: 10,
          ),
          DetailItem(
            title: 'Nama',
            value: Text(
              order.user?.name ?? '-',
            ),
          ),
          SizedBox(
            height: 16,
          ),
          DetailItem(
            title: 'Alamat',
            value: Text(
              order.address ?? '-',
            ),
          ),
          SizedBox(
            height: 16,
          ),
          DetailItem(
            title: 'Jarak Pengiriman',
            value: Text(
              Helper.fmtMetricDistance(order.delivery_distance ?? 0),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Hubungi",
                  style: kTextTheme.headline5,
                ),
              ),
              Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(primary: ColorPallete.primaryColor),
                onPressed: () {},
                icon: Icon(
                  Icons.phone,
                  size: 18,
                ),
                label: Text("Telp"),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(primary: ColorPallete.primaryColor),
                onPressed: () {},
                icon: Icon(
                  Icons.chat_bubble,
                  size: 18,
                ),
                label: Text("Chat"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
