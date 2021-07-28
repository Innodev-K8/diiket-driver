import 'package:driver/data/notification/background_fcm.dart';
import 'package:driver/data/providers/order/chat/chat_client_provider.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/theme.dart';
import 'package:driver/ui/pages/chat/chat_page.dart';
import 'package:driver/ui/pages/home_page.dart';
import 'package:driver/ui/pages/auth/login_page.dart';
import 'package:driver/ui/pages/order_page.dart';
import 'package:driver/ui/widgets/active_order_wrapper.dart';
import 'package:driver/ui/widgets/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
      builder: (context, child) => StreamChat(
        client: context.read(chatClientProvider),
        streamChatThemeData: StreamChatThemeData.fromTheme(
          ThemeData(
            primaryColor: ColorPallete.primaryColor,
            accentColor: ColorPallete.secondaryColor,
            textTheme: kTextTheme,
          ),
        ),
        child: child,
      ),
      routes: {
        HomePage.route: (_) => AuthWrapper(
              auth: (_) => ActiveOrderWrapper(
                onFree: () => HomePage(),
                onHaveActiveOrder: (_) => OrderPage(),
              ),
              guest: () => LoginPage(),
              showLoading: true,
            ),
        OrderPage.route: (_) => AuthWrapper(
              auth: (_) => OrderPage(),
              guest: () => LoginPage(),
            ),
        ChatPage.route: (_) => AuthWrapper(
              auth: (_) => ChatPage(),
              guest: () => LoginPage(),
            ),
      },
    );
  }
}
