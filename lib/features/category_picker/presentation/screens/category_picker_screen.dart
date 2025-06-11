import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart'
    show ButtonChip;
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart';
import 'package:pockaw/features/category_picker/presentation/components/category_dropdown.dart';

class CategoryPickerScreen extends StatelessWidget {
  final bool isPickingParent;
  const CategoryPickerScreen({super.key, this.isPickingParent = false});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      title: 'Pick Category',
      showBalance: false,
      body: Stack(
        children: [
          ListView(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: ButtonChip(label: 'Expense', active: true)),
                    Gap(AppSpacing.spacing12),
                    Expanded(child: ButtonChip(label: 'Income')),
                  ],
                ),
              ),
              ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing20,
                  vertical: AppSpacing.spacing20,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) =>
                    CategoryDropdown(category: categories[index]),
                separatorBuilder: (context, index) =>
                    const Gap(AppSpacing.spacing12),
              ),
            ],
          ),
          if (!isPickingParent)
            PrimaryButton(
              label: 'Add New Category',
              state: ButtonState.outlinedActive,
              onPressed: () {
                context.push(Routes.categoryForm);
              },
            ).floatingBottom,
        ],
      ),
    );
  }
}
