part of '../screens/settings_screen.dart';

class SettingsFinanceGroup extends StatelessWidget {
  const SettingsFinanceGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsGroupHolder(
      title: 'Finance',
      settingTiles: [
        MenuTileButton(
          label: 'Fund Sources',
          icon: TablerIcons.wallet,
        ),
        MenuTileButton(
          label: 'Categories',
          icon: TablerIcons.category_2,
        ),
        MenuTileButton(
          label: 'Change Currency',
          icon: TablerIcons.moneybag,
        ),
      ],
    );
  }
}
