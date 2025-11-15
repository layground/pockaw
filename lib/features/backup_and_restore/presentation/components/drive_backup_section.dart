/* import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/menu_tile_button.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/progress/custom_progress_bar.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/services/google/google_drive_service.dart';

class DriveBackupSection extends HookConsumerWidget {
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
              child: Container(),
              builder: (dialogContext) => CustomBottomSheet(
                title: 'Backup Data',
                child: Column(
                  children: [
                    Text(
                      'This will backup your data to Google Drive:\n'
                      '• All transactions and categories\n'
                      '• Goals and budgets\n'
                      '• Settings and preferences\n'
                      '• Images and attachments',
                      style: AppTextStyles.body3,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(24),
                    SecondaryButton(
                      context: context,
                      onPressed: () async {
                        context.pop();
                        await notifier.backupToDrive();
                      },
                      label: 'Start Backup',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        MenuTileButton(
          label: 'Restore from Google Drive',
          icon: HugeIcons.strokeRoundedCloudDownload,
          subtitle: const Text('Restore your data from a backup'),
          onTap: () {
            if (state.isLoading) return;
            context.openBottomSheet(
              isScrollControlled: false,
              child: Container(),
              builder: (dialogContext) => CustomBottomSheet(
                title: 'Restore Data',
                child: Column(
                  children: [
                    Text(
                      'This will restore your data from the most recent Google Drive backup:\n'
                      '• All existing data will be replaced\n'
                      '• This cannot be undone\n'
                      '• Make sure you have a recent backup',
                      style: AppTextStyles.body3,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(24),
                    SecondaryButton(
                      context: context,
                      onPressed: () async {
                        context.pop();
                        await notifier.restoreFromDrive();
                      },
                      label: 'Start Restore',
                    ),
                  ],
                ),
              ),
            );
          },
        ),

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
      ],
    );
  }
}
 */
