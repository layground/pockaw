part of '../screens/dashboard_screen.dart';

class WalletAmountVisibilityButton extends ConsumerWidget {
  const WalletAmountVisibilityButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(walletAmountVisibilityProvider);

    return CustomIconButton(
      context,
      onPressed: () {
        ref.read(walletAmountVisibilityProvider.notifier).state = !isVisible;
      },
      icon: isVisible
          ? HugeIcons.strokeRoundedView
          : HugeIcons.strokeRoundedViewOffSlash,
      themeMode: context.themeMode,
      iconSize: IconSize.tiny,
    );
  }
}
