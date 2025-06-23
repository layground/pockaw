import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/presentation/components/budget_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/db/database_provider.dart';
import 'package:pockaw/core/db/app_database.dart';

class BudgetCardHolder extends ConsumerWidget {
  const BudgetCardHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return StreamBuilder<List<Budget>>(
      stream: db.watchAllBudgets(),
      builder: (context, snapshot) {
        final budgets = snapshot.data ?? [];
        if (budgets.isEmpty) {
          return const Center(child: Text('No budgets found.'));
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.spacing20),
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            child: BudgetCard(budget: budgets[index]),
            onTap: () => context.push(Routes.budgetDetails),
          ),
          separatorBuilder: (context, index) => const Gap(AppSpacing.spacing8),
          itemCount: budgets.length,
        );
      },
    );
  }
}
