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
              color: context.secondaryBackground,
              borderRadius: BorderRadius.circular(AppRadius.radius16),
              border: Border.all(color: context.secondaryBorderLighter),
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

        return Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              decoration: BoxDecoration(
                color: context.secondaryBackground,
                borderRadius: BorderRadius.circular(AppRadius.radius16),
                border: Border.all(color: context.secondaryBorderLighter),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.spacing8,
                children: [
                  Text('My Balance', style: AppTextStyles.body3),
                  const WalletSwitcherDropdown(),
                  Consumer(
                    builder: (context, ref, child) {
                      final isVisible = ref.watch(
                        walletAmountVisibilityProvider,
                      );

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        spacing: AppSpacing.spacing2,
                        children: [
                          Text(
                            !isVisible
                                ? ''
                                : wallet.currencyByIsoCode(ref).symbol,
                            style: AppTextStyles.body3,
                          ),
                          Text(
                            !isVisible
                                ? '•••••••••••'
                                : wallet.balance.toPriceFormat(),
                            style: AppTextStyles.numericHeading.copyWith(
                              height: 1,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              right: AppSpacing.spacing12,
              top: AppSpacing.spacing12,
              child: Row(
                spacing: AppSpacing.spacing8,
                children: [
                  WalletAmountEditButton(),
                  WalletAmountVisibilityButton(),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => Container(
        // Basic loading state
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        decoration: BoxDecoration(
          color: context.secondaryBackground,
          borderRadius: BorderRadius.circular(AppRadius.radius16),
          border: Border.all(color: context.secondaryBorderLighter),
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
          color: context.secondaryBackground,
          borderRadius: BorderRadius.circular(AppRadius.radius16),
          border: Border.all(color: context.secondaryBorderLighter),
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
