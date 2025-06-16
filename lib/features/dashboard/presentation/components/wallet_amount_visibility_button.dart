part of '../screens/dashboard_screen.dart';

class WalletAmountVisibilityButton extends ConsumerWidget {
  const WalletAmountVisibilityButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(walletAmountVisibilityProvider);

    return InkWell(
      onTap: () {
        ref.read(walletAmountVisibilityProvider.notifier).state = !isVisible;
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        decoration: BoxDecoration(
          color: AppColors.purpleAlpha10,
          border: Border.all(color: AppColors.purpleAlpha10),
          borderRadius: BorderRadius.circular(AppRadius.radius8),
        ),
        child: Icon(
          isVisible
              ? HugeIcons.strokeRoundedView
              : HugeIcons.strokeRoundedViewOffSlash,
          size: 14,
          color: AppColors.purple,
        ),
      ),
    );
  }
}
