import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Format: 13 March 2025
  String toDayMonthYear() {
    return DateFormat("d MMMM yyyy").format(this);
  }

  /// Format: March 13, 2025
  String toMonthDayYear() {
    return DateFormat("MMMM d, yyyy").format(this);
  }

  /// Format: 13/03/2025
  String toDayMonthYearNumeric() {
    return DateFormat("dd/MM/yyyy").format(this);
  }

  /// Format: 03/2025
  String toMonthYearNumeric() {
    return DateFormat("MM/yyyy").format(this);
  }

  /// Returns "Today", "Yesterday", "Tomorrow" if applicable, otherwise "13 March 2025"
  String toRelativeOrFormatted(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return "Today";
    if (difference == -1) return "Yesterday";
    if (difference == 1) return "Tomorrow";

    return toDayMonthYear(); // Default format
  }

  /// Format: 13 March 2025 05.44 am / 13 March 2025 05.44 pm
  String toDayMonthYearTime12Hour() {
    return DateFormat("d MMMM yyyy hh.mm a").format(this);
  }

  /// Format: 13 March 2025 17.44
  String toDayMonthYearTime24Hour() {
    return DateFormat("d MMMM yyyy HH.mm").format(this);
  }
}
