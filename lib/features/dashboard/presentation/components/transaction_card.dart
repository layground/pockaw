part of '../screens/dashboard_screen.dart';

class TransactionCard extends ConsumerWidget {
  final String title;
  final double amount;
  final double amountLastMonth;
  final double percentDifference;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? titleColor;
  final Color? amountColor;
  final Color? statsBackgroundColor;
  final Color? statsForegroundColor;
  final Color? statsIconColor;
  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.amountLastMonth,
    required this.percentDifference,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.amountColor,
    this.statsBackgroundColor,
    this.statsForegroundColor,
    this.statsIconColor,
  });

  @override
  Widget build(BuildContext context, ref) {
    final activeWalletAsync = ref.watch(activeWalletProvider);

    return activeWalletAsync.when(
      data: (activeWallet) {
        // Use a default currency if no wallet is active, or handle as an error/placeholder
        final String currencySymbol =
            activeWallet?.currencyByIsoCode(ref).symbol ?? '';

        return Container(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.radius16),
            border: Border.all(color: borderColor ?? AppColors.neutralAlpha25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body3.copyWith(color: titleColor),
              ),
              const Gap(AppSpacing.spacing8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: AppSpacing.spacing2,
                children: [
                  Text(
                    currencySymbol,
                    style: AppTextStyles.body3.copyWith(color: amountColor),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      amount.toPriceFormat(),
                      style: AppTextStyles.numericTitle.copyWith(
                        color: amountColor,
                        height: 1,
                      ),
                      maxLines: 1,
                      minFontSize: AppTextStyles.numericTitle.fontSize! - 8,
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
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(
                      icon: percentDifference.isNegative
                          ? HugeIcons.strokeRoundedArrowDown01
                          : HugeIcons.strokeRoundedArrowUp01,
                      size: 14,
                      color: statsIconColor,
                    ),
                    const Gap(AppSpacing.spacing2),
                    Text(
                      '${percentDifference.toStringAsFixed(1)}%',
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
      },
      // Provide a basic placeholder for loading and error states
      loading: () =>
          const ShimmerTransactionCardPlaceholder(), // Assuming this exists from previous context
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
