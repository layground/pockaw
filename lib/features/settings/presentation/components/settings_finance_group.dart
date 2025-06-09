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
          icon: HugeIcons.strokeRoundedWallet01,
        ),
        MenuTileButton(
          label: 'Categories',
          icon: HugeIcons.strokeRoundedCatalogue,
        ),
        MenuTileButton(
          label: 'Change Currency',
          icon: HugeIcons.strokeRoundedMoney01,
        ),
      ],
    );
  }
}
