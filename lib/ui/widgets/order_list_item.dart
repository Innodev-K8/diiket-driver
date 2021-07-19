import 'package:diiket_models/all.dart';
import 'package:driver/ui/common/helper.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:flutter/material.dart';

class OrderListItem extends StatelessWidget {
  final Order order;

  const OrderListItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productCount = order.order_items?.fold(0, (int value, item) {
      return value + (item.quantity ?? 0);
    });

    final productWeight = order.total_weight;
    final productPrice = order.products_price;
    final deliveryDistance =
        Helper.fmtMetricDistance(order.delivery_distance ?? 0);

    final driverProfit = (order.delivery_fee ?? 0) + (order.pickup_fee ?? 0);

    return Container(
      margin: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorPallete.blueishGray,
        border: Border.all(
          color: ColorPallete.lightGray.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: ColorPallete.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Text(
              "Pesanan",
              style: kTextTheme.headline3,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          OrderDetailTile(
            title: 'Jumlah Barang',
            value: productCount.toString(),
          ),
          OrderDetailTile(
            title: 'Berat Barang',
            value: '${(productWeight ?? 0) / 1000} kg',
          ),
          OrderDetailTile(
            title: 'Total Biaya',
            value: 'Rp ${Helper.fmtPrice(productPrice)}',
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 1),
            color: ColorPallete.backgroundColor,
            padding: EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      deliveryDistance,
                      style: kTextTheme.headline3,
                    ),
                    SizedBox(height: 5),
                    Text("Jarak"),
                  ],
                ),
                SizedBox(
                  width: 36,
                ),
                Column(
                  children: [
                    Text(
                      'Rp ${Helper.fmtPrice(driverProfit)}',
                      style: kTextTheme.headline3,
                    ),
                    SizedBox(height: 5),
                    Text("Pendapatan"),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorPallete.backgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 46.0,
              child: ElevatedButton(
                child: Text("Ambil"),
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderDetailTile extends StatelessWidget {
  final String title;
  final String value;

  const OrderDetailTile({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      color: ColorPallete.backgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kTextTheme.headline4,
          ),
          Text(
            value,
            style: kTextTheme.headline3,
          ),
        ],
      ),
    );
  }
}
