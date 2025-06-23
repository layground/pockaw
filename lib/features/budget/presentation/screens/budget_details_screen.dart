import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/budget/presentation/components/budget_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_date_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_fund_source_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_top_transactions_holder.dart';
import 'package:pockaw/core/db/app_database.dart';

class BudgetDetailsScreen extends StatelessWidget {
  final Budget budget;
  const BudgetDetailsScreen({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      title: 'Budget Report',
      showBackButton: true,
      actions: [
        CustomIconButton(
          onPressed: () {},
          iconWidget: Icon(TablerIcons.edit),
        ),
        CustomIconButton(
          onPressed: () {},
          iconWidget: Icon(TablerIcons.trash),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing20),
        child: Column(
          children: [
            BudgetCard(budget: budget),
            const Gap(AppSpacing.spacing12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: BudgetDateCard()),
                Gap(AppSpacing.spacing12),
                Expanded(child: BudgetFundSourceCard()),
              ],
            ),
            const Gap(AppSpacing.spacing12),
            const BudgetTopTransactionsHolder(),
          ],
        ),
      ),
    );
  }
}
