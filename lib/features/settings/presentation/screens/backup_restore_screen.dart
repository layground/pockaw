import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/menu_tile_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/backup_and_restore/presentation/components/backup_dialog.dart';
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
              icon: HugeIcons.strokeRoundedDatabaseExport,
              suffixIcon: null,
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
          ],
        ),
      ),
    );
  }
}
