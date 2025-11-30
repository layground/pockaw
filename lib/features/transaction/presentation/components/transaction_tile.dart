import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/category_picker/presentation/components/category_icon.dart';
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
      onLongPress: () => Log.d(
        '${transaction.category.iconTypeValue}: icon tapped: ${transaction.category.icon}',
        label: 'icon',
        logToFile: false,
      ),
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
              child: CategoryIcon(
                iconType: transaction.category.iconType,
                icon: transaction.category.icon,
                iconBackground: transaction.category.iconBackground,
              ),
            ),
            const Gap(AppSpacing.spacing12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          transaction.title,
                          style: AppTextStyles.body3.bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(AppSpacing.spacing2),
                        AutoSizeText(
                          transaction.category.title,
                          style: AppTextStyles.body4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
                            color: context.formButtonLabelTextColor,
                          ),
                        ),
                      if (showDate) const Gap(AppSpacing.spacing4),
                      Row(
                        spacing: AppSpacing.spacing4,
                        children: [
                          HugeIcon(
                            icon: transaction.amountPrefixIcon,
                            size: 12,
                            color: transaction.amountColor,
                          ),
                          Text(
                            '$currency ${transaction.amount.toPriceFormat()}',
                            style: AppTextStyles.numericMedium.copyWith(
                              height: 1.12,
                            ),
                          ),
                        ],
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
