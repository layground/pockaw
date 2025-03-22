import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/authentication_router.dart';
import 'package:pockaw/core/router/budget_router.dart';
import 'package:pockaw/core/router/category_router.dart';
import 'package:pockaw/core/router/goal_router.dart';
import 'package:pockaw/core/router/onboarding_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/router/settings_router.dart';
import 'package:pockaw/core/router/transaction_router.dart';
import 'package:pockaw/features/currency_picker/presentation/screens/currency_list_tiles.dart';
import 'package:pockaw/features/splash/presentation/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final rootNavKey = GlobalKey<NavigatorState>();

final authProvider = FutureProvider<bool>((ref) async {
  await Future.delayed(const Duration(milliseconds: 1800));
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('has_session') ?? false;
});

// GoRouter configuration
final router = GoRouter(
  initialLocation: Routes.splash,
  navigatorKey: rootNavKey,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    ...OnboardingRouter.routes,
    ...AuthenticationRouter.routes,
    ...TransactionRouter.routes,
    ...CategoryRouter.routes,
    ...GoalRouter.routes,
    ...BudgetRouter.routes,
    ...SettingsRouter.routes,
    GoRoute(
      path: Routes.currencyListTile,
      builder: (context, state) => const CurrencyListTiles(),
    ),
  ],
);
