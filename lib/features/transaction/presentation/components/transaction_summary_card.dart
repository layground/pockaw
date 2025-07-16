import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/small_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class TransactionSummaryCard extends ConsumerWidget {
  final List<TransactionModel> transactions;
  const TransactionSummaryCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, ref) {
    final currency = ref
        .read(activeWalletProvider)
        .value
        ?.currencyByIsoCode(ref)
        .symbol;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: context.purpleBackground(context.themeMode),
        border: Border.all(
          color: context.purpleBorderLighter(context.themeMode),
        ),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Earning', style: AppTextStyles.body3),
              Expanded(
                child: Text(
                  '$currency ${transactions.totalIncome.toPriceFormat()}',
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium.copyWith(
                    color: context.incomeText(context.themeMode),
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Spending', style: AppTextStyles.body3),
              Expanded(
                child: Text(
                  '- $currency ${transactions.totalExpenses.toPriceFormat()}',
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium.copyWith(
                    color: context.expenseText(context.themeMode),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: context.breakLineColor(context.themeMode),
            thickness: 1,
            height: 9,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.body3.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Expanded(
                child: Text(
                  '$currency ${transactions.total.toPriceFormat()}',
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing4),
          SmallButton(
            label: 'View full report',
            backgroundColor: context.purpleButtonBackground(context.themeMode),
            borderColor: context.purpleButtonBorder(context.themeMode),
            foregroundColor: context.secondaryText(context.themeMode),
            labelTextStyle: AppTextStyles.body5,
          ),
        ],
      ),
    );
  }
}
