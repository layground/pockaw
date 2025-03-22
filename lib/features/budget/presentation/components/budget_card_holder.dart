import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/presentation/components/budget_card.dart';

class BudgetCardHolder extends StatelessWidget {
  const BudgetCardHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      shrinkWrap: true,
      itemBuilder: (context, index) => InkWell(
        child: const BudgetCard(),
        onTap: () => context.push(Routes.budgetDetails),
      ),
      separatorBuilder: (context, index) => const Gap(AppSpacing.spacing8),
      itemCount: 5,
    );
  }
}
