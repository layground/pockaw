import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatePickerNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void setDate(DateTime date) => state = date;
}

final datePickerProvider = NotifierProvider<DatePickerNotifier, DateTime>(
  DatePickerNotifier.new,
);

class FilterDatePickerNotifier extends Notifier<List<DateTime?>> {
  @override
  List<DateTime?> build() => [
    DateTime.now().subtract(const Duration(days: 5)),
    DateTime.now(),
  ];

  void setRange(List<DateTime?> range) => state = range;
}

final filterDatePickerProvider =
    NotifierProvider<FilterDatePickerNotifier, List<DateTime?>>(
      FilterDatePickerNotifier.new,
    );
