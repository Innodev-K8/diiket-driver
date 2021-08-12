import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SquareIconButton extends HookWidget {
  final bool isActive;
  final Icon icon;
  final Color primary;
  final Function() onPressed;

  const SquareIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.primary = ColorPallete.secondaryColor,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: 34,
        height: 34,
        padding: const EdgeInsets.all(5),
        color: isActive ? primary : ColorPallete.lightGray,
        child: Icon(
          icon.icon,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
