import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/small_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class TransactionSummaryCard extends StatelessWidget {
  const TransactionSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing20,
      ),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.purpleAlpha10,
        border: Border.all(color: AppColors.purpleAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Earning',
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.purple950,
                ),
              ),
              Expanded(
                child: Text(
                  '2.200.122',
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium.copyWith(
                    color: AppColors.primary600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spending',
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.purple950,
                ),
              ),
              Expanded(
                child: Text(
                  '2.200.122',
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium.copyWith(
                    color: AppColors.red700,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: AppColors.purpleAlpha10,
            thickness: 1,
            height: 9,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.purple950,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Expanded(
                child: Text(
                  '2.200.122',
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium.copyWith(
                    color: AppColors.purple950,
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing4),
          const SmallButton(
            label: 'View full report',
            backgroundColor: AppColors.purpleAlpha10,
            borderColor: AppColors.purpleAlpha10,
            foregroundColor: AppColors.purple,
            labelTextStyle: AppTextStyles.body5,
          ),
        ],
      ),
    );
  }
}
