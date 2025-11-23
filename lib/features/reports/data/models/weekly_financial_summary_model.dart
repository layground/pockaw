import 'package:equatable/equatable.dart';

class WeeklyFinancialSummary extends Equatable {
  final int weekNumber; // 1, 2, 3, 4
  final double income;
  final double expense;
  final DateTime startDate;
  final DateTime endDate;

  const WeeklyFinancialSummary({
    required this.weekNumber,
    required this.income,
    required this.expense,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [weekNumber, income, expense, startDate, endDate];
}
