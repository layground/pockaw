import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/extensions/screen_utils_extensions.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_grouped_card.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_summary_card.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tab_bar.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_providers.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTransactionsAsyncValue = ref.watch(transactionListProvider);

    return CustomScaffold(
      context: context,
      showBackButton: false,
      title: 'My Transactions',
      showBalance: false,
      actions: [
        CustomIconButton(
          onPressed: () {},
          icon: HugeIcons.strokeRoundedSearch02,
        ),
        if (context.isDesktopLayout) Gap(AppSpacing.spacing16),
        CustomIconButton(
          onPressed: () {},
          icon: HugeIcons.strokeRoundedFilter,
          iconSize: IconSize.medium,
        ),
      ],
      body: allTransactionsAsyncValue.when(
        data: (allTransactions) {
          if (allTransactions.isEmpty) {
            return const Center(child: Text('No transactions recorded yet.'));
          }

          // 1. Extract unique months from transactions
          final uniqueMonthYears = allTransactions
              .map((t) => DateTime(t.date.year, t.date.month, 1))
              .toSet()
              .toList();

          // 2. Sort months in descending order (most recent first)
          uniqueMonthYears.sort((a, b) => a.compareTo(b));

          if (uniqueMonthYears.isEmpty) {
            // This case should ideally be covered by allTransactions.isEmpty,
            // but as a fallback.
            return const Center(
              child: Text('No transactions with valid dates found.'),
            );
          }

          // Determine initial index - try to set to current month if available, else most recent
          final now = DateTime.now();
          final currentMonthDate = DateTime(now.year, now.month, 1);
          int initialTabIndex = uniqueMonthYears.indexOf(currentMonthDate);
          if (initialTabIndex == -1) {
            initialTabIndex =
                0; // Default to the most recent month if current is not in the list
          }

          return DefaultTabController(
            length: uniqueMonthYears.length,
            initialIndex: initialTabIndex,
            child: Column(
              children: [
                TransactionTabBar(
                  // TabController is now implicitly handled by DefaultTabController
                  monthsForTabs: uniqueMonthYears,
                ),
                const Gap(AppSpacing.spacing20),
                Expanded(
                  child: TabBarView(
                    children: uniqueMonthYears.map((tabMonthDate) {
                      // Filter transactions for the current tab's month
                      final transactionsForMonth = allTransactions.where((t) {
                        return t.date.year == tabMonthDate.year &&
                            t.date.month == tabMonthDate.month;
                      }).toList();

                      if (transactionsForMonth.isEmpty) {
                        // This should ideally not happen if tabs are generated from existing transaction months,
                        // but good for robustness.
                        return Center(
                          child: Text(
                            'No transactions for ${tabMonthDate.month}/${tabMonthDate.year}.',
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.only(bottom: 120),
                        children: [
                          TransactionSummaryCard(
                            transactions: transactionsForMonth,
                          ),
                          const Gap(AppSpacing.spacing20),
                          TransactionGroupedCard(
                            transactions: transactionsForMonth,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
