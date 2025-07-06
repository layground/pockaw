import 'package:intl/intl.dart';

extension StringExtension on String {
  double takeNumericAsDouble() {
    // Regex to find a sequence of digits, possibly containing commas and/or a period,
    // and ending with a digit. This is a greedy match for number-like patterns.
    // Examples: "250", "250,3", "250.6", "35,343.92", "1,325,343.92"
    final RegExp extractRegex = RegExp(r'\d+(?:[.,\d]*\d)?');
    final Match? match = extractRegex.firstMatch(this);

    if (match != null) {
      String numericStr = match.group(0)!;

      bool hasPeriod = numericStr.contains('.');
      bool hasComma = numericStr.contains(',');

      if (hasPeriod) {
        // If a period exists, assume it's the decimal separator.
        // All commas must be thousand separators.
        // e.g., "35,343.92" -> "35343.92"
        // e.g., "250.6" -> "250.6" (no change from replaceAll)
        numericStr = numericStr.replaceAll(',', '');
      } else if (hasComma) {
        // No period, but has comma(s).
        // Determine if commas are thousand separators or a decimal separator.
        final numCommas = numericStr.split(',').length - 1;

        // Heuristic: if there's one comma and it's followed by 1 or 2 digits at the end,
        // treat it as a decimal separator (e.g., "250,3" or "123,45").
        if (numCommas == 1 && RegExp(r',\d{1,2}$').hasMatch(numericStr)) {
          numericStr = numericStr.replaceFirst(',', '.'); // "250,3" -> "250.3"
        } else {
          // Otherwise, all commas are treated as thousand separators.
          // e.g., "1,234" -> "1234"
          // e.g., "1,234,567" -> "1234567"
          // e.g., "1,234,56" (if extracted, though less common format without period) -> "123456"
          numericStr = numericStr.replaceAll(',', '');
        }
      }
      // If no period and no comma, numericStr is already clean (e.g., "250")

      // Attempt to parse the cleaned and standardized string.
      return double.tryParse(numericStr) ?? 0.0;
    }

    // If no numeric part matching the pattern is found, return 0.0.
    return 0.0;
  }

  bool get isLink {
    String link = trim();
    return link.isNotEmpty &&
        (link.startsWith(RegExp(r'http?://')) ||
            link.startsWith(RegExp(r'https?://')));
  }
}

extension CustomDateParsing on String {
  /// Parses "26 June 2025 11.33 AM" to DateTime
  DateTime toDateTimeFromDayMonthYearTime12Hour() {
    final format = DateFormat("d MMMM yyyy hh.mm a");
    return format.parse(this);
  }
}
