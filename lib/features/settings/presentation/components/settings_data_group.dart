part of '../screens/settings_screen.dart';

class SettingsDataGroup extends ConsumerWidget {
  const SettingsDataGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsGroupHolder(
      title: 'Data Management',
      settingTiles: [
        MenuTileButton(
          label: 'Backup Data',
          icon: HugeIcons.strokeRoundedDatabaseExport,
          onTap: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (context) => CustomBottomSheet(
                title: 'Backup Data',
                child: BackupDialog(onSuccess: () => context.pop()),
              ),
            );
          },
        ),
        MenuTileButton(
          label: 'Restore Data',
          icon: HugeIcons.strokeRoundedDatabaseImport,
          onTap: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (dialogContext) => CustomBottomSheet(
                title: 'Restore Data',
                child: RestoreDialog(
                  onSuccess: () async {
                    await Future.delayed(Duration(milliseconds: 1500));

                    if (context.mounted) {
                      dialogContext.pop();
                      context.replace(Routes.main);
                    }
                  },
                ),
              ),
            );
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
