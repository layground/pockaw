import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalDatePickerNotifier extends Notifier<List<DateTime?>> {
  @override
  List<DateTime?> build() {
    return [DateTime.now()];
  }

  void setDate(DateTime date) {
    state = [date];
  }

  void setRange(List<DateTime?> range) {
    state = range;
  }

  void clear() {
    state = [DateTime.now()];
  }
}

final datePickerProvider =
    NotifierProvider<GoalDatePickerNotifier, List<DateTime?>>(
      GoalDatePickerNotifier.new,
    );
