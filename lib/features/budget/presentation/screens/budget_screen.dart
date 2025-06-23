import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/presentation/components/budget_card_holder.dart';
import 'package:pockaw/features/budget/presentation/components/budget_summary_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_tab_bar.dart';

class BudgetScreen extends HookWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 5, initialIndex: 4);

    return CustomScaffold(
      context: context,
      title: 'My Budgets',
      showBackButton: false,
      actions: [
        CustomIconButton(
          onPressed: () {
            context.push(Routes.budgetForm);
          },
          iconWidget: Icon(TablerIcons.plus),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing20),
        child: Column(
          children: [
            BudgetTabBar(tabController: tabController),
            const Gap(AppSpacing.spacing20),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  const Center(child: Text('Tab 1')),
                  const Center(child: Text('Tab 2')),
                  const Center(child: Text('Tab 3')),
                  const Center(child: Text('Tab 4')),
                  ListView(
                    children: const [
                      BudgetSummaryCard(),
                      BudgetCardHolder(),
                      Gap(100),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
