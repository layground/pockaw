import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';

class RestoreDialog extends StatelessWidget {
  final Function? onStart;
  final Function? onSuccess;
  final Function? onFailed;
  const RestoreDialog({super.key, this.onStart, this.onSuccess, this.onFailed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HugeIcon(icon: HugeIcons.strokeRoundedInformationSquare),
        Gap(AppSpacing.spacing12),
        Text(
          'Restoring will overwrite all existing data. Restore data will only access and import the folder containing your backup files with this format:',
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
          'Nothing transmitted to the cloud. Your data remain secure during this process.',
          style: AppTextStyles.body3,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
