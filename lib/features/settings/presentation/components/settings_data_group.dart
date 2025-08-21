part of '../screens/settings_screen.dart';

class SettingsDataGroup extends ConsumerWidget {
  const SettingsDataGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsGroupHolder(
      title: 'Data Management',
      settingTiles: [
        MenuTileButton(
          label: 'Backup & Restore',
          icon: HugeIcons.strokeRoundedDatabaseSync01,
          onTap: () {
            context.push(Routes.backupAndRestore);
          },
        ),
        MenuTileButton(
          label: 'Delete My Data',
          icon: HugeIcons.strokeRoundedDelete01,
          onTap: () => context.push(Routes.accountDeletion),
        ),
      ],
    );
  }
}
