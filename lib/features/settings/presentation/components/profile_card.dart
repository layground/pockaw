part of '../screens/settings_screen.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authStateProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final wallet = ref.watch(activeWalletProvider).value ?? wallets.first;
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: colorScheme.surfaceContainerHighest,
          radius: 50,
          child: ProfilePicture(radius: 45),
        ),
        const Gap(AppSpacing.spacing12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.spacing8,
          children: [
            Text(auth.name, style: AppTextStyles.body1),
            /* Text(
              'The Clever Squirrel',
              style: AppTextStyles.body2,
            ), */
            CustomCurrencyChip(
              currencyCode: wallet.currency,
              label:
                  '${wallet.currencyByIsoCode(ref).symbol} - ${wallet.currencyByIsoCode(ref).country}',
              background: context.purpleBackground,
              borderColor: context.purpleBorderLighter,
              foreground: context.purpleText,
            ),
          ],
        ),
      ],
    );
  }
}
