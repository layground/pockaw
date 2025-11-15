import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/daos/user_dao.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/core/services/data_backup_service/data_backup_service_provider.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:toastification/toastification.dart';

class RestoreDialog extends HookConsumerWidget {
  final Function? onStart;
  final Function? onSuccess;
  final Function? onFailed;
  const RestoreDialog({super.key, this.onStart, this.onSuccess, this.onFailed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataBackupService = ref.read(dataBackupServiceProvider);
    final isLoading = useState(false);
    Future<void> restore() async {
      onStart?.call();
      isLoading.value = true;

      Toast.show('Starting restore...', type: ToastificationType.info);
      final success = await dataBackupService.restoreData();

      if (success) {
        Toast.show(
          'Data restored successfully! refreshing app...',
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
        await ref.read(activeWalletProvider.notifier).refreshActiveWallet();
        isLoading.value = false;

        onSuccess?.call();
      } else {
        isLoading.value = false;
        Toast.show(
          'Restore failed or cancelled.',
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
          isLoading: isLoading.value,
        ),
      ],
    );
  }
}
