import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tile.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class TransactionGroupedCard extends ConsumerWidget {
  final List<TransactionModel> transactions;
  const TransactionGroupedCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref
        .read(activeWalletProvider)
        .value
        ?.currencyByIsoCode(ref)
        .symbol;

    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing20,
          vertical: AppSpacing.spacing40,
        ),
        child: Center(
          child: Text(
            'No transactions to display.',
            style: AppTextStyles.body3,
          ),
        ),
      );
    }

    // 1. Group transactions by date (ignoring time)
    final Map<DateTime, List<TransactionModel>> groupedByDate = {};
    for (final transaction in transactions) {
      final dateKey = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      groupedByDate.putIfAbsent(dateKey, () => []).add(transaction);
    }

    // 2. Sort date keys in descending order (most recent first)
    final sortedDateKeys = groupedByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    // 3. Build a ListView for these groups
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
      itemCount: sortedDateKeys.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDateKeys[index];
        final transactionsForDay = groupedByDate[dateKey]!;

        final double dayTotal = transactionsForDay.fold(0.0, (sum, item) {
          if (item.transactionType == TransactionType.income) {
            return sum + item.amount;
          } else if (item.transactionType == TransactionType.expense) {
            return sum - item.amount;
          }
          return sum;
        });

        final String displayDate = dateKey.toRelativeDayFormatted();

        return Container(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          decoration: BoxDecoration(
            border: Border.all(
              color: context.purpleBorderLighter(context.themeMode),
            ),
            borderRadius: BorderRadius.circular(AppRadius.radius8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(displayDate, style: AppTextStyles.body2.bold),
                  Expanded(
                    child: Text(
                      '$currency ${dayTotal.toPriceFormat()}',
                      textAlign: TextAlign.end,
                      style: AppTextStyles.numericMedium.copyWith(
                        color: dayTotal > 0
                            ? AppColors.green200
                            : (dayTotal < 0
                                  ? AppColors.red700
                                  : AppColors.neutral700), // Neutral for zero
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(AppSpacing.spacing12),
              // Transactions list for the day
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactionsForDay.length,
                itemBuilder: (context, itemIndex) {
                  final transaction = transactionsForDay[itemIndex];
                  return TransactionTile(
                    transaction: transaction,
                    showDate: false, // Date is in the group header
                  );
                },
                separatorBuilder: (context, itemIndex) =>
                    const Gap(AppSpacing.spacing16),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Gap(AppSpacing.spacing16),
    );
  }
}
