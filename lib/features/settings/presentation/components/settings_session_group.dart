part of '../screens/settings_screen.dart';

class SettingsSessionGroup extends ConsumerWidget {
  const SettingsSessionGroup({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SettingsGroupHolder(
      title: 'Session',
      settingTiles: [
        MenuTileButton(
          label: 'Logout',
          icon: HugeIcons.strokeRoundedLogout01,
          onTap: () {
            // show confirm dialog then perform logout
            context.openBottomSheet(
              child: AlertBottomSheet(
                context: context,
                title: 'Logout',
                confirmText: 'Logout',
                content: Text(
                  'Continue logging out from this device?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body2,
                ),
                onConfirm: () {
                  context.pop(); // close this dialog
                  ref.read(authStateProvider.notifier).logout();
                  context.go(Routes.getStarted);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
