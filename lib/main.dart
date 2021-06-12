import 'package:driver/ui/common/theme.dart';
import 'package:driver/ui/pages/home_page.dart';
import 'package:driver/ui/pages/order_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Diiket',
      debugShowCheckedModeBanner: false,
      theme: kAppTheme,
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (_) => HomePage(),
        OrderPage.route: (_) => OrderPage(),
      },
    );
  }
}
