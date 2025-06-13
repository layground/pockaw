import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class TransactionAmountEditor extends StatelessWidget {
  TransactionAmountEditor({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.spacing20,
        right: AppSpacing.spacing20,
        bottom: AppSpacing.spacing20,
      ),
      child: Column(
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Transaction Amount',
                style: AppTextStyles.body3,
              ),
              Icon(
                HugeIcons.strokeRoundedArrowDown01,
                size: 20,
                color: AppColors.primaryAlpha25,
              ),
            ],
          ),
          const Gap(AppSpacing.spacing16),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.spacing8,
              horizontal: AppSpacing.spacing16,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondaryAlpha10,
              borderRadius: BorderRadius.circular(
                AppRadius.radius8,
              ),
            ),
            child: AutoSizeTextFormField(
              autofocus: true,
              controller: _controller,
              keyboardType: TextInputType.number,
              style: AppTextStyles.numericHeading.copyWith(
                color: AppColors.secondary,
              ),
              // readOnly: true,
              fullwidth: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                /*prefixIcon: Padding(
                  padding: EdgeInsets.only(right: AppSpacing.spacing8),
                  child: Text(
                    'Rp.',
                    style: AppTextStyles.numericLarge
                        .copyWith(color: AppColors.secondary),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(),*/
                hintText: '0',
                hintStyle: AppTextStyles.numericHeading.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
          const Gap(AppSpacing.spacing16),
          PrimaryButton(
            label: 'Save',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
