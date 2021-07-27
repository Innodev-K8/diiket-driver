import 'package:driver/ui/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static alert(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static Future<void> prompt(
    BuildContext context, {
    String title = 'Perhatian',
    String description = '',
    String cancelText = 'Batal',
    String confirmText = 'Ya',
    Color confirmColor = ColorPallete.primaryColor,
    Color cancelColor = ColorPallete.textColor,
    Function()? onConfirm,
    Function()? onCancel,
  }) async {
    // set up the buttons
    final Widget cancelButton = TextButton(
      child: Text(cancelText),
      style: TextButton.styleFrom(
        primary: cancelColor,
      ),
      onPressed: () {
        Navigator.of(context).pop();

        onCancel?.call();
      },
    );

    final Widget continueButton = ElevatedButton(
      child: Text(confirmText),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: confirmColor,
      ),
      onPressed: () {
        Navigator.of(context).pop();

        onConfirm?.call();
      },
    );

    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: kTextTheme.headline2!.copyWith(color: ColorPallete.textColor),
      ),
      content: Text(description),
      actions: [
        cancelButton,
        continueButton,
      ],
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (_) => alert,
    );
  }
}
