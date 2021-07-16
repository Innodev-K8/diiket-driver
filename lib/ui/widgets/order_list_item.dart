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
    final int productCount = order.order_items
            ?.fold<int>(0, (int value, item) => (item.quantity ?? 0) + value) ??
        0;
    final int productWeight = order.order_items?.fold<int>(
            0, (int value, item) => (item.product?.weight ?? 0) + value) ??
        0;
    final int productPrice = order.order_items?.fold<int>(0, (int value, item) {
          final quantity = item.quantity ?? 0;
          final price = item.product?.price ?? 0;

          return (quantity * price) + value;
        }) ??
        0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: ColorPallete.blueishGray,
        border: Border.all(
          color: ColorPallete.lightGray,
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
            value: '${productWeight / 1000} kg',
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
                      "1,02 km",
                      style: kTextTheme.headline3,
                    ),
                    Text("Jarak"),
                  ],
                ),
                SizedBox(
                  width: 28,
                ),
                Column(
                  children: [
                    Text(
                      "1,02 km",
                      style: kTextTheme.headline3,
                    ),
                    Text("Jarak"),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 22),
            color: ColorPallete.backgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    child: Text("Tolak"),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    child: Text("Ambil Pesananan"),
                    onPressed: () {},
                  ),
                )
              ],
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
