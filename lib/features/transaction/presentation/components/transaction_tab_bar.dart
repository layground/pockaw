import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/tabs/custom_tab.dart';
import 'package:pockaw/core/components/tabs/custom_tab_bar.dart';

class TransactionTabBar extends HookConsumerWidget {
  final TabController tabController;
  const TransactionTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context, ref) {
    return CustomTabBar(
      tabController: tabController,
      tabs: [
        CustomTab(label: 'Oct 2024'),
        CustomTab(label: 'Nov 2024'),
        CustomTab(label: "Dec 2024"),
        CustomTab(label: 'Last month'),
        CustomTab(label: 'This month'),
      ],
    );
  }
}
