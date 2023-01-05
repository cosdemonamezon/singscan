import 'package:intl/intl.dart';

extension CurrencyExtension on double {
  String toMoney() {
    return '฿${NumberFormat("#,##,##0.00").format(this)}';
  }

  String toCurency() {
    return NumberFormat("#,##,##0.00").format(this);
  }

  String toCurencyWithOutDecimal() {
    return NumberFormat("#,##,##0").format(this);
  }
}

extension ThaiFormatExtension on String {
  String toTax() {
    if (length != 13) {
      return this;
    } else {
      final taxOne = substring(0, 1);
      final taxTwo = substring(1, 5);
      final taxThree = substring(5, 10);
      final taxFour = substring(10, 12);
      final taxFive = substring(12, 13);
      return '$taxOne $taxTwo $taxThree $taxFour $taxFive';
    }
  }
}
