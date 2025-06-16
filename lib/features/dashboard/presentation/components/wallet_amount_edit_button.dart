part of '../screens/dashboard_screen.dart';

class WalletAmountEditButton extends ConsumerWidget {
  const WalletAmountEditButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        final activeWallet = ref.read(activeWalletProvider).valueOrNull;
        final defaultCurrencies = ref.read(currenciesStaticProvider);

        if (activeWallet != null) {
          final selectedCurrency = defaultCurrencies.firstWhere(
            (currency) => currency.isoCode == activeWallet.currency,
            orElse: () => defaultCurrencies.first,
          );

          ref.read(currencyProvider.notifier).state = selectedCurrency;

          showModalBottomSheet(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            builder: (_) => WalletFormBottomSheet(wallet: activeWallet),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        decoration: BoxDecoration(
          color: AppColors.purpleAlpha10,
          border: Border.all(color: AppColors.purpleAlpha10),
          borderRadius: BorderRadius.circular(AppRadius.radius8),
        ),
        child: Icon(
          HugeIcons.strokeRoundedEdit02,
          size: 14,
          color: AppColors.purple,
        ),
      ),
    );
  }
}
