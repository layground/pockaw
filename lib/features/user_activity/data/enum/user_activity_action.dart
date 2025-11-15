/// Enum representing types of user activities that we track in the app.
///
/// Use the `.toJson()` / `userActivityActionFromJson()` helpers when
/// serializing to/from strings (for JSON, DB export, or logging).
enum UserActivityAction {
  // Authentication
  signIn,
  signInWithSession,
  signOut,

  // Onboarding / journey
  onboardingCompleted,
  journeyStarted,
  journeyCompleted,

  // App lifecycle
  appLaunched,

  // Permissions
  permissionGranted,
  permissionRevoked,

  // Backup / restore
  backupCreated,
  backupRestored,
  backupFailed,
  restoreFailed,

  cloudBackupCreated,
  cloudBackupRestored,
  cloudBackupFailed,
  cloudRestoreFailed,

  // Import / export
  importCompleted,
  exportCompleted,

  // CRUD actions for domain objects
  transactionCreated,
  transactionUpdated,
  transactionDeleted,

  budgetCreated,
  budgetUpdated,
  budgetDeleted,

  goalCreated,
  goalUpdated,
  goalDeleted,

  walletSelected,
  walletCreated,
  walletUpdated,
  walletDeleted,

  categoryCreated,
  categoryUpdated,
  categoryDeleted,

  // Media
  imageUploaded,
  imageDeleted,

  // Profile / settings
  profileUpdated,
  settingsUpdated,

  // Data management
  databaseCleared,
}

/// Convert enum to a simple string name for JSON/DB.
String userActivityActionToJson(UserActivityAction action) =>
    action.toString().split('.').last;

/// Convert string name back to enum. Returns `null` if input is null.
UserActivityAction? userActivityActionFromJson(String? name) {
  if (name == null) return null;
  return UserActivityAction.values.firstWhere(
    (e) => e.toString().split('.').last == name,
    orElse: () => UserActivityAction.appLaunched,
  );
}
