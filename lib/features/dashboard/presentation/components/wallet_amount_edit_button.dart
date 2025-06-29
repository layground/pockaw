part of '../screens/dashboard_screen.dart';

class WalletAmountEditButton extends ConsumerWidget {
  const WalletAmountEditButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return CustomIconButton(
      onPressed: () {
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
      icon: HugeIcons.strokeRoundedEdit02,
      context: context,
      themeMode: themeMode,
      iconSize: IconSize.tiny,
    );
  }
}
