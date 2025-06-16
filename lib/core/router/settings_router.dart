import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/settings/presentation/screens/account_deletion_screen.dart';
import 'package:pockaw/features/settings/presentation/screens/settings_screen.dart';

class SettingsRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: Routes.accountDeletion,
      builder: (context, state) => const AccountDeletionScreen(),
    ),
  ];
}
