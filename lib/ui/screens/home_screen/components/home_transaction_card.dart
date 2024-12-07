import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/ui/themes/app_radius.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';

class HomeTransactionCard extends StatelessWidget {
  final String title;
  final double amount;
  final double amountLastMonth;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? amountColor;
  final Color? statsBackgroundColor;
  final Color? statsForegroundColor;
  final Color? statsIconColor;
  const HomeTransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.amountLastMonth,
    this.backgroundColor,
    this.titleColor,
    this.amountColor,
    this.statsBackgroundColor,
    this.statsForegroundColor,
    this.statsIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body3.copyWith(
              color: titleColor,
            ),
          ),
          const Gap(AppSpacing.spacing8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp.',
                style: AppTextStyles.body3.copyWith(
                  color: amountColor,
                ),
              ),
              Text(
                '$amount',
                style: AppTextStyles.numericTitle.copyWith(
                  color: amountColor,
                  height: 1,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing8,
              vertical: AppSpacing.spacing4,
            ),
            decoration: BoxDecoration(
                color: statsBackgroundColor,
                borderRadius: BorderRadius.circular(AppRadius.radiusFull)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  TablerIcons.arrow_up,
                  size: 14,
                  color: statsIconColor,
                ),
                const Gap(AppSpacing.spacing2),
                Text(
                  '10%',
                  style: AppTextStyles.body5.copyWith(
                    color: statsForegroundColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
