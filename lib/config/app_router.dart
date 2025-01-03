import 'package:go_router/go_router.dart';
import 'package:pockaw/ui/screens/dashboard/dashboard_screen.dart';
import 'package:pockaw/ui/screens/home_screen/home_screen.dart';
import 'package:pockaw/ui/screens/login_screen/login_screen.dart';
import 'package:pockaw/ui/screens/onboarding_screen/onboarding_screen.dart';
import 'package:pockaw/ui/screens/transaction_form/transaction_form.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: AppRouter.index,
  routes: [
    GoRoute(
      path: AppRouter.index,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRouter.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRouter.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRouter.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRouter.transactionForm,
      builder: (context, state) => TransactionForm(),
    ),
  ],
);

class AppRouter {
  static const String index = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String transactionForm = '/transaction-form';
}
