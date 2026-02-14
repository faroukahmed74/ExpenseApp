import 'package:intl/intl.dart';

/// Supported app currencies. Default is Egyptian Pound.
enum AppCurrency {
  egp('EGP', 'E£', 'Egyptian Pound'),
  usd('USD', '\$', 'US Dollar'),
  eur('EUR', '€', 'Euro'),
  gbp('GBP', '£', 'British Pound'),
  sar('SAR', 'ر.س', 'Saudi Riyal'),
  aed('AED', 'د.إ', 'UAE Dirham');

  const AppCurrency(this.code, this.symbol, this.name);
  final String code;
  final String symbol;
  final String name;

  /// Use en_US for consistent decimal/thousand separators; only the symbol changes.
  NumberFormat get formatter =>
      NumberFormat.currency(locale: 'en_US', symbol: symbol, decimalDigits: 2);

  static AppCurrency fromCode(String code) {
    return AppCurrency.values.firstWhere(
      (c) => c.code == code,
      orElse: () => AppCurrency.egp,
    );
  }
}
