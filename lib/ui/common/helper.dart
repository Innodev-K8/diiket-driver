import 'package:intl/intl.dart';

abstract class Helper {
  static NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  static String greeting() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Selamat Pagi';
    }

    if (hour < 17) {
      return 'Selamat Siang';
    }

    return 'Selamat Malam';
  }

  static String fmtPrice([int? price = 0]) {
    return currencyFormatter.format(price);
  }

  static String fmtMetricDistance(int distanceInMeter) {
    if (distanceInMeter < 1000) {
      return '$distanceInMeter m';
    } else {
      return '${(distanceInMeter / 1000).toStringAsFixed(2)} km';
    }
  }
}
