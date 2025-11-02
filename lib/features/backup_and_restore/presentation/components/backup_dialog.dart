import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/core/services/data_backup_service/data_backup_service_provider.dart';
import 'package:toastification/toastification.dart';

class BackupDialog extends ConsumerWidget {
  final Function? onStart;
  final Function? onSuccess;
  final Function? onFailed;
  const BackupDialog({super.key, this.onStart, this.onSuccess, this.onFailed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataBackupService = ref.read(dataBackupServiceProvider);
    Future<void> backup() async {
      onStart?.call();

      Toast.show('Starting backup...', type: ToastificationType.info);
      final path = await dataBackupService.backupData();
      if (path != null) {
        Toast.show('Backup saved to:\n$path', type: ToastificationType.success);
        onSuccess?.call();
      } else {
        Toast.show(
          'Backup failed or cancelled.',
          type: ToastificationType.error,
        );
        onFailed?.call();
      }
    }

    return Column(
      children: [
        HugeIcon(icon: HugeIcons.strokeRoundedInformationSquare),
        Gap(AppSpacing.spacing12),
        Text(
          'Backup data will only create a folder containing your backup files with this format:',
          style: AppTextStyles.body3,
          textAlign: TextAlign.center,
        ),
        Gap(AppSpacing.spacing8),
        Text(
          '"Pockaw_Backup_[DateTime]"',
          style: AppTextStyles.body3.bold,
          textAlign: TextAlign.center,
        ),
        Gap(AppSpacing.spacing8),
        Text(
          'Your data remain secure during this process.',
          style: AppTextStyles.body3,
          textAlign: TextAlign.center,
        ),
        Gap(AppSpacing.spacing48),
        SecondaryButton(
          context: context,
          onPressed: backup,
          label: 'Select Folder for Backup',
          icon: HugeIcons.strokeRoundedDatabaseExport,
        ),
      ],
    );
  }
}
