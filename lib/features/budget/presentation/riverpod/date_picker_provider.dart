import 'package:hooks_riverpod/hooks_riverpod.dart';

final datePickerProvider = StateProvider<List<DateTime?>>((ref) {
  return [DateTime.now()];
});
