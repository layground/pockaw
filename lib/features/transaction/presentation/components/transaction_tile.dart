import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_ui_extension.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final bool showDate;
  const TransactionTile({
    super.key,
    required this.transaction,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/transaction/${transaction.id}'),
      child: Container(
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
                  color: transaction.backgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.radius12),
                  border: Border.all(color: transaction.borderColor),
                ),
                child: Center(
                  child: Icon(
                    HugeIcons.strokeRoundedHeadphones,
                    color: transaction.iconColor,
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
                      Text(transaction.title, style: AppTextStyles.body3),
                      const Gap(AppSpacing.spacing2),
                      Text(
                        transaction.category.title,
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
                          transaction.formattedDate,
                          style: AppTextStyles.body5.copyWith(
                            color: AppColors.neutral500,
                          ),
                        ),
                      if (showDate) const Gap(AppSpacing.spacing4),
                      Text(
                        transaction.formattedAmount,
                        style: AppTextStyles.numericMedium.copyWith(
                          color: transaction.amountColor,
                          height: 1.12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
