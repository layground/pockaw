import 'package:equatable/equatable.dart';

class DailyNetFlowSummary extends Equatable {
  final int day; // Day of the month (1 to 31)
  final double netAmount; // Cumulative net flow up to this day

  const DailyNetFlowSummary({
    required this.day,
    required this.netAmount,
  });

  @override
  List<Object?> get props => [day, netAmount];
}
