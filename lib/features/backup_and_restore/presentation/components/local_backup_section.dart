part of '../../../settings/presentation/screens/backup_restore_screen.dart';

class LocalBackupSection extends HookConsumerWidget {
  const LocalBackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    Future<void> backup() async {
      Toast.show(
        'Starting backup...',
        type: ToastificationType.info,
      );
      final path = await ref.read(dataBackupServiceProvider).backupData();
      if (path) {
        Toast.show(
          'Backup saved to:\n$path',
          type: ToastificationType.success,
        );

        await ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.backupCreated);

        if (context.mounted) {
          context.pop();
          context.replace(Routes.main);
        }
      } else {
        Toast.show(
          'Backup failed or cancelled.',
          type: ToastificationType.error,
        );

        await ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.backupFailed);
      }
    }

    Future<void> restore() async {
      isLoading.value = true;

      Toast.show('Starting restore...', type: ToastificationType.info);
      final success = await ref.read(dataBackupServiceProvider).restoreData();

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

        await Future.delayed(
          const Duration(milliseconds: 1500),
        );

        await ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.backupRestored);

        if (context.mounted) {
          context.pop();
          context.replace(Routes.main);
        }
      } else {
        await ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.restoreFailed);

        isLoading.value = false;
        Toast.show(
          'Restore failed or cancelled.',
          type: ToastificationType.error,
        );
      }
    }

    return Column(
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
              child: AlertBottomSheet(
                context: context,
                title: 'Backup Data',
                confirmText: 'Select Directory for Backup',
                onConfirm: backup,
                showCancelButton: false,
                content: BackupDialog(),
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
              child: AlertBottomSheet(
                title: 'Restore Data',
                context: context,
                confirmText: 'Select Backup Folder',
                onConfirm: restore,
                showCancelButton: false,
                content: RestoreDialog(),
              ),
            );
          },
        ),
      ],
    );
  }
}
