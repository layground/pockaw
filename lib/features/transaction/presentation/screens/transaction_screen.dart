import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_grouped_card.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_summary_card.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tab_bar.dart';

class TransactionScreen extends HookWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 5, initialIndex: 4);

    return CustomScaffold(
      context: context,
      showBackButton: false,
      title: 'My Transactions',
      showBalance: false,
      actions: [
        CustomIconButton(
          onPressed: () {},
          icon: TablerIcons.search,
        ),
        CustomIconButton(
          onPressed: () {},
          icon: TablerIcons.filter,
          iconSize: IconSize.medium,
        ),
      ],
      body: Column(
        children: [
          TransactionTabBar(tabController: tabController),
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
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    const TransactionSummaryCard(),
                    const Gap(AppSpacing.spacing20),
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) =>
                          const TransactionGroupedCard(),
                      separatorBuilder: (context, index) =>
                          const Gap(AppSpacing.spacing16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
