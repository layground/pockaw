import 'package:equatable/equatable.dart';

class MonthlyFinancialSummary extends Equatable {
  final DateTime month;
  final double income;
  final double expense;

  const MonthlyFinancialSummary({
    required this.month,
    required this.income,
    required this.expense,
  });

  double get savings => income - expense;
  bool get isPositive => savings >= 0;

  /// Creates a copy with updated values (useful for aggregation)
  MonthlyFinancialSummary copyWith({
    DateTime? month,
    double? income,
    double? expense,
  }) {
    return MonthlyFinancialSummary(
      month: month ?? this.month,
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }

  @override
  List<Object?> get props => [month, income, expense];
}
