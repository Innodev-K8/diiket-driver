import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'order_page.dart';

class HomePage extends StatelessWidget {
  static String route = 'driver/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diiket Driver'),
        actions: [
          IconButton(
            onPressed: () {
              context.read(authProvider.notifier).signOut();
            },
            icon: Icon(
              Icons.logout_rounded,
            ),
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('ini Driver Home Page'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(OrderPage.route);
              },
              child: Text('Ke Order Page'),
            ),
          ],
        ),
      ),
    );
  }
}
