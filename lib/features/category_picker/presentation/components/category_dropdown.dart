import 'package:expandable/expandable.dart'
    show ExpandableController, ExpandablePanel, ExpandableThemeData;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useMemoized;

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';

import 'category_tile.dart';

class CategoryDropdown extends HookConsumerWidget {
  final CategoryModel category;
  const CategoryDropdown({super.key, required this.category});

  @override
  Widget build(BuildContext context, ref) {
    final expandableController = useMemoized(() => ExpandableController(), []);

    final List<CategoryModel> subCategories =
        category.subCategories ?? [category];

    return ExpandablePanel(
      controller: expandableController,
      header: InkWell(
        onDoubleTap: () {
          expandableController.toggle();
        },
        child: CategoryTile(
          category: category,
          suffixIcon: HugeIcons.strokeRoundedArrowDown01,
          onSuffixIconPressed: () {
            expandableController.toggle();
          },
        ),
      ),
      collapsed: Container(),
      expanded: ListView.separated(
        itemCount: subCategories.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: AppSpacing.spacing8,
          left: AppSpacing.spacing12,
        ),
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Gap(AppSpacing.spacing8),
        itemBuilder: (context, index) {
          final cat = subCategories[index];
          return CategoryTile(
            category: cat,
            suffixIcon: HugeIcons.strokeRoundedCheckmarkCircle01,
            onSelectCategory: (selectedCategory) {
              CategoryModel newCategory = category.copyWith(
                subCategories: [selectedCategory],
              );
              context.pop(newCategory);
            },
          );
        },
      ),
      theme: const ExpandableThemeData(
        hasIcon: false,
        useInkWell: false,
        tapHeaderToExpand: false,
      ),
    );
  }
}
