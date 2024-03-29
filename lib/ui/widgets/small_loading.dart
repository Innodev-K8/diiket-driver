import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';

class SmallLoading extends StatelessWidget {
  const SmallLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: ColorPallete.secondaryColor,
      ),
    );
  }
}
