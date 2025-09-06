import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/utils/share_service.dart';

class ReportLogFileDialog extends StatelessWidget {
  const ReportLogFileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: 'Report Log File',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Log file is for development and investigation purposes only. '
            'Please only share this file with the developer.\n\n'
            'Log history is one-time session. It will be cleared everytime you open the app.',
            textAlign: TextAlign.center,
          ),
          Gap(AppSpacing.spacing32),
          PrimaryButton(
            label: 'Understand and Continue',
            onPressed: () async {
              await ShareService.shareLogFile();
              if (context.mounted) context.pop();
            },
          ),
        ],
      ),
    );
  }
}
