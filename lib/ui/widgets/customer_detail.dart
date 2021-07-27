import 'package:diiket_models/all.dart';
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
            height: 20,
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hubungi pemesan",
                style: kTextTheme.headline5,
              ),
              TextButton.icon(
                style: TextButton.styleFrom(primary: ColorPallete.primaryColor),
                onPressed: () {},
                icon: Icon(
                  Icons.chat_bubble,
                ),
                label: Text("Chat"),
              )
            ],
          )
        ],
      ),
    );
  }
}
