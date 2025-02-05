import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
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
import 'package:pockaw/core/router/routes.dart';

class TransactionForm extends HookWidget {
  TransactionForm({super.key});

  final border = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  final roundedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final amountController = useTextEditingController();

    final titleFocus = useFocusNode();
    final amountFocus = useFocusNode();

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
                    CustomTextField(
                      controller: titleController,
                      label: 'Title',
                      hint: 'Lunch with my friends',
                      prefixIcon: TablerIcons.letter_case,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                    ),
                    const Gap(AppSpacing.spacing16),
                    CustomNumericField(
                      controller: amountController,
                      label: 'Amount',
                      hint: '\$ 34',
                      icon: TablerIcons.coin,
                      isRequired: true,
                      autofocus: true,
                    ),
                    const Gap(AppSpacing.spacing16),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          SizedBox(
                            height: double.infinity,
                            child: SecondaryButton(
                              onPressed: () {},
                              icon: TablerIcons.shopping_bag_check,
                            ),
                          ),
                          const Gap(AppSpacing.spacing8),
                          Expanded(
                            child: CustomSelectField(
                              label: 'Category',
                              hint: 'Groceries • Cosmetics',
                              isRequired: true,
                              onTap: () {
                                context.push(Routes.categoryList);
                              },
                            ),
                          ),
                        ],
                      ),
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
                    CustomTextField(
                      label: 'Write a note',
                      hint: 'Write here...',
                      prefixIcon: TablerIcons.note,
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
                            label: 'Camera',
                            icon: TablerIcons.focus_centered,
                          ),
                        ),
                        const Gap(AppSpacing.spacing8),
                        Expanded(
                          child: SecondaryButton(
                            onPressed: () {},
                            label: 'Gallery',
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
                            right: 5,
                            top: 5,
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
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
