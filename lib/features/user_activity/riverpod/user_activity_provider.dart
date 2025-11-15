import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/daos/user_activity_dao.dart';
import 'package:pockaw/core/services/device_info/device_info.dart';
import 'package:pockaw/core/services/package_info/package_info_provider.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/user_activity/data/enum/user_activity_action.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Provider that exposes the [UserActivityDao] from the app database.
final userActivityDaoProvider = Provider<UserActivityDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.userActivityDao;
});

/// Simple service for logging user activities. Uses [Ref] to access the
/// database and auth providers.
class UserActivityService {
  final Ref ref;
  UserActivityService(this.ref);

  Future<void> logActivity({
    required UserActivityAction action,
    int? subjectId,
    bool success = true,
    String? metadata,
    int? userId,
  }) async {
    final db = ref.read(databaseProvider);

    // Resolve user id: explicit param -> auth state -> nothing
    final currentUser = ref.read(authStateProvider);
    final resolvedUserId = userId ?? currentUser.id;
    if (resolvedUserId == null) return; // nothing to log without a user id

    final actionName = userActivityActionToJson(action);

    // get device info using provider deviceInfoUtilProvider
    final deviceModel = await ref.read(deviceInfoUtilProvider).getDeviceModel();

    // get app version using packageInfoServiceProvider
    final appVersion = ref.read(packageInfoServiceProvider).version;

    await db.userActivityDao.logActivity(
      userId: resolvedUserId,
      subjectId: subjectId,
      action: actionName,
      success: success,
      appVersion: appVersion,
      deviceModel: deviceModel,
      metadata: metadata,
    );
  }

  /// share a log activity as json string
  Future<void> shareLogActivities() async {
    final db = ref.read(databaseProvider);
    // Fetch all activities and convert to json string
    final activities = await db.userActivityDao.getAllActivities();
    // Ensure timestamp is shared as integer (milliseconds since epoch)
    final json = activities.map((e) {
      final map = e.toJson();
      final ts = e.timestamp;
      map['timestamp'] = ts.toIso8601String();
      return map;
    }).toList();
    // share activities using share package

    final result = await SharePlus.instance.share(
      ShareParams(
        text: json.toString(),
        subject: 'User Activity Logs',
      ),
    );

    if (result.status == ShareResultStatus.success) {
      Log.d('successful', label: 'share activity log', logToFile: false);
    } else {
      Log.d('failed', label: 'share activity log', logToFile: false);
    }
  }
}

/// Provide a long-lived instance of [UserActivityService].
final userActivityServiceProvider = Provider<UserActivityService>((ref) {
  return UserActivityService(ref);
});
