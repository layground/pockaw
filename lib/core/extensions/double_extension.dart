import 'package:intl/intl.dart';

extension DoubleFormattingExtensions on double {
  /// Formats the double as a price string with thousand separators.
  ///
  /// Examples:
  /// - `2340.2` becomes `"2,340.20"`
  /// - `12340.33` becomes `"12,340.33"`
  /// - `412340.0` becomes `"412,340"`
  /// - `111762340.0` becomes `"111,762,340"`
  String toPriceFormat({String locale = 'en_US'}) {
    // Check if the double is effectively an integer (e.g., 123.0)
    if (this % 1 == 0) {
      // Format as an integer with thousand separators
      return NumberFormat('#,##0', locale).format(this);
    } else {
      // Format with two decimal places and thousand separators
      return NumberFormat('#,##0.00', locale).format(this);
    }
  }

  String toCompact({
    String? symbol,
    int? decimalDigits,
    String? locale,
  }) {
    return NumberFormat.compactCurrency(
      symbol: symbol,
      decimalDigits: decimalDigits,
      locale: locale,
    ).format(this);
  }

  /// Formats the double as a human-readable short price (e.g., 1K, 2,5M)
  /// Uses comma as decimal separator and up to 2 decimals for M, K, etc.
  String toShortPriceFormat() {
    final absValue = abs();
    String suffix = '';
    double divisor = 1;
    if (absValue >= 1e6) {
      suffix = 'M';
      divisor = 1e6;
    } else if (absValue >= 1e3) {
      suffix = 'K';
      divisor = 1e3;
    }
    double shortValue = this / divisor;
    String formatted;
    if (suffix.isEmpty) {
      formatted = toStringAsFixed(
        truncateToDouble() == this ? 0 : 2,
      ).replaceAll('.', ',');
    } else {
      // Show 2 decimals for M, K, but trim trailing zeros
      formatted = shortValue.toStringAsFixed(2).replaceAll('.', ',');
      if (formatted.endsWith(',00')) {
        formatted = formatted.substring(0, formatted.length - 3);
      } else if (formatted.endsWith('0')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
    }
    return '$formatted$suffix';
  }

  /// Calculates the percentage difference between this value (current) and a previous value.
  ///
  /// Returns 0.0 if previousValue is 0 to avoid division by zero.
  ///
  /// Example:
  /// - `current: 110, previous: 100` results in `10.0` (10% increase)
  /// - `current: 90, previous: 100` results in `-10.0` (10% decrease)
  double calculatePercentDifference(double previousValue) {
    if (previousValue == 0) {
      // If previous value was 0, any current value is an "infinite" increase if positive,
      // or 0% change if current is also 0. For simplicity, return 100% if current is > 0, else 0.
      return this > 0 ? 100.0 : 0.0;
    }
    return ((this - previousValue) / previousValue) * 100;
  }
}
