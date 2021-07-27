import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/widgets/toggle_button.dart';
import 'package:flutter/material.dart';

class OrderChecklistItem extends StatelessWidget {
  const OrderChecklistItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Telur Ayam (tray)1kg",
                    style: kTextTheme.headline4!.copyWith(fontSize: 16),
                  ),
                  Text("2 Item"),
                ],
              ),
            ),
            ToggleButton(icon: Icon(Icons.check), onToggle: (state) {}),
          ],
        ));
  }
}
