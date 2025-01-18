import 'package:go_router/go_router.dart';
import 'package:pockaw/features/authentication/presentation/screens/login_screen.dart';
import 'package:pockaw/features/main/presentation/screens/main_screen.dart';
import 'package:pockaw/router/routes.dart';

class AuthenticationRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.main,
      builder: (context, state) => const MainScreen(),
    ),
  ];
}
