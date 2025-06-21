import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/tabs/custom_tab.dart';
import 'package:pockaw/core/components/tabs/custom_tab_bar.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/features/budget/presentation/riverpod/budget_providers.dart';

class BudgetTabBar extends HookConsumerWidget {
  const BudgetTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 1);
    final budgetPeriods = ref.watch(budgetPeriodListProvider);
    final selectedPeriodNotifier = ref.read(
      selectedBudgetPeriodProvider.notifier,
    );

    // Update the selected period when the tab changes
    useEffect(() {
      void listener() {
        selectedPeriodNotifier.state = budgetPeriods[tabController.index];
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController, budgetPeriods, selectedPeriodNotifier]);

    return CustomTabBar(
      tabController: tabController,
      tabs: budgetPeriods
          .map(
            (period) => CustomTab(label: period.toMonthTabLabel(period)),
          ) // Use extension
          .toList(),
    );
  }
}
