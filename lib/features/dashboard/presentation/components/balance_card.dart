part of '../screens/dashboard_screen.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final activeWalletAsync = ref.watch(activeWalletProvider);

    return activeWalletAsync.when(
      data: (wallet) {
        // If no wallet is active (e.g., initial state or no wallets exist)
        if (wallet == null) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            decoration: BoxDecoration(
              color: AppColors.secondary50,
              borderRadius: BorderRadius.circular(AppRadius.radius16),
              border: Border.all(color: AppColors.secondaryAlpha10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Balance', style: AppTextStyles.body3),
                Gap(AppSpacing.spacing8),
                WalletSwitcherDropdown(), // Still show dropdown to select/create
                Gap(AppSpacing.spacing8),
                Text('No wallet selected.', style: AppTextStyles.body2),
              ],
            ),
          );
        }

        return Container(
          width: double.infinity,
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
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.neutral800,
                ),
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
      },
      loading: () => Container(
        // Basic loading state
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        decoration: BoxDecoration(
          color: AppColors.secondary50,
          borderRadius: BorderRadius.circular(AppRadius.radius16),
          border: Border.all(color: AppColors.secondaryAlpha10),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Balance', style: AppTextStyles.body3),
            Gap(AppSpacing.spacing8),
            WalletSwitcherDropdown(), // Show dropdown even when loading
            Gap(AppSpacing.spacing8),
            CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
      error: (error, stack) => Container(
        // Basic error state
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        decoration: BoxDecoration(
          color: AppColors.secondary50,
          borderRadius: BorderRadius.circular(AppRadius.radius16),
          border: Border.all(color: AppColors.secondaryAlpha10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Balance', style: AppTextStyles.body3),
            const Gap(AppSpacing.spacing8),
            const WalletSwitcherDropdown(),
            const Gap(AppSpacing.spacing8),
            Text(
              'Error loading balance: $error',
              style: AppTextStyles.body2.copyWith(color: AppColors.red700),
            ),
          ],
        ),
      ),
    );
  }
}
