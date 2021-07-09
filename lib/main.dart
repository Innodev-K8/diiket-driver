import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:driver/ui/common/theme.dart';
import 'package:driver/ui/pages/home_page.dart';
import 'package:driver/ui/pages/auth/login_page.dart';
import 'package:driver/ui/pages/order_page.dart';
import 'package:driver/ui/widgets/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Diiket',
      debugShowCheckedModeBanner: false,
      theme: kAppTheme,
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (_) => AuthWrapper(
              auth: (_) => HomePage(),
              guest: () => LoginPage(),
            ),
        OrderPage.route: (_) => AuthWrapper(
              auth: (_) => OrderPage(),
              guest: () => LoginPage(),
            ),
      },
    );
  }
}
