import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/menu_tile_button.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/extensions/screen_utils_extensions.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/connectivity_service/connectivity_service.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/backup_and_restore/presentation/components/backup_dialog.dart';
import 'package:pockaw/features/backup_and_restore/presentation/components/restore_dialog.dart';
import 'package:pockaw/features/backup_and_restore/presentation/riverpod/backup_controller.dart';
import 'package:pockaw/features/user_activity/data/enum/user_activity_action.dart';
import 'package:pockaw/features/user_activity/riverpod/user_activity_provider.dart';
import 'package:toastification/toastification.dart';

part '../../../backup_and_restore/presentation/components/local_backup_section.dart';
part '../../../backup_and_restore/presentation/components/drive_backup_section.dart';
part '../../../backup_and_restore/presentation/components/backup_info_cards.dart';

enum BackupSchedule { daily, weekly, monthly }

class BackupRestoreScreen extends StatelessWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      title: 'Backup & Restore',
      showBalance: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
        child: Column(
          spacing: AppSpacing.spacing8,
          children: [
            LocalBackupSection(),
            Divider(color: context.breakLineColor),
            DriveBackupSection(),
          ],
        ),
      ),
    );
  }
}
