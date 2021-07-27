import 'package:diiket_models/all.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class OrderStallHeader extends StatelessWidget {
  final Stall stall;

  const OrderStallHeader({
    Key? key,
    required this.stall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 85,
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
      color: ColorPallete.darkGray,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            foregroundImage:
                NetworkImage(stall.seller?.profile_picture_url ?? ''),
            radius: 54 / 2,
          ),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stall.seller?.name ?? '-',
                  style: kTextTheme.button!.copyWith(color: Colors.white),
                ),
                _buildCallButton(context),
              ],
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  stall.name ?? '-',
                  style: kTextTheme.button!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.end,
                ),
                Text(
                  'Lt. ${stall.location_floor} Blok ${stall.location_block} No. ${stall.location_number}',
                  style: kTextTheme.overline!.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton(BuildContext context) {
    return InkWell(
      onTap: () {
        final phoneNumber = stall.seller?.phone_number;

        if (phoneNumber == null) {
          Utils.alert(context, 'Tidak  dapat menghubungi penjual');
          return;
        }

        Utils.prompt(context, description: 'Hubungi ${stall.seller?.name}?',
            onConfirm: () async {
          await FlutterPhoneDirectCaller.callNumber(phoneNumber);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(
              Icons.phone,
              color: ColorPallete.primaryColor,
              size: 18,
            ),
            SizedBox(width: 6),
            Text(
              "Telp",
              style: kTextTheme.button!.copyWith(
                color: ColorPallete.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
