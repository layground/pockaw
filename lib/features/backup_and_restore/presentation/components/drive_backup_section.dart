import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/menu_tile_button.dart';
import 'package:pockaw/core/components/progress/custom_progress_bar.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/backup_and_restore/presentation/components/drive_backup_dialogs.dart';
import 'package:pockaw/core/services/drive_backup_service/drive_backup_provider.dart';

class DriveBackupSection extends HookConsumerWidget {
  const DriveBackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driveBackupProvider);
    final notifier = ref.read(driveBackupProvider.notifier);

    return Column(
      spacing: AppSpacing.spacing8,
      children: [
        if (state.isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CustomProgressBar(),
          ),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              state.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        MenuTileButton(
          label: 'Backup to Google Drive',
          subtitle: const Text('Save your data securely in the cloud'),
          icon: HugeIcons.strokeRoundedCloudUpload,
          onTap: () async {
            if (state.isLoading) return;

            final overwriteExisting = await showDriveBackupDialog(context);
            if (overwriteExisting == true) {
              if (!context.mounted) return;
              await showBackupProgressDialog(
                context,
                ref,
                'Backing up data...',
                'This might take a few minutes. Please keep the app open.',
                () => notifier.backupToDrive(overwriteExisting: true),
              );
            }
          },
        ),
        MenuTileButton(
          label: 'Restore from Google Drive',
          icon: HugeIcons.strokeRoundedCloudDownload,
          subtitle: const Text('Restore your data from a backup'),
          onTap: () async {
            if (state.isLoading) return;

            final shouldRestore = await showDriveRestoreDialog(context);
            if (shouldRestore == true) {
              if (!context.mounted) return;
              await showBackupProgressDialog(
                context,
                ref,
                'Restoring data...',
                'This might take a few minutes. Please keep the app open.',
                () => notifier.restoreFromDrive(),
              );
            }
          },
        ),
      ],
    );
  }
}
