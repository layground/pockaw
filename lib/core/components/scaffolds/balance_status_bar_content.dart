part of 'custom_scaffold.dart';

class BalanceStatusBarContent extends ConsumerWidget {
  const BalanceStatusBarContent({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWalletAsync = ref.watch(activeWalletProvider);

    return activeWalletAsync.when(
      data: (wallet) {
        if (wallet == null) {
          // Handle case where no wallet is active
          return Container(
            height: 35,
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing20,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppColors.purple50,
              border: Border.all(color: AppColors.purpleAlpha10),
              borderRadius: BorderRadius.circular(AppRadius.radius8),
            ),
            child: Center(
              child: Text(
                'No Wallet Selected',
                style: AppTextStyles.body4.copyWith(color: AppColors.purple),
              ),
            ),
          );
        }
        return Container(
          height: 35,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing8),
          decoration: BoxDecoration(
            color: AppColors.purple50,
            border: Border.all(color: AppColors.purpleAlpha10),
            borderRadius: BorderRadius.circular(AppRadius.radius8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2, // Give more space to wallet name if needed
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      HugeIcons.strokeRoundedWallet01,
                      size: 16,
                      color: AppColors.purple,
                    ),
                    const Gap(AppSpacing.spacing2),
                    Flexible(
                      // Allow text to wrap or truncate if too long
                      child: Text(
                        wallet.name,
                        style: AppTextStyles.body4.copyWith(
                          color: AppColors.purple,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(AppSpacing.spacing8),
              Expanded(
                flex: 3, // Give more space to balance
                child: Text(
                  '${wallet.currency} ${wallet.balance.toPriceFormat()}',
                  style: AppTextStyles.numericRegular.bold,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        height: 35,
        child: Center(
          child: CircularProgressIndicator.adaptive(strokeWidth: 2),
        ),
      ),
      error: (err, stack) => SizedBox(
        height: 35,
        child: Center(
          child: Icon(Icons.error_outline, color: AppColors.red700),
        ),
      ),
    );
  }
}
