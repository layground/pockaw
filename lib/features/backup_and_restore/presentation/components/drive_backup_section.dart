part of '../../../settings/presentation/screens/backup_restore_screen.dart';

class DriveBackupSection extends ConsumerWidget {
  const DriveBackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driveBackupProvider);
    final notifier = ref.read(driveBackupProvider.notifier);

    return Column(
      spacing: AppSpacing.spacing8,
      children: [
        MenuTileButton(
          label: 'Backup to Google Drive',
          subtitle: const Text('Save your data securely in the cloud'),
          icon: HugeIcons.strokeRoundedCloudUpload,
          onTap: () {
            if (state.isLoading) return;

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
            if (state.isLoading) return;

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
                  await notifier.restoreFromDrive();
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
                state.isLoading
                    ? 'Backup in progress...'
                    : 'Google Drive Backup Status',
                style: AppTextStyles.body3.bold,
              ),
              state.isLoading
                  ? LinearProgressIndicator(
                      value: state.progress,
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.radius12),
                      minHeight: 6.0,
                    )
                  : Text(
                      state.error != null
                          ? 'Error: ${state.error}'
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
