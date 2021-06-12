import 'package:flutter/material.dart';

import 'order_state_page/purcashing_order_page.dart';

class OrderPage extends StatelessWidget {
  static String route = 'driver/order';

  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // buat testing, langsung ganti delivering/purcashing

    return PurcashingOrderPage();
    // return DeliveringOrderPage();
  }
}
