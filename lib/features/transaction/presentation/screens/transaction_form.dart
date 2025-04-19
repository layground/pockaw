import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_date_picker.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_image_picker.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_image_preview.dart';

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

    return CustomScaffold(
      context: context,
      title: 'Add Transaction',
      body: Stack(
        fit: StackFit.expand,
        children: [
          Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing20,
                AppSpacing.spacing16,
                AppSpacing.spacing20,
                100,
              ),
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
                  const TransactionDatePicker(),
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
                  const TransactionImagePicker(),
                  const Gap(AppSpacing.spacing16),
                  const TransactionImagePreview(),
                ],
              ),
            ),
          ),
          PrimaryButton(
            label: 'Save',
            state: ButtonState.active,
            onPressed: () {
              context.pop();
            },
          ).floatingBottom,
        ],
      ),
    );
  }
}
