import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart'
    show TablerIcons;
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class GoalChecklistFormDialog extends StatelessWidget {
  const GoalChecklistFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spacing20,
            0,
            AppSpacing.spacing20,
            AppSpacing.spacing20,
          ),
          child: Form(
            child: Column(
              children: [
                const Text(
                  'Add Goal Checklist',
                  style: AppTextStyles.body1,
                ),
                const Gap(AppSpacing.spacing32),
                CustomTextField(
                  label: 'Title',
                  hint: 'Lunch with my friends',
                  isRequired: true,
                  prefixIcon: TablerIcons.letter_case,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                const Gap(AppSpacing.spacing16),
                const CustomNumericField(
                  // controller: amountController,
                  label: 'Price amount',
                  hint: '\$ 34',
                  icon: TablerIcons.coin,
                  isRequired: true,
                ),
                const Gap(AppSpacing.spacing16),
                CustomTextField(
                  label: 'Link or place to buy',
                  hint: 'Insert or paste link here...',
                  prefixIcon: TablerIcons.link,
                  suffixIcon: TablerIcons.clipboard_check_filled,
                ),
              ],
            ),
          ),
        ),
        PrimaryButton(
          label: 'Save',
          state: ButtonState.active,
          onPressed: () {},
        ).floatingBottom,
      ],
    );
  }
}
