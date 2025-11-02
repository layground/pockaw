import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/checkboxes/custom_checkbox.dart';
import 'package:pockaw/core/components/progress/custom_progress_bar.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/button_type.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:go_router/go_router.dart';

Future<bool?> showDriveBackupDialog(BuildContext context) async {
  bool overwriteExisting = false;

  return context.openBottomSheet<bool>(
    child: StatefulBuilder(
      builder: (context, setState) => CustomBottomSheet(
        title: 'Backup to Google Drive',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This will backup your data to Google Drive:\n'
              '• All transactions and categories\n'
              '• Goals and budgets\n'
              '• Settings and preferences\n'
              '• Images and attachments',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            CustomCheckbox(
              value: overwriteExisting,
              onChanged: (value) {
                setState(() => overwriteExisting = value ?? false);
              },
              label: 'Overwrite last backup to save space',
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton(
                  context: context,
                  onPressed: () => context.pop(false),
                  label: 'Cancel',
                ),
                const SizedBox(width: 8),
                PrimaryButton(
                  type: ButtonType.primary,
                  state: ButtonState.active,
                  onPressed: () => context.pop(overwriteExisting),
                  label: 'Continue',
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Shows a confirmation dialog for Google Drive restore
Future<bool?> showDriveRestoreDialog(BuildContext context) {
  return context.openBottomSheet<bool>(
    child: CustomBottomSheet(
      title: 'Restore from Google Drive',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'This will restore your data from the most recent Google Drive backup:\n'
            '• All existing data will be replaced\n'
            '• This cannot be undone\n'
            '• Make sure you have a recent backup',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                context: context,
                onPressed: () => context.pop(false),
                label: 'Cancel',
              ),
              const SizedBox(width: 8),
              PrimaryButton(
                type: ButtonType.primary,
                state: ButtonState.active,
                onPressed: () => context.pop(true),
                label: 'Continue',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Shows a confirmation dialog for overwriting existing backup
Future<bool?> showOverwriteConfirmationDialog(BuildContext context) {
  return context.openBottomSheet<bool>(
    child: CustomBottomSheet(
      title: 'Overwrite Backup',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'This will permanently delete your previous backup. Are you sure?',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                context: context,
                onPressed: () => context.pop(false),
                label: 'Cancel',
              ),
              const SizedBox(width: 8),
              PrimaryButton(
                type: ButtonType.primary,
                state: ButtonState.active,
                onPressed: () => context.pop(true),
                label: 'Overwrite',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Shows a progress dialog for backup/restore operations
Future<void> showBackupProgressDialog(
  BuildContext context,
  WidgetRef ref,
  String title,
  String message,
  Future<bool> Function() operation,
) async {
  return context
      .openBottomSheet(
        child: CustomBottomSheet(
          title: title,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              const CustomProgressBar(),
            ],
          ),
        ),
      )
      .then((value) async {
        final success = await operation();
        if (success && context.mounted) {
          context.pop(); // Close progress dialog
        }
      });
}
