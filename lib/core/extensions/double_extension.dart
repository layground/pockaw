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
      return NumberFormat("#,##0", locale).format(this);
    } else {
      // Format with two decimal places and thousand separators
      return NumberFormat("#,##0.00", locale).format(this);
    }
  }
}
