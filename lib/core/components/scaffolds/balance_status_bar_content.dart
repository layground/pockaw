part of 'custom_scaffold.dart';

class BalanceStatusBarContent extends ConsumerWidget {
  const BalanceStatusBarContent({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);

    return Container(
      height: 35,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.spacing20,
        0,
        AppSpacing.spacing20,
        0,
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        border: Border.all(color: AppColors.purpleAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Row(
        spacing: AppSpacing.spacing8,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.spacing2,
              children: [
                const Icon(
                  HugeIcons.strokeRoundedWallet01,
                  size: 16,
                  color: AppColors.purple,
                ),
                Text(
                  wallet.name,
                  style: AppTextStyles.body4.copyWith(color: AppColors.purple),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${wallet.currency} ${wallet.balance.toPriceFormat()}',
              style: AppTextStyles.numericRegular.bold,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
