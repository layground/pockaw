part of '../screens/settings_screen.dart';

class SettingsAppInfoGroup extends StatelessWidget {
  const SettingsAppInfoGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsGroupHolder(
      title: 'App Info',
      settingTiles: [
        MenuTileButton(
          label: 'Privacy Policy',
          icon: TablerIcons.hammer,
          suffixIcon: TablerIcons.external_link,
        ),
        MenuTileButton(
          label: 'Terms and Conditions',
          icon: TablerIcons.report,
          suffixIcon: TablerIcons.external_link,
        ),
        MenuTileButton(
          label: 'Delete My Data',
          icon: TablerIcons.trash_x,
        ),
        MenuTileButton(
          label: 'Logout',
          icon: TablerIcons.logout,
        ),
      ],
    );
  }
}
