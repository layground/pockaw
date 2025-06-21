import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/budget/presentation/components/budget_card.dart';
import 'package:pockaw/features/budget/presentation/riverpod/budget_providers.dart';

class BudgetCardHolder extends ConsumerWidget {
  const BudgetCardHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetListProvider);

    return budgetsAsync.when(
      data: (budgets) {
        if (budgets.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing20),
              child: Text(
                'No budgets found. Create one!',
                style: AppTextStyles.body2,
              ),
            ),
          );
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing20,
          ), // Padding moved from BudgetScreen
          shrinkWrap: true,
          itemBuilder: (context, index) => BudgetCard(budget: budgets[index]),
          separatorBuilder: (context, index) => const Gap(AppSpacing.spacing12),
          itemCount: budgets.length,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
