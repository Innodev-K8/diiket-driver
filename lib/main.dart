import 'package:driver/data/notification/background_fcm.dart';
import 'package:driver/ui/common/theme.dart';
import 'package:driver/ui/pages/home_page.dart';
import 'package:driver/ui/pages/auth/login_page.dart';
import 'package:driver/ui/pages/order_page.dart';
import 'package:driver/ui/widgets/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
              showLoading: true,
            ),
        OrderPage.route: (_) => AuthWrapper(
              auth: (_) => OrderPage(),
              guest: () => LoginPage(),
            ),
      },
    );
  }
}
