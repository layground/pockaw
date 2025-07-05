import 'package:hooks_riverpod/hooks_riverpod.dart';

final datePickerProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final filterDatePickerProvider = StateProvider<List<DateTime?>>((ref) {
  return [DateTime.now().subtract(Duration(days: 5)), DateTime.now()];
});
