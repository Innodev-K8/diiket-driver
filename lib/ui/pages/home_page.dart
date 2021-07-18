import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:driver/data/providers/order/available_orders_provider.dart';
import 'package:driver/ui/widgets/driver_detail_banner.dart';
import 'package:driver/ui/widgets/order_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookWidget {
  static String route = 'driver/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderList = useProvider(availableOrdersProvider);
    final driver = useProvider(authProvider);
    
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DriverDetailBanner(driver: driver ?? User()),
            Divider(height: 0),

            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).pushNamed(OrderPage.route);
            //   },
            //   child: Text('Ke Order Page'),
            // ),
            // SizedBox(height: 10),
            // Text('Order yang dapat diambil: '),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            //   child: Text(
            //     "Daftar Pesanan",
            //     style: kTextTheme.headline4,
            //   ),
            // ),
            SizedBox(height: 4),
            Expanded(
              child: orderList.when(
                data: (orders) => PageView.builder(
                  itemCount: orders.length,
                  itemBuilder: (BuildContext context, int index) =>
                      SingleChildScrollView(
                    child: OrderListItem(order: orders[index]),
                  ),
                ),
                loading: () => Text('loading'),
                error: (e, s) => Text('error: $e'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
