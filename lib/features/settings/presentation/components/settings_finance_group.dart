part of '../screens/settings_screen.dart';

class SettingsFinanceGroup extends StatelessWidget {
  const SettingsFinanceGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsGroupHolder(
      title: 'Finance',
      settingTiles: [
        MenuTileButton(
          label: 'Wallets',
          icon: HugeIcons.strokeRoundedWallet03,
          onTap: () => context.push(Routes.manageWallets),
        ),
        MenuTileButton(
          label: 'Categories',
          icon: HugeIcons.strokeRoundedStructure01,
          onTap: () => context.push(Routes.manageCategories),
        ),
      ],
    );
  }
}
