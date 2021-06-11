import 'package:flutter/material.dart';

class DriverDeliveringOrderPage extends StatelessWidget {
  const DriverDeliveringOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengantaran Pesanan'),
      ),
      body: Center(
        child: Text('ini Driver Delivering Order Page'),
      ),
    );
  }
}
