import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';

class OrderStallHeader extends StatelessWidget {
  const OrderStallHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: ColorPallete.darkGray,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Toko Buah Batu",
                style: kTextTheme.headline3!.copyWith(color: Colors.white),
              ),
              Text(
                "Pak Bambang",
                style: kTextTheme.headline6!.copyWith(color: Colors.white),
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Pasar Lawang Lantai 5 No.05, Blok A",
                  style: kTextTheme.overline!
                      .copyWith(color: Colors.white, fontSize: 12),
                ),
              ),
              Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(primary: ColorPallete.primaryColor),
                onPressed: () {},
                icon: Icon(Icons.chat_bubble),
                label: Text("Chat"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
