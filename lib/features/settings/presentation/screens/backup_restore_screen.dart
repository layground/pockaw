import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/menu_tile_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/backup_and_restore/presentation/components/backup_dialog.dart';
// import 'package:pockaw/features/backup_and_restore/presentation/components/drive_backup_section.dart';
import 'package:pockaw/features/backup_and_restore/presentation/components/restore_dialog.dart';

enum BackupSchedule { daily, weekly, monthly }

class BackupRestoreScreen extends HookConsumerWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return CustomScaffold(
      context: context,
      title: 'Backup & Restore',
      showBalance: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
        child: Column(
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
                  child: Container(),
                  builder: (dialogContext) => CustomBottomSheet(
                    title: 'Backup Data',
                    child: BackupDialog(
                      onSuccess: () {
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
              label: 'Restore Data',
              subtitle: const Text('Restore your data from a local backup'),
              icon: HugeIcons.strokeRoundedDatabaseImport,
              onTap: () {
                context.openBottomSheet(
                  isScrollControlled: false,
                  child: Container(),
                  builder: (dialogContext) => CustomBottomSheet(
                    title: 'Restore Data',
                    child: RestoreDialog(
                      onSuccess: () async {
                        await Future.delayed(
                          const Duration(milliseconds: 1500),
                        );

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
            // DriveBackupSection(),
          ],
        ),
      ),
    );
  }
}
