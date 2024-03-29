import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/widgets/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CheckListButton extends HookWidget {
  final bool? initialValue;
  final Function(bool?) onToggled;

  const CheckListButton({
    Key? key,
    required this.onToggled,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = useState<bool?>(initialValue);

    return Column(
      children: [
        Row(
          children: [
            SquareIconButton(
              icon: Icon(Icons.check),
              isActive: status.value ?? false,
              onPressed: () {
                status.value = status.value == true ? null : true;

                onToggled(status.value);
              },
            ),
            SizedBox(width: 16),
            SquareIconButton(
              icon: Icon(Icons.close),
              primary: ColorPallete.errorColor,
              isActive: status.value == false,
              onPressed: () {
                status.value = status.value == false ? null : false;

                onToggled(status.value);
              },
            ),
          ],
        ),
        if (status.value == false)
          SizedBox(
            // SquareIconButton width is 34, so 34 * 2 + 16
            width: 34 * 2 + 16,
            child: Text(
              'Harap konfirmasi ke pelanggan',
              style: kTextTheme.overline,
              textAlign: TextAlign.end,
            ),
        ),
      ],
    );
  }
}
