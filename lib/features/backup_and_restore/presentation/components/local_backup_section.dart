part of '../../../settings/presentation/screens/backup_restore_screen.dart';

class LocalBackupSection extends HookConsumerWidget {
  const LocalBackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupControllerProvider);

    return Column(
      spacing: AppSpacing.spacing8,
      children: [
        MenuTileButton(
          label: 'Backup Manually',
          subtitle: const Text('Create a backup of your data locally'),
          icon: HugeIcons.strokeRoundedDatabaseExport,
          suffixIcon: null,
          onTap: () {
            context.openBottomSheet(
              isScrollControlled: false,
              child: AlertBottomSheet(
                context: context,
                title: 'Backup Data',
                confirmText: 'Continue Backup',
                onConfirm: () async {
                  Toast.show(
                    'Starting backup...',
                    type: ToastificationType.info,
                  );

                  ref.read(backupControllerProvider.notifier).backupLocally();

                  context.pop();
                },
                showCancelButton: false,
                content: BackupDialog(),
              ),
            );
          },
        ),
        MenuTileButton(
          label: 'Restore Data',
          subtitle: const Text('Restore your data from a local backup'),
          icon: HugeIcons.strokeRoundedDatabaseImport,
          onTap: () {
            context.openBottomSheet(
              isScrollControlled: false,
              child: AlertBottomSheet(
                title: 'Restore Data',
                context: context,
                confirmText: 'Select Backup Folder',
                onConfirm: () async {
                  final success = await ref
                      .read(backupControllerProvider.notifier)
                      .restoreFromLocalFile();

                  if (success) {
                    if (context.mounted) {
                      context.pop();
                      context.replace(Routes.main);
                    }
                  }
                },
                showCancelButton: false,
                content: RestoreDialog(),
              ),
            );
          },
        ),
        // show local backup and restore info card. card contains backup directory and last action date time
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.radius12),
            border: Border.all(color: context.breakLineColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Local Backup Info',
                style: AppTextStyles.body4.bold,
              ),
              const Gap(AppSpacing.spacing8),
              Text(
                'Backup Directory: ${state.localDirectory ?? 'Not set'}',
                style: AppTextStyles.body4,
              ),
              const Gap(AppSpacing.spacing4),
              Text(
                'Last Backup Time: ${state.lastLocalBackupTime != null ? state.lastLocalBackupTime!.toDayMonthYearTime12Hour() : 'No backups yet'}',
                style: AppTextStyles.body4,
              ),
              // last restore time
              const Gap(AppSpacing.spacing4),
              Text(
                'Last Restore Time: ${state.lastLocalRestoreTime != null ? state.lastLocalRestoreTime!.toDayMonthYearTime12Hour() : 'No restores yet'}',
                style: AppTextStyles.body4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
