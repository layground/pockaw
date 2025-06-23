import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/db/app_database.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final bool showDate;
  const TransactionTile({
    super.key,
    required this.transaction,
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
                  TablerIcons.headphones,
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
                    Text(
                      transaction.title,
                      style: AppTextStyles.body3,
                    ),
                    const Gap(AppSpacing.spacing2),
                    Text(
                      transaction.description ?? '',
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
                        _formatDate(transaction.date),
                        style: AppTextStyles.body5.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                    if (showDate) const Gap(AppSpacing.spacing4),
                    Text(
                      transaction.amount.toStringAsFixed(2),
                      style: AppTextStyles.numericMedium.copyWith(
                        color: _amountColor(transaction.transactionType),
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

  String _formatDate(DateTime date) {
    // Format as 'dd MMMM' (e.g., '09 December')
    return '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)}';
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }

  Color _amountColor(String type) {
    switch (type) {
      case 'income':
        return AppColors.green200;
      case 'transfer':
        return AppColors.tertiary500;
      case 'expense':
      default:
        return AppColors.red700;
    }
  }
}
