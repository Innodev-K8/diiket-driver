import 'package:flutter/material.dart';
import 'package:mitra/ui/common/styles.dart';
import 'package:mitra/ui/pages/driver/home_page.dart';
import 'package:mitra/ui/pages/driver/order_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mitra Diiket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ColorPallete.primaryColor,
        accentColor: ColorPallete.secondaryColor,
        textTheme: kTextTheme,
        appBarTheme: AppBarTheme(
            backgroundColor: ColorPallete.accentColor,
            iconTheme: IconThemeData(
              color: Colors.white,
            )),
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
      ),
      initialRoute: DriverHomePage.route,
      routes: {
        DriverHomePage.route: (_) => DriverHomePage(),
        DriverOrderPage.route: (_) => DriverOrderPage(),
      },
    );
  }
}
