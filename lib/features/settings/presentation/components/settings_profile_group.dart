part of '../screens/settings_screen.dart';

class SettingsProfileGroup extends StatelessWidget {
  const SettingsProfileGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsGroupHolder(
      title: 'Profile',
      settingTiles: [
        MenuTileButton(
          label: 'Personal Details',
          icon: HugeIcons.strokeRoundedUser,
          onTap: () => context.push(Routes.personalDetails),
        ),
      ],
    );
  }
}
