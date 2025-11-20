part of '../../../settings/presentation/screens/backup_restore_screen.dart';

class DriveBackupSection extends ConsumerWidget {
  const DriveBackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupControllerProvider);
    final notifier = ref.read(backupControllerProvider.notifier);

    return Column(
      spacing: AppSpacing.spacing8,
      children: [
        MenuTileButton(
          label: 'Backup to Google Drive',
          subtitle: const Text('Save your data securely in the cloud'),
          icon: HugeIcons.strokeRoundedCloudUpload,
          onTap: () {
            if (state.status == BackupStatus.loading) return;

            context.openBottomSheet(
              isScrollControlled: false,
              child: AlertBottomSheet(
                title: 'Backup Data',
                context: context,
                confirmText: 'Start Backup',
                showCancelButton: false,
                content: SizedBox(
                  width: context.screenSize.width * 0.7,
                  child: Text(
                    'This will backup your data to Google Drive:\n\n'
                    '• All transactions and categories\n'
                    '• Goals and budgets\n'
                    '• Settings and preferences\n'
                    '• Images and attachments',
                    style: AppTextStyles.body3,
                  ),
                ),
                onConfirm: () async {
                  context.pop();
                  await notifier.backupToDrive();
                },
              ),
            );
          },
        ),
        MenuTileButton(
          label: 'Restore from Google Drive',
          icon: HugeIcons.strokeRoundedCloudDownload,
          subtitle: const Text('Restore your data from a cloud backup'),
          onTap: () {
            if (state.status == BackupStatus.loading) return;

            context.openBottomSheet(
              isScrollControlled: false,
              child: AlertBottomSheet(
                title: 'Restore Data',
                context: context,
                confirmText: 'Start Restore',
                showCancelButton: false,
                content: SizedBox(
                  width: context.screenSize.width * 0.7,
                  child: Text(
                    'This will restore your data from the most recent Google Drive backup:\n\n'
                    '• All existing data will be replaced\n'
                    '• This cannot be undone\n'
                    '• Make sure you have a recent backup',
                    style: AppTextStyles.body3,
                  ),
                ),
                onConfirm: () async {
                  context.pop();
                  await notifier.fetchDriveBackups();
                  if (context.mounted) {
                    context.openBottomSheet(
                      isScrollControlled: false,
                      child: AlertBottomSheet(
                        title: 'Restore Data',
                        context: context,
                        confirmText: 'Start Restore',
                        showCancelButton: false,
                        content: SizedBox(
                          width: context.screenSize.height * 0.7,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.driveBackups.length,
                            itemBuilder: (context, index) {
                              final backup = state.driveBackups[index];
                              return ListTile(
                                title: Text(
                                  'Backup from ${backup.modifiedTime?.toLocal().toString().split('.').first ?? 'Unknown Date'}',
                                ),
                                subtitle: Text(
                                  'Size: ${(backup.size > 0) ? '${(backup.size / (1024 * 1024)).toStringAsFixed(2)} MB' : 'Unknown Size'}',
                                ),
                                onTap: () async {
                                  context.pop();
                                  await notifier.restoreFromDrive(backup.id);
                                },
                              );
                            },
                          ),
                        ),
                        onConfirm: () async {
                          context.pop();
                        },
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.spacing4,
            children: [
              Gap(AppSpacing.spacing2),
              Text(
                state.status == BackupStatus.loading
                    ? 'Backup in progress...'
                    : 'Google Drive Backup Status',
                style: AppTextStyles.body3.bold,
              ),
              state.status == BackupStatus.loading
                  ? LinearProgressIndicator(
                      value: state.status == BackupStatus.loading ? null : 0.0,
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.radius12),
                      minHeight: 6.0,
                    )
                  : Text(
                      state.status == BackupStatus.error
                          ? 'Error: ${state.message}'
                          : 'Perform backup or restore to see status',
                      style: AppTextStyles.body3,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
