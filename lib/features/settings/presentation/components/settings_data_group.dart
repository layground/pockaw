part of '../screens/settings_screen.dart';

class SettingsDataGroup extends ConsumerWidget {
  const SettingsDataGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataBackupService = ref.watch(dataBackupServiceProvider);

    return SettingsGroupHolder(
      title: 'Data Management',
      settingTiles: [
        MenuTileButton(
          label: 'Backup Data',
          icon: HugeIcons.strokeRoundedDatabaseExport,
          onTap: () async {
            Toast.show('Starting backup...', type: ToastificationType.info);
            final path = await dataBackupService.backupData();
            if (path != null) {
              Toast.show(
                'Backup saved to:\n$path',
                type: ToastificationType.success,
              );
            } else {
              Toast.show(
                'Backup failed or cancelled.',
                type: ToastificationType.error,
              );
            }
          },
        ),
        MenuTileButton(
          label: 'Restore Data',
          icon: HugeIcons.strokeRoundedDatabaseImport,
          onTap: () async {
            final confirmed =
                await showModalBottomSheet<bool>(
                  context: context,
                  showDragHandle: true,
                  builder: (ctx) => AlertBottomSheet(
                    title: 'Confirm Restore',
                    content: Text(
                      'Restoring will overwrite all existing data. Are you sure?',
                      style: AppTextStyles.body2,
                    ),
                    onConfirm: () => Navigator.pop(ctx, true),
                    onCancel: () => Navigator.pop(ctx, false),
                  ),
                ) ??
                false;

            if (!confirmed) return;

            Toast.show('Starting restore...', type: ToastificationType.info);
            final success = await dataBackupService.restoreData();
            if (success) {
              Toast.show(
                'Data restored successfully!',
                type: ToastificationType.success,
              );
              // Optionally, restart app or refresh all data providers
              // For now, just show toast. User might need to restart for full effect.
            } else {
              Toast.show(
                'Restore failed or cancelled.',
                type: ToastificationType.error,
              );
            }
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
