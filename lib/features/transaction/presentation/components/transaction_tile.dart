import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class TransactionTile extends StatelessWidget {
  final bool showDate;
  const TransactionTile({
    super.key,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing8,
        AppSpacing.spacing8,
        AppSpacing.spacing16,
        AppSpacing.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        border: Border.all(color: AppColors.neutralAlpha10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.red50,
                borderRadius: BorderRadius.circular(AppRadius.radius12),
                border: Border.all(color: AppColors.redAlpha10),
              ),
              child: const Center(
                child: Icon(
                  HugeIcons.strokeRoundedHeadphones,
                  color: AppColors.red,
                ),
              ),
            ),
          ),
          const Gap(AppSpacing.spacing12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Web maintenance',
                      style: AppTextStyles.body3,
                    ),
                    const Gap(AppSpacing.spacing2),
                    Text(
                      'Dinner with friends',
                      style: AppTextStyles.body4.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (showDate)
                      Text(
                        '09 December',
                        style: AppTextStyles.body5.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                    if (showDate) const Gap(AppSpacing.spacing4),
                    Text(
                      '1.120.300',
                      style: AppTextStyles.numericMedium.copyWith(
                        color: AppColors.red700,
                        height: 1.12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
