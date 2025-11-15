import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetDatePickerNotifier extends Notifier<List<DateTime?>> {
  @override
  List<DateTime?> build() => [DateTime.now()];

  void setRange(List<DateTime?> range) => state = range;
  void clear() => state = [DateTime.now()];
}

final datePickerProvider =
    NotifierProvider<BudgetDatePickerNotifier, List<DateTime?>>(
      BudgetDatePickerNotifier.new,
    );
