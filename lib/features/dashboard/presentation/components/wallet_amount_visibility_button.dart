part of '../screens/dashboard_screen.dart';

class WalletAmountVisibilityButton extends ConsumerWidget {
  const WalletAmountVisibilityButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isVisible = ref.watch(walletAmountVisibilityProvider);

    return CustomIconButton(
      onPressed: () {},
      icon: isVisible
          ? HugeIcons.strokeRoundedView
          : HugeIcons.strokeRoundedViewOffSlash,
      context: context,
      themeMode: themeMode,
      iconSize: IconSize.tiny,
    );
  }
}
