import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/developer_portal/presentation/screens/developer_portal_screen.dart';
import 'package:pockaw/features/settings/presentation/screens/account_deletion_screen.dart';
import 'package:pockaw/features/settings/presentation/screens/backup_restore_screen.dart';
import 'package:pockaw/features/settings/presentation/screens/personal_details_screen.dart';
import 'package:pockaw/features/settings/presentation/screens/settings_screen.dart';

class SettingsRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: Routes.personalDetails,
      builder: (context, state) => const PersonalDetailsScreen(),
    ),
    GoRoute(
      path: Routes.backupAndRestore,
      builder: (context, state) => const BackupRestoreScreen(),
    ),
    GoRoute(
      path: Routes.accountDeletion,
      builder: (context, state) => const AccountDeletionScreen(),
    ),
    if (kDebugMode)
      GoRoute(
        path: Routes.developerPortal,
        builder: (context, state) => const DeveloperPortalScreen(),
      ),
  ];
}
