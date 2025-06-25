part of '../screens/settings_screen.dart';

class SettingsDataGroup extends ConsumerWidget {
  const SettingsDataGroup({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SettingsGroupHolder(
      title: 'Data Management',
      settingTiles: [
        MenuTileButton(
          label: 'Backup Data',
          icon: HugeIcons.strokeRoundedDatabaseExport,
        ),
        MenuTileButton(
          label: 'Restore Data',
          icon: HugeIcons.strokeRoundedDatabaseImport,
        ),
        MenuTileButton(
          label: 'Delete My Data',
          icon: HugeIcons.strokeRoundedDelete02,
          onTap: () => context.push(Routes.accountDeletion),
        ),
      ],
    );
  }
}
