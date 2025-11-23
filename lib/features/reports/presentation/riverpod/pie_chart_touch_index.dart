import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChartTouchIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return -1;
  }

  void set(int index) => state = index;
}

final pieChartTouchIndexProvider =
    NotifierProvider<ChartTouchIndexNotifier, int>(
      ChartTouchIndexNotifier.new,
    );

final barChartTouchIndexProvider =
    NotifierProvider<ChartTouchIndexNotifier, int>(
      ChartTouchIndexNotifier.new,
    );
