import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_ui_extension.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class TransactionTile extends ConsumerWidget {
  final TransactionModel transaction;
  final bool showDate;
  const TransactionTile({
    super.key,
    required this.transaction,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context, ref) {
    final currency = ref
        .read(activeWalletProvider)
        .value
        ?.currencyByIsoCode(ref)
        .symbol;

    return InkWell(
      onTap: () {
        // Log.d(transaction.toJson(), label: 'transaction');
        context.push('/transaction/${transaction.id}');
      },
      borderRadius: BorderRadius.circular(AppRadius.radius12),
      child: Container(
        height: 72,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.spacing8,
          AppSpacing.spacing8,
          AppSpacing.spacing16,
          AppSpacing.spacing8,
        ),
        decoration: BoxDecoration(
          color: transaction.backgroundColor(context, context.themeMode),
          borderRadius: BorderRadius.circular(AppRadius.radius12),
          border: Border.all(
            color: transaction.borderColor(context.isDarkMode),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              padding: const EdgeInsets.all(AppSpacing.spacing8),
              decoration: BoxDecoration(
                color: transaction.iconBackgroundColor(
                  context,
                  context.themeMode,
                ),
                borderRadius: BorderRadius.circular(AppRadius.radius12),
                border: Border.all(
                  color: transaction.iconBorderColor(context.isDarkMode),
                ),
              ),
              child: transaction.category.icon.isEmpty
                  ? Icon(HugeIcons.strokeRoundedPizza01, size: 25)
                  : Image.asset(transaction.category.icon),
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
                      Text(transaction.title, style: AppTextStyles.body3.bold),
                      const Gap(AppSpacing.spacing2),
                      Text(
                        transaction.category.title,
                        style: AppTextStyles.body4,
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
                          style: AppTextStyles.body5,
                        ),
                      if (showDate) const Gap(AppSpacing.spacing4),
                      Text(
                        '${transaction.amountPrefix} $currency ${transaction.amount.toPriceFormat()}',
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
