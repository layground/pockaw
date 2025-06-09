import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/goal/presentation/components/goal_date_range_picker.dart';

class GoalFormDialog extends StatelessWidget {
  const GoalFormDialog({super.key});

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
                  'Add Goal',
                  style: AppTextStyles.body1,
                ),
                const Gap(AppSpacing.spacing32),
                CustomTextField(
                  label: 'Title',
                  hint: 'Lunch with my friends',
                  isRequired: true,
                  prefixIcon: HugeIcons.strokeRoundedArrangeByLettersAZ,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                const Gap(AppSpacing.spacing16),
                const GoalDateRangePicker(),
                const Gap(AppSpacing.spacing16),
                CustomTextField(
                  label: 'Write a note',
                  hint: 'Write here...',
                  prefixIcon: HugeIcons.strokeRoundedNote,
                  suffixIcon: HugeIcons.strokeRoundedAlignLeft,
                  minLines: 1,
                  maxLines: 3,
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
