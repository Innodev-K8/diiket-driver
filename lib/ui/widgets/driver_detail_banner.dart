import 'package:diiket_models/all.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';

class DriverDetailBanner extends StatelessWidget {
  final User driver;
  final Color? backgroundColor;

  const DriverDetailBanner({
    Key? key,
    required this.driver,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(driver.profile_picture_url ?? ''),
              radius: 72 / 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  driver.driver_detail?.vehicle_name ?? '-',
                  style: kTextTheme.overline,
                ),
                Text(
                  driver.driver_detail?.vehicle_number ?? '-',
                  style: kTextTheme.headline3,
                ),
                SizedBox(height: 8),
                Text(
                  driver.name ?? '-',
                  style: kTextTheme.bodyText2!.copyWith(
                    color: backgroundColor ?? ColorPallete.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
