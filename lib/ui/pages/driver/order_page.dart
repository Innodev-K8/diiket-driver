import 'package:flutter/material.dart';
import 'package:mitra/ui/pages/driver/order_state_page/delivering_order_page.dart';
import 'package:mitra/ui/pages/driver/order_state_page/purcashing_order_page.dart';

class DriverOrderPage extends StatelessWidget {
  static String route = 'driver/order';

  const DriverOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // buat testing, langsung ganti delivering/purcashing

    return DriverPurcashingOrderPage();
    // return DriverDeliveringOrderPage();
  }
}
