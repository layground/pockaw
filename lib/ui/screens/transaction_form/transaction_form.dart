import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/ui/screens/transaction_form/transaction_amount_editor.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_radius.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';
import 'package:pockaw/ui/widgets/buttons/button_chip.dart';
import 'package:pockaw/ui/widgets/buttons/buttons.dart';
import 'package:pockaw/ui/widgets/form_fields/custom_select_field.dart';
import 'package:pockaw/ui/widgets/form_fields/custom_text_field.dart';
import 'package:pockaw/ui/widgets/scaffolds/custom_scaffold.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Gap(AppSpacing.spacing12),
                  const CustomTextField(
                    label: 'Add title',
                    hint: 'Lunch with my friends',
                    icon: TablerIcons.letter_case,
                  ),
                  const Gap(AppSpacing.spacing16),
                  const CustomSelectField(
                    label: 'Select a category',
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
                    suffixIcon: TablerIcons.corner_down_left,
                    minLines: 1,
                    maxLines: 3,
                  ),
                  const Gap(AppSpacing.spacing16),
                  const CustomSelectField(
                    label: 'Attach an image',
                    hint: 'Upload or take a picture',
                    icon: TablerIcons.photo,
                    suffixIcon: TablerIcons.upload,
                    hintColor: AppColors.dark,
                  ),
                ],
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.radius24),
                  topRight: Radius.circular(AppRadius.radius24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkAlpha30,
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Transaction Amount',
                            style: AppTextStyles.body3,
                          ),
                          Icon(
                            TablerIcons.chevron_down,
                            size: 20,
                            color: AppColors.primaryAlpha30,
                          ),
                        ],
                      ),
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.spacing8,
                            horizontal: AppSpacing.spacing16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryAlpha10,
                            borderRadius:
                                BorderRadius.circular(AppRadius.radius8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rp.',
                                style: AppTextStyles.numericLarge.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                              const Gap(AppSpacing.spacing4),
                              Text(
                                '453.128',
                                style: AppTextStyles.numericHeading.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          WoltModalSheet.show(
                            context: context,
                            pageListBuilder: (context) {
                              return [
                                WoltModalSheetPage(
                                  child: TransactionAmountEditor(),
                                ),
                              ];
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.spacing20),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing8,
                    ),
                    child: Row(
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
                  ),
                  const Gap(AppSpacing.spacing20),
                  Button(
                    label: 'Save',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
