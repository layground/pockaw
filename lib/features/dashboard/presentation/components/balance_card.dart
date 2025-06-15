part of '../screens/dashboard_screen.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final wallet = ref.watch(walletProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.secondary50,
        borderRadius: BorderRadius.circular(AppRadius.radius16),
        border: Border.all(color: AppColors.secondaryAlpha10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Balance',
            style: AppTextStyles.body3.copyWith(color: AppColors.neutral800),
          ),
          const Gap(AppSpacing.spacing8),
          const WalletSwitcherDropdown(),
          const Gap(AppSpacing.spacing8),
          Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    wallet.currency,
                    style: AppTextStyles.body3.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),
                  Text(
                    wallet.balance.toPriceFormat(),
                    style: AppTextStyles.numericHeading.copyWith(
                      color: AppColors.secondary950,
                      height: 1,
                    ),
                  ),
                ],
              ),
              const Gap(AppSpacing.spacing8),
              Container(
                padding: const EdgeInsets.all(AppSpacing.spacing4),
                decoration: BoxDecoration(
                  color: AppColors.purpleAlpha10,
                  border: Border.all(color: AppColors.purpleAlpha10),
                  borderRadius: BorderRadius.circular(AppRadius.radius8),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedEye,
                  size: 14,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
