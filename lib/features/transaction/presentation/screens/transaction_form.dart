import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';

class TransactionForm extends StatelessWidget {
  TransactionForm({super.key});

  final _amountController = TextEditingController();

  final border = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  final roundedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      title: 'Add Transaction',
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.spacing20,
              AppSpacing.spacing16,
              AppSpacing.spacing20,
              100,
            ),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(AppSpacing.spacing12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonChip(label: 'Income'),
                        ButtonChip(
                          label: 'Expense',
                          active: true,
                        ),
                        ButtonChip(label: 'Transfer'),
                      ],
                    ),
                    const Gap(AppSpacing.spacing12),
                    const CustomTextField(
                      label: 'Title',
                      hint: 'Lunch with my friends',
                      icon: TablerIcons.letter_case,
                      inputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                    ),
                    const Gap(AppSpacing.spacing16),
                    CustomNumericField(
                      controller: _amountController,
                      label: 'Amount',
                      hint: '\$ 34',
                      icon: TablerIcons.coin,
                    ),
                    const Gap(AppSpacing.spacing16),
                    const CustomSelectField(
                      label: 'Category',
                      hint: 'Groceries • Cosmetics',
                      icon: TablerIcons.category,
                    ),
                    const Gap(AppSpacing.spacing16),
                    const CustomSelectField(
                      label: 'Set a date',
                      hint: '12 November 2024',
                      icon: TablerIcons.calendar,
                    ),
                    const Gap(AppSpacing.spacing16),
                    const CustomTextField(
                      label: 'Write a note',
                      hint: 'Write here...',
                      icon: TablerIcons.note,
                      suffixIcon: TablerIcons.align_left,
                      minLines: 1,
                      maxLines: 3,
                    ),
                    const Gap(AppSpacing.spacing16),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            onPressed: () {},
                            label: 'Take picture',
                            icon: TablerIcons.focus_centered,
                          ),
                        ),
                        const Gap(AppSpacing.spacing8),
                        Expanded(
                          child: SecondaryButton(
                            onPressed: () {},
                            label: 'Pick image',
                            icon: TablerIcons.photo,
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.spacing16),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.spacing8),
                        border: Border.all(color: AppColors.neutralAlpha25),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CustomIconButton(
                              onPressed: () {},
                              icon: TablerIcons.trash,
                              backgroundColor: AppColors.red50,
                              borderColor: AppColors.redAlpha10,
                              color: AppColors.red,
                              iconSize: IconSize.tiny,
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                left: AppSpacing.spacing20,
                right: AppSpacing.spacing20,
                bottom: AppSpacing.spacing20,
                top: AppSpacing.spacing20,
              ),
              child: PrimaryButton(
                label: 'Save',
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
