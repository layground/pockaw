import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/budget/presentation/components/budget_card.dart';

class BudgetCardHolder extends StatelessWidget {
  const BudgetCardHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(AppSpacing.spacing20),
      shrinkWrap: true,
      itemBuilder: (context, index) => BudgetCard(),
      separatorBuilder: (context, index) => Gap(AppSpacing.spacing8),
      itemCount: 5,
    );
  }
}
