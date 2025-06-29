part of '../screens/settings_screen.dart';

class SettingsPreferencesGroup extends StatelessWidget {
  const SettingsPreferencesGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsGroupHolder(
      title: 'Preferences',
      settingTiles: [
        MenuTileButton(
          label: 'Notifications',
          icon: HugeIcons.strokeRoundedNotification01,
          onTap: () => context.push(Routes.comingSoon),
        ),
      ],
    );
  }
}
