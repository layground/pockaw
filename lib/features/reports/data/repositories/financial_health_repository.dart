import 'package:pockaw/features/reports/data/models/daily_net_flow_model.dart';
import 'package:pockaw/features/reports/data/models/monthly_financial_summary_model.dart';
import 'package:pockaw/features/reports/data/models/weekly_financial_summary_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';

class FinancialHealthRepository {
  final List<TransactionModel> _transactions;

  FinancialHealthRepository(this._transactions);

  /// Fetches the last [monthsCount] months of data and aggregates income/expense.
  Future<List<MonthlyFinancialSummary>> getLastMonthsSummary(
    int monthsCount,
  ) async {
    final now = DateTime.now().add(Duration(days: 30));
    // Calculate start date (e.g., 6 months ago from the 1st of that month)
    final startDate = DateTime(now.year, now.month - (monthsCount - 1), 1);

    final recentTransactions = _transactions.where((t) {
      return t.date.isAfter(startDate.subtract(const Duration(days: 1)));
    }).toList();

    // 2. Generate the list of months we want to display (even empty ones)
    final List<MonthlyFinancialSummary> summaryList = [];

    for (int i = 0; i < monthsCount; i++) {
      final monthDate = DateTime(startDate.year, startDate.month + i, 1);

      // Filter transactions for this specific month
      final transactionsInMonth = recentTransactions.where((t) {
        return t.date.year == monthDate.year && t.date.month == monthDate.month;
      });

      double income = 0;
      double expense = 0;

      for (var t in transactionsInMonth) {
        // Assuming TransactionType is an Enum or String. Adjust based on your actual model.
        // Based on your file list, checking simple string or enum logic:
        if (t.transactionType == TransactionType.income) {
          income += t.amount;
        } else if (t.transactionType == TransactionType.expense) {
          expense += t.amount;
        }
      }

      summaryList.add(
        MonthlyFinancialSummary(
          month: monthDate,
          income: income,
          expense: expense,
        ),
      );
    }

    return summaryList;
  }

  /// Fetches data for the CURRENT month and buckets it into 4 weeks.
  List<WeeklyFinancialSummary> getCurrentMonthWeeklySummary(
    List<TransactionModel> transactions,
  ) {
    if (transactions.isEmpty) return [];

    final now = transactions.first.date;
    // 1. Filter for current month only
    final currentMonthTransactions = transactions.where((t) {
      return t.date.year == now.year && t.date.month == now.month;
    }).toList();

    List<WeeklyFinancialSummary> weeklyData = [];

    // 2. Define buckets: Week 1 (1-7), Week 2 (8-14), Week 3 (15-21), Week 4 (22-End)
    // Note: We stick to 4 "logical" weeks for cleaner charts, keeping Week 4 slightly longer.
    for (int i = 1; i <= 4; i++) {
      int startDay = (i - 1) * 7 + 1;
      int endDay = (i == 4) ? 31 : i * 7; // Week 4 catches everything else

      // Calculate actual DateTimes for this range
      final weekStart = DateTime(now.year, now.month, startDay);
      // Handle edge case where month has fewer than 31 days or leap years
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
      final actualEndDay = endDay > lastDayOfMonth ? lastDayOfMonth : endDay;
      final weekEnd = DateTime(now.year, now.month, actualEndDay);

      final transactionsInWeek = currentMonthTransactions.where((t) {
        return t.date.day >= startDay && t.date.day <= endDay;
      });

      double income = 0;
      double expense = 0;

      for (var t in transactionsInWeek) {
        if (t.transactionType == TransactionType.income) {
          income += t.amount;
        } else if (t.transactionType == TransactionType.expense) {
          expense += t.amount;
        }
      }

      weeklyData.add(
        WeeklyFinancialSummary(
          weekNumber: i,
          income: income,
          expense: expense,
          startDate: weekStart,
          endDate: weekEnd,
        ),
      );
    }

    return weeklyData;
  }

  /// Calculates the cumulative net flow (Income - Expense) for every day of the current month.
  Future<List<DailyNetFlowSummary>> getCurrentMonthDailyNetFlow() async {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    // 1. Fetch all relevant transactions (sorted by date ascending)
    final currentMonthTransactions = _transactions
        .where((t) => t.date.year == now.year && t.date.month == now.month)
        .toList();

    currentMonthTransactions.sort((a, b) => a.date.compareTo(b.date));

    // 2. Aggregate daily income/expense changes
    Map<int, double> dailyChange = {};
    for (int i = 1; i <= daysInMonth; i++) {
      dailyChange[i] = 0.0;
    }

    for (var t in currentMonthTransactions) {
      final day = t.date.day;
      double change = 0.0;

      // Determine if it's a positive or negative flow
      if (t.transactionType == TransactionType.income) {
        change = t.amount;
      } else if (t.transactionType == TransactionType.expense) {
        change = -t.amount;
      }

      dailyChange[day] = dailyChange[day]! + change;
    }

    // 3. Calculate Cumulative Net Flow
    List<DailyNetFlowSummary> netFlowData = [];
    double cumulativeSum = 0.0;

    for (int day = 1; day <= daysInMonth; day++) {
      // Add the daily change to the running total
      cumulativeSum += dailyChange[day] ?? 0.0;

      netFlowData.add(
        DailyNetFlowSummary(
          day: day,
          netAmount: cumulativeSum,
        ),
      );

      // Stop calculation once we hit the current day
      if (day >= now.day) break;
    }

    return netFlowData;
  }
}
