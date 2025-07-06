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
          backgroundColor: colorScheme
              .surfaceContainerHighest, // Use a surface color that adapts
          radius: 50,
          child: CircleAvatar(
            backgroundColor:
                colorScheme.surface, // Use a surface color that adapts
            backgroundImage: auth.profilePicture == null
                ? null
                : FileImage(File(auth.profilePicture!)),
            radius: 49,
          ),
        ),
        const Gap(AppSpacing.spacing12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(auth.name, style: AppTextStyles.body1),
            Text(
              'The Clever Squirrel', // This text color will adapt via DefaultTextStyle or explicit style
              style: AppTextStyles
                  .body2, // Use onSurfaceVariant for secondary text
            ),
            const Gap(AppSpacing.spacing8),
            CustomCurrencyChip(
              currencyCode: wallet.currency,
              label:
                  '${wallet.currencyByIsoCode(ref).symbol} - ${wallet.currencyByIsoCode(ref).country}',
              background: context.purpleBackground(context.themeMode),
              borderColor: context.purpleBorderLighter(context.themeMode),
              foreground: context.purpleText(context.themeMode),
            ),
          ],
        ),
      ],
    );
  }
}
