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
}
