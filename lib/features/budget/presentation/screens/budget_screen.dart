import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/presentation/components/budget_card_holder.dart';
import 'package:pockaw/features/budget/presentation/components/budget_summary_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_tab_bar.dart';
import 'package:pockaw/features/budget/presentation/riverpod/budget_providers.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class BudgetScreen extends HookConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeModeProvider);
    final allBudgetsAsyncValue = ref.watch(budgetListProvider);

    return CustomScaffold(
      context: context,
      title: 'My Budgets',
      showBackButton: false,
      actions: [
        CustomIconButton(
          onPressed: () {
            context.push(Routes.budgetForm);
          },
          icon: HugeIcons.strokeRoundedPlusSign,
          context: context,
          themeMode: themeMode,
        ),
      ],
      body: allBudgetsAsyncValue.when(
        data: (allBudgets) {
          if (allBudgets.isEmpty) {
            return const Center(child: Text('No budgets recorded yet.'));
          }

          // 1. Extract unique months from transactions
          final uniqueMonthYears = allBudgets
              .map((t) => DateTime(t.startDate.year, t.startDate.month, 1))
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

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing20),
            child: DefaultTabController(
              length: uniqueMonthYears.length,
              initialIndex: initialTabIndex,
              child: Column(
                children: [
                  BudgetTabBar(),
                  const Gap(AppSpacing.spacing20),
                  Expanded(
                    child: TabBarView(
                      children: uniqueMonthYears.map((tabMonthDate) {
                        // Filter transactions for the current tab's month,

                        // Filter transactions for the current tab's month
                        final transactionsForMonth = allBudgets.where((t) {
                          return t.startDate.year == tabMonthDate.year &&
                              t.startDate.month == tabMonthDate.month;
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
                          children: const [
                            BudgetSummaryCard(),
                            Gap(20),
                            BudgetCardHolder(),
                            Gap(100),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
