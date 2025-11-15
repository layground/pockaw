import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/user_activities_table.dart';

part 'user_activity_dao.g.dart';

@DriftAccessor(tables: [UserActivities])
class UserActivityDao extends DatabaseAccessor<AppDatabase>
    with _$UserActivityDaoMixin {
  // Called by the generated code
  final AppDatabase db;
  UserActivityDao(this.db) : super(db);

  /// Insert a prepared companion or create from fields via `logActivity`.
  Future<int> createActivity(UserActivitiesCompanion entry) =>
      into(userActivities).insert(entry);

  /// Convenience helper to log a quick activity.
  Future<void> logActivity({
    required int userId,
    int? subjectId,
    required String action,
    bool success = true,
    String? appVersion,
    String? deviceModel,
    String? metadata,
  }) async {
    final companion = UserActivitiesCompanion.insert(
      userId: userId,
      subjectId: Value(subjectId),
      action: action,
      timestamp: Value(DateTime.now()),
      appVersion: Value(appVersion),
      deviceModel: Value(deviceModel),
      success: Value(success),
      metadata: Value(metadata),
    );

    await into(userActivities).insert(companion);
  }

  Future<List<UserActivity>> getAllActivities() => select(userActivities).get();

  Future<List<UserActivity>> getByUserId(int userId) =>
      (select(userActivities)..where((t) => t.userId.equals(userId))).get();

  Stream<List<UserActivity>> watchByUserId(int userId) =>
      (select(userActivities)..where((t) => t.userId.equals(userId))).watch();

  Future<int> deleteOlderThan(DateTime time) => (delete(
    userActivities,
  )..where((t) => t.timestamp.isSmallerOrEqualValue(time))).go();
}
