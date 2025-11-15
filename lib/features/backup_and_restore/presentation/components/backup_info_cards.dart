part of '../../../settings/presentation/screens/backup_restore_screen.dart';

/// Provides last backup info (folder, timestamp, success) for current user.
final _lastActivityInfoProvider =
    FutureProvider.autoDispose<Map<String, Map<String, dynamic>>?>((ref) async {
      final user = ref.read(authStateProvider);
      final uid = user.id;
      if (uid == null) return null;

      final dao = ref.read(userActivityDaoProvider);
      final activities = await dao.getByUserId(uid);

      // backup-related actions (local and cloud)
      final backupActions = [
        UserActivityAction.backupCreated,
        UserActivityAction.backupFailed,
        UserActivityAction.cloudBackupCreated,
        UserActivityAction.cloudBackupFailed,
      ].map(userActivityActionToJson).toSet();

      // restore-related actions (local and cloud)
      final restoreActions = [
        UserActivityAction.backupRestored,
        UserActivityAction.restoreFailed,
        UserActivityAction.cloudBackupRestored,
        UserActivityAction.cloudRestoreFailed,
      ].map(userActivityActionToJson).toSet();

      // helper to pick the latest activity from a set of action names
      Map<String, dynamic>? pickLatest(Set<String> actions) {
        final list = activities
            .where((a) => actions.contains(a.action))
            .toList();
        if (list.isEmpty) return null;
        list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        final latest = list.first;

        final createdBackupNames = {
          userActivityActionToJson(UserActivityAction.backupCreated),
          userActivityActionToJson(UserActivityAction.cloudBackupCreated),
        };
        final failedBackupNames = {
          userActivityActionToJson(UserActivityAction.backupFailed),
          userActivityActionToJson(UserActivityAction.cloudBackupFailed),
        };

        final restoredNames = {
          userActivityActionToJson(UserActivityAction.backupRestored),
          userActivityActionToJson(UserActivityAction.cloudBackupRestored),
        };
        final failedRestoreNames = {
          userActivityActionToJson(UserActivityAction.restoreFailed),
          userActivityActionToJson(UserActivityAction.cloudRestoreFailed),
        };

        bool? success;
        if (createdBackupNames.contains(latest.action) ||
            restoredNames.contains(latest.action)) {
          success = true;
        } else if (failedBackupNames.contains(latest.action) ||
            failedRestoreNames.contains(latest.action)) {
          success = false;
        } else {
          success = null;
        }

        return {
          'timestamp': latest.timestamp.toRelativeDayFormatted(
            showTime: true,
            use24Hours: false,
          ),
          'folder': latest.metadata ?? 'Unknown',
          'success': success,
          'message': latest.action,
        };
      }

      final backupInfo = pickLatest(backupActions);
      final restoreInfo = pickLatest(restoreActions);

      return {
        'backup': backupInfo ?? {},
        'restore': restoreInfo ?? {},
      };
    });

class BackupInfoCards extends StatelessWidget {
  const BackupInfoCards({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.spacing8,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer(
              builder: (context, ref, _) {
                final lastInfo = ref.watch(_lastActivityInfoProvider);
                final lastBackup = (lastInfo.asData?.value)?['backup'];

                // header / title
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: AppSpacing.spacing4,
                      children: [
                        HugeIcon(
                          icon: HugeIconsStrokeRounded.squareArrowUp03,
                          size: 14,
                        ),
                        Text(
                          'Backup info',
                          style: AppTextStyles.body3.bold,
                        ),
                      ],
                    ),
                    Divider(
                      color: context.breakLineColor,
                    ),
                    Text(
                      'Backup folder: ${lastBackup?['folder'] ?? '—'}',
                      style: AppTextStyles.body3,
                    ),
                    Text(
                      'Last action: ${lastBackup?['message']}',
                      style: AppTextStyles.body3,
                    ),
                    Text(
                      'Last backup: ${lastBackup?['timestamp'] ?? 'No backups yet'}',
                      style: AppTextStyles.body3,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        // Restore card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer(
              builder: (context, ref, _) {
                final lastInfo = ref.watch(_lastActivityInfoProvider);
                final lastRestore = (lastInfo.asData?.value)?['restore'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: AppSpacing.spacing4,
                      children: [
                        HugeIcon(
                          icon: HugeIconsStrokeRounded.squareArrowDown03,
                          size: 14,
                        ),
                        Text(
                          'Restore info',
                          style: AppTextStyles.body3.bold,
                        ),
                      ],
                    ),

                    Divider(
                      color: context.breakLineColor,
                    ),
                    Text(
                      'Source folder: ${lastRestore?['folder'] ?? '—'}',
                      style: AppTextStyles.body3,
                    ),
                    Text(
                      'Last action: ${lastRestore?['message']}',
                      style: AppTextStyles.body3,
                    ),
                    Text(
                      'Last restored: ${lastRestore?['timestamp'] ?? 'No restores yet'}',
                      style: AppTextStyles.body3,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
