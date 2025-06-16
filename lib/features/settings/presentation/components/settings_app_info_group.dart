part of '../screens/settings_screen.dart';

final logoutKey = GlobalKey<NavigatorState>();

class SettingsAppInfoGroup extends ConsumerWidget {
  const SettingsAppInfoGroup({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SettingsGroupHolder(
      title: 'App Info',
      settingTiles: [
        MenuTileButton(
          label: 'Privacy Policy',
          icon: HugeIcons.strokeRoundedLegalHammer,
          suffixIcon: HugeIcons.strokeRoundedSquareArrowUpRight,
          onTap: () {
            LinkLauncher.launch('https://pockaw.com/privacy-policy.html');
          },
        ),
        MenuTileButton(
          label: 'Terms and Conditions',
          icon: HugeIcons.strokeRoundedFileExport,
          suffixIcon: HugeIcons.strokeRoundedSquareArrowUpRight,
          onTap: () {
            LinkLauncher.launch('https://pockaw.com/terms-and-conditions.html');
          },
        ),
        MenuTileButton(
          label: 'Delete My Data',
          icon: HugeIcons.strokeRoundedDelete01,
          onTap: () => context.push(Routes.accountDeletion),
        ),
        MenuTileButton(
          label: 'Logout',
          icon: HugeIcons.strokeRoundedLogout01,
          onTap: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (context) => AlertBottomSheet(
                title: 'Logout',
                content: const Text(
                  'Continue to logout from this accout?',
                  style: AppTextStyles.body2,
                ),
                onConfirm: () {
                  context.pop(); // close dialog
                  ref.read(authStateProvider.notifier).logout();
                  context.replace(Routes.onboarding);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
