import 'package:expandable/expandable.dart'
    show ExpandableController, ExpandablePanel, ExpandableThemeData;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useMemoized;
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/constants/app_spacing.dart';

import 'category_tile.dart';

class CategoryDropdown extends HookConsumerWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final expandableController = useMemoized(() => ExpandableController(), []);
    return ExpandablePanel(
      controller: expandableController,
      header: InkWell(
        onDoubleTap: () {
          expandableController.toggle();
        },
        child: CategoryTile(
          title: 'Entertainment',
          suffixIcon: TablerIcons.chevron_down,
          onSuffixIconPressed: () {
            expandableController.toggle();
          },
        ),
      ),
      collapsed: Container(),
      expanded: ListView.separated(
        itemCount: 4,
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: AppSpacing.spacing8,
          left: AppSpacing.spacing12,
        ),
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Gap(AppSpacing.spacing8),
        itemBuilder: (context, index) => const CategoryTile(
          title: 'Movie',
          suffixIcon: TablerIcons.circle_check_filled,
        ),
      ),
      theme: const ExpandableThemeData(
        hasIcon: false,
        useInkWell: false,
        tapHeaderToExpand: false,
      ),
    );
  }
}
