import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  final String title;
  final Widget value;

  const DetailItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: kTextTheme.subtitle2!.copyWith(
              color: ColorPallete.darkGray,
            ),
          ),
        ),
        Expanded(
          child: (value is Text)
              ? Text(
                  (value as Text).data ?? '',
                  style: (value as Text).style,
                  textAlign: TextAlign.end,
                )
              : value,
        ),
      ],
    );
  }
}
