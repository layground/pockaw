import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/presentation/components/budget_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_date_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_fund_source_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_top_transactions_holder.dart';
import 'package:pockaw/features/budget/presentation/riverpod/budget_providers.dart';
import 'package:pockaw/features/budget/presentation/riverpod/date_picker_provider.dart';

class BudgetDetailsScreen extends ConsumerWidget {
  final int budgetId;
  const BudgetDetailsScreen({super.key, required this.budgetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(budgetDetailsProvider(budgetId));

    return budgetAsync.when(
      data: (budget) {
        if (budget == null) {
          return CustomScaffold(
            context: context,
            title: 'Budget Not Found',
            showBackButton: true,
            body: const Center(
              child: Text('Budget details could not be loaded.'),
            ),
          );
        }
        return CustomScaffold(
          context: context,
          title: 'Budget Report',
          showBackButton: true,
          actions: [
            CustomIconButton(
              context,
              onPressed: () {
                // Date range is handled by BudgetDateRangePicker and its provider
                ref.read(datePickerProvider.notifier).setRange([
                  budget.startDate,
                  budget.endDate,
                ]);

                context.push('${Routes.budgetForm}/edit/$budgetId');
              },
              icon: HugeIcons.strokeRoundedEdit02,
              themeMode: context.themeMode,
            ),
          ],
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacing20),
            child: Column(
              children: [
                BudgetCard(budget: budget),
                const Gap(AppSpacing.spacing12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: BudgetDateCard(budget: budget)),
                    const Gap(AppSpacing.spacing12),
                    Expanded(child: BudgetFundSourceCard(budget: budget)),
                  ],
                ),
                const Gap(AppSpacing.spacing12),
                BudgetTopTransactionsHolder(budget: budget),
              ],
            ),
          ),
        );
      },
      loading: () => CustomScaffold(
        context: context,
        title: 'Loading Budget...',
        showBackButton: true,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => CustomScaffold(
        context: context,
        title: 'Error',
        showBackButton: true,
        body: Center(child: Text('Error loading budget: $err')),
      ),
    );
  }
}
