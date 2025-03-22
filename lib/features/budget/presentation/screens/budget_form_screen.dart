import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_confirm_checkbox.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';

class BudgetFormScreen extends StatelessWidget {
  const BudgetFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      title: 'Edit Budget',
      showBackButton: true,
      showBalance: false,
      actions: [
        CustomIconButton(
          onPressed: () {},
          icon: TablerIcons.trash,
          color: AppColors.red,
          borderColor: AppColors.redAlpha10,
          backgroundColor: AppColors.redAlpha10,
        ),
      ],
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacing20),
            child: Column(
              children: [
                CustomTextField(
                  // controller: titleController,
                  label: 'Fund Source',
                  hint: 'Primary Wallet',
                  prefixIcon: TablerIcons.wallet,
                  readOnly: true,
                ),
                const Gap(AppSpacing.spacing16),
                CustomSelectField(
                  label: 'Category',
                  hint: 'Groceries • Cosmetics',
                  isRequired: true,
                  prefixIcon: TablerIcons.category_2,
                  onTap: () {
                    context.push(Routes.categoryList);
                  },
                ),
                const Gap(AppSpacing.spacing16),
                CustomNumericField(
                  // controller: amountController,
                  label: 'Amount',
                  hint: '\$ 34',
                  icon: TablerIcons.coin,
                  isRequired: true,
                ),
                const Gap(AppSpacing.spacing16),
                CustomSelectField(
                  label: 'Set a date',
                  hint: '12 November 2024',
                  prefixIcon: TablerIcons.calendar,
                  isRequired: true,
                  onTap: () {},
                ),
                const Gap(AppSpacing.spacing16),
                CustomConfirmCheckbox(
                  title: 'Mark this budget as routine',
                  subtitle: 'No need to create this budget every time.',
                  checked: false,
                )
              ],
            ),
          ),
          PrimaryButton(
            label: 'Save',
            onPressed: () {},
          ).floatingBottom
        ],
      ),
    );
  }
}
