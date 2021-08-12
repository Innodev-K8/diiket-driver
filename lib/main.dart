import 'package:driver/data/notification/background_fcm.dart';
import 'package:driver/data/notification/channels.dart';
import 'package:driver/data/notification/service.dart';
import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:driver/data/providers/firebase_provider.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await NotificationService().initialize();

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final firebaseMessaging = context.read(messagingProvider);

    // when the token change, update the user device token and add the token to getstream
    firebaseMessaging.onTokenRefresh.listen((token) {
      final client = context.read(chatClientProvider);
      final auth = context.read(authProvider.notifier);

      client.addDevice(token, PushProvider.firebase);

      if (context.read(authProvider) != null) {
        auth.updateDeviceToken(token);
      }
    });
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
        onBackgroundEventReceived: _streamChatBackgroundEventHandler,
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

  Future<void> _streamChatBackgroundEventHandler(Event event) async {
    final client = context.read(chatClientProvider);

    final currentUserId = client.state.user?.id;

    if (![
          EventType.messageNew,
          EventType.notificationMessageNew,
        ].contains(event.type) ||
        event.user?.id == currentUserId) {
      return;
    }

    if (event.message == null) return;

    await NotificationService().instance.show(
          event.message!.id.hashCode,
          event.message!.user?.name,
          event.message!.text,
          NotificationDetails(
            android: NotificationChannels.chat,
          ),
        );
  }
}
