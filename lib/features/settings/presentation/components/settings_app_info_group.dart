part of '../screens/settings_screen.dart';

final logoutKey = GlobalKey<NavigatorState>();

class SettingsAppInfoGroup extends ConsumerWidget {
  const SettingsAppInfoGroup({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SettingsGroupHolder(
      title: 'App Info',
      settingTiles: [
        const MenuTileButton(
          label: 'Privacy Policy',
          icon: HugeIcons.strokeRoundedLegalHammer,
          suffixIcon: HugeIcons.strokeRoundedLink01,
        ),
        const MenuTileButton(
          label: 'Terms and Conditions',
          icon: HugeIcons.strokeRoundedFileExport,
          suffixIcon: HugeIcons.strokeRoundedLink01,
        ),
        const MenuTileButton(
          label: 'Delete My Data',
          icon: HugeIcons.strokeRoundedDelete01,
        ),
        MenuTileButton(
          label: 'Logout',
          icon: HugeIcons.strokeRoundedLogout01,
          onTap: () {
            showAdaptiveDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: const Text('Logout'),
                content: const Text('Continue to logout from this accout?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop(); // close dialog
                      ref.read(authStateProvider.notifier).logout();
                      context.replace(Routes.onboarding);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
