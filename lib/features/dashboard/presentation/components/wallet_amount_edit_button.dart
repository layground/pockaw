part of '../screens/dashboard_screen.dart';

class WalletAmountEditButton extends ConsumerWidget {
  const WalletAmountEditButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomIconButton(
      context,
      onPressed: () {
        final activeWallet = ref.read(activeWalletProvider).asData?.value;
        final defaultCurrencies = ref.read(currenciesStaticProvider);

        if (activeWallet != null) {
          final selectedCurrency = defaultCurrencies.firstWhere(
            (currency) => currency.isoCode == activeWallet.currency,
            orElse: () => defaultCurrencies.first,
          );

          ref.read(currencyProvider.notifier).setCurrency(selectedCurrency);

          context.openBottomSheet(
            child: WalletFormBottomSheet(wallet: activeWallet),
          );
        }
      },
      icon: HugeIcons.strokeRoundedEdit02,
      themeMode: context.themeMode,
      iconSize: IconSize.tiny,
    );
  }
}
