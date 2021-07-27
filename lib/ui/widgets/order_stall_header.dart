import 'package:diiket_models/all.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';

class OrderStallHeader extends StatelessWidget {
  final Stall stall;

  const OrderStallHeader({
    Key? key,
    required this.stall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 4),
      color: ColorPallete.darkGray,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stall.name ?? '-',
                  style: kTextTheme.headline3!.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  stall.seller?.name ?? '-',
                  style: kTextTheme.headline6!.copyWith(color: Colors.white),
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Lt. ${stall.location_floor} Blok ${stall.location_block} No. ${stall.location_number}',
                  style: kTextTheme.overline!
                      .copyWith(color: Colors.white, fontSize: 12),
                ),
              ),
              Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(primary: ColorPallete.primaryColor),
                onPressed: () {},
                icon: Icon(Icons.phone),
                label: Text("Telp"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
