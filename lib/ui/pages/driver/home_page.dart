import 'package:flutter/material.dart';
import 'package:mitra/ui/pages/driver/order_page.dart';

class DriverHomePage extends StatelessWidget {
  static String route = 'driver/home';

  const DriverHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diiket Driver'),
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
                Navigator.of(context).pushNamed(DriverOrderPage.route);
              },
              child: Text('Ke Order Page'),
            ),
          ],
        ),
      ),
    );
  }
}
