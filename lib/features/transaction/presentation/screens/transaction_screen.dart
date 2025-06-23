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
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transactions_list_provider.dart';

class TransactionScreen extends HookConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 5, initialIndex: 4);
    final transactionsAsync = ref.watch(transactionsListProvider);

    return CustomScaffold(
      context: context,
      showBackButton: false,
      title: 'My Transactions',
      showBalance: false,
      actions: [
        CustomIconButton(
          onPressed: () {},
          iconWidget: Icon(TablerIcons.search),
        ),
        CustomIconButton(
          onPressed: () {},
          iconWidget: Icon(TablerIcons.filter),
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
                transactionsAsync.when(
                  data: (transactions) => ListView(
                    padding: const EdgeInsets.only(bottom: 120),
                    children: [
                      const TransactionSummaryCard(),
                      const Gap(AppSpacing.spacing20),
                      TransactionGroupedCard(
                          transactions: transactions.reversed.toList()),
                    ],
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
