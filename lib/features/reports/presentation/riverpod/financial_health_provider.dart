import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/features/reports/data/models/daily_net_flow_model.dart';
import 'package:pockaw/features/reports/data/models/monthly_financial_summary_model.dart';
import 'package:pockaw/features/reports/data/models/weekly_financial_summary_model.dart';
import 'package:pockaw/features/reports/data/repositories/financial_health_repository.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_providers.dart';

// State can be a simple AsyncValue list
final sixMonthSummaryProvider =
    FutureProvider.autoDispose<List<MonthlyFinancialSummary>>((ref) async {
      final repo = ref.watch(financialHealthRepositoryProvider);
      // Fetch last 6 months of data
      return repo.getLastMonthsSummary(6);
    });

final weeklySummaryProvider =
    FutureProvider.autoDispose<List<WeeklyFinancialSummary>>((ref) async {
      final repo = ref.watch(financialHealthRepositoryProvider);
      return repo.getCurrentMonthWeeklySummary();
    });

final financialHealthRepositoryProvider = Provider<FinancialHealthRepository>((
  ref,
) {
  final transactionsAsync = ref.watch(transactionListProvider);
  return FinancialHealthRepository(transactionsAsync.value ?? []);
});

final dailyNetFlowProvider =
    FutureProvider.autoDispose<List<DailyNetFlowSummary>>((ref) async {
      final repo = ref.watch(financialHealthRepositoryProvider);
      return repo.getCurrentMonthDailyNetFlow();
    });
