import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/features/transaction/application/providers/transaction_providers.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tile.dart';
import 'package:intl/intl.dart';

class TransactionGroupedCard extends ConsumerWidget {
  const TransactionGroupedCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTransactions = ref.watch(transactionListProvider);

    // Filter transactions for "Today"
    final now = DateTime.now();
    final todayTransactions = allTransactions.where((t) {
      return t.date.year == now.year &&
          t.date.month == now.month &&
          t.date.day == now.day;
    }).toList();

    // Calculate total for today's transactions
    final double todayTotal = todayTransactions.fold(0.0, (sum, item) {
      return sum +
          (item.transactionType == TransactionType.income
              ? item.amount
              : -item.amount);
    });

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
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
              Text('Today', style: AppTextStyles.body2.bold),
              Expanded(
                child: Text(
                  NumberFormat.currency(
                    locale: "en_US",
                    symbol: "",
                    decimalDigits: 2,
                  ).format(todayTotal),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium.copyWith(
                    color: todayTotal >= 0
                        ? AppColors.green200
                        : AppColors.red700,
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing12),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todayTransactions.length,
            itemBuilder: (context, index) {
              final transaction = todayTransactions[index];
              return TransactionTile(transaction: transaction, showDate: false);
            },
            separatorBuilder: (context, index) =>
                const Gap(AppSpacing.spacing16),
          ),
        ],
      ),
    );
  }
}
