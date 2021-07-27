import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ToggleButton extends HookWidget {
  final bool initialState;
  final Icon icon;
  final Function(bool) onToggle;

  const ToggleButton({
    Key? key,
    required this.icon,
    required this.onToggle,
    this.initialState = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useState(false);

    return InkWell(
      onTap: () {
        state.value = !state.value;

        onToggle(state.value);
      },
      child: Container(
        width: 34,
        height: 34,
        padding: const EdgeInsets.all(5),
        color: state.value ? ColorPallete.primaryColor : ColorPallete.lightGray,
        child: Icon(
          icon.icon,
          color: state.value ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
