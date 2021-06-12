import 'package:flutter/material.dart';

import 'styles.dart';

ThemeData kAppTheme = ThemeData(
  primaryColor: ColorPallete.primaryColor,
  accentColor: ColorPallete.secondaryColor,
  textTheme: kTextTheme,
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    backgroundColor: ColorPallete.accentColor,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  primaryTextTheme: kTextTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        ColorPallete.primaryColor,
      ), //button color
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ), //text (and icon)
    ),
  ),
);
