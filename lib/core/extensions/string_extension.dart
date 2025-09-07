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

  bool get containsImageExtension {
    return contains('.webp') ||
        contains('.jpg') ||
        contains('.jpeg') ||
        contains('.png') ||
        contains('.gif');
  }
}

extension CustomDateParsing on String {
  /// Parses dates in following formats to DateTime:
  /// - "26 June 2025 11.33 AM" (standard format)
  /// - "Today, 11.33" or "Today"
  /// - "Yesterday, 11.33" or "Yesterday"
  /// - "Tomorrow, 11.33" or "Tomorrow"
  DateTime toDateTimeFromDayMonthYearTime12Hour() {
    final standardFormat = DateFormat("d MMMM yyyy hh.mm a");
    final timeOnlyFormat = DateFormat("hh.mm a");

    // Split by comma to separate date and time parts
    final parts = trim().split(',').map((e) => e.trim()).toList();
    final dateStr = parts[0];
    final timeStr = parts.length > 1 ? parts[1] : null;

    DateTime baseDate;
    final now = DateTime.now();

    // Handle relative dates
    switch (dateStr.toLowerCase()) {
      case 'today':
        baseDate = DateTime(now.year, now.month, now.day);
        break;
      case 'yesterday':
        baseDate = DateTime(now.year, now.month, now.day - 1);
        break;
      case 'tomorrow':
        baseDate = DateTime(now.year, now.month, now.day + 1);
        break;
      default:
        try {
          return standardFormat.parse(this);
        } catch (e) {
          // If standard format fails, throw a more helpful error
          throw FormatException(
            'Invalid date format. Expected "26 June 2025 hh.mm AM" or "Today, hh.mm"',
            this,
          );
        }
    }

    // If we have a time part, parse and combine it with the base date
    if (timeStr != null) {
      try {
        final time = timeOnlyFormat.parse(timeStr);
        return DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          time.hour,
          time.minute,
        );
      } catch (e) {
        throw FormatException(
          'Invalid time format. Expected "hh.mm AM"',
          timeStr,
        );
      }
    }

    // If no time provided, use midnight
    return baseDate;
  }
}
