import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tile.dart';

class TransactionGroupedCard extends StatelessWidget {
  const TransactionGroupedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing20,
      ),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.light,
        border: Border.all(color: AppColors.neutralAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Today',
                style: AppTextStyles.body2.bold,
              ),
              const Expanded(
                child: Text(
                  '-23.000',
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing12),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) => const TransactionTile(
              showDate: false,
            ),
            separatorBuilder: (context, index) =>
                const Gap(AppSpacing.spacing16),
          ),
        ],
      ),
    );
  }
}
