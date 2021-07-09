import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:driver/data/providers/order/available_orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'order_page.dart';

class HomePage extends HookWidget {
  static String route = 'driver/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderList = useProvider(availableOrdersProvider);

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
            SizedBox(height: 10),
            Text('Order yang dapat diambil: '),
            SizedBox(height: 4),
            orderList.when(
              data: (orders) => Text(orders
                  .map(
                    (o) =>
                        '${o.id}: ${o.order_items?.map((e) => e.product?.name).join(', ')}',
                  )
                  .join('\n')),
              loading: () => Text('loading'),
              error: (e, s) => Text('error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
