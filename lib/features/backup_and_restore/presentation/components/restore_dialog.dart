import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/daos/user_dao.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/data_backup_service/data_backup_service_provider.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:toastification/toastification.dart';

class RestoreDialog extends ConsumerWidget {
  final Function? onStart;
  final Function? onSuccess;
  final Function? onFailed;
  const RestoreDialog({super.key, this.onStart, this.onSuccess, this.onFailed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataBackupService = ref.read(dataBackupServiceProvider);
    Future<void> restore() async {
      onStart?.call();

      Toast.show('Starting restore...', type: ToastificationType.info);
      final success = await dataBackupService.restoreData();

      if (success) {
        Toast.show(
          'Data restored successfully!',
          type: ToastificationType.success,
        );
        // Optionally, restart app or refresh all data providers
        // For now, just show toast. User might need to restart for full effect.

        final user = await ref.read(userDaoProvider).getFirstUser();
        if (user == null) {
          Toast.show('Restore failed.', type: ToastificationType.error);
          return;
        }

        final userModel = user.toModel();
        ref.read(authStateProvider.notifier).setUser(userModel);
        await ref.read(activeWalletProvider.notifier).initializeActiveWallet();

        if (context.mounted) context.replace(Routes.main);

        onSuccess?.call();
      } else {
        Toast.show(
          'Restore failed or cancelled.',
          type: ToastificationType.error,
        );
        onFailed?.call();
      }
    }

    return Column(
      children: [
        Icon(HugeIcons.strokeRoundedInformationSquare),
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
          'Your data remain secure during this process.',
          style: AppTextStyles.body3,
          textAlign: TextAlign.center,
        ),
        Gap(AppSpacing.spacing48),
        SecondaryButton(
          context: context,
          onPressed: restore,
          label: 'Select Backup Folder',
          icon: HugeIcons.strokeRoundedDatabaseImport,
        ),
      ],
    );
  }
}
