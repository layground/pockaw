import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/app.dart';
import 'package:pockaw/core/components/placeholders/placeholder_screen.dart';

import 'package:pockaw/core/router/authentication_router.dart';
import 'package:pockaw/core/router/budget_router.dart';
import 'package:pockaw/core/router/category_router.dart';
import 'package:pockaw/core/router/currency_router.dart';
import 'package:pockaw/core/router/goal_router.dart'; // ← import your GoalRouter
import 'package:pockaw/core/router/onboarding_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/router/settings_router.dart';
import 'package:pockaw/core/router/transaction_router.dart';
import 'package:pockaw/core/router/wallet_router.dart';
import 'package:pockaw/features/splash/presentation/screens/splash_screen.dart';

final rootNavKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavKey,
  initialLocation: Routes.splash,
  observers: <NavigatorObserver>[MyApp.observer],
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.comingSoon,
      builder: (context, state) => const PlaceholderScreen(),
    ),

    // feature‐specific sub‐routers:
    ...OnboardingRouter.routes,
    ...AuthenticationRouter.routes,
    ...TransactionRouter.routes,
    ...CategoryRouter.routes,
    ...GoalRouter.routes,
    ...BudgetRouter.routes,
    ...SettingsRouter.routes,
    ...CurrencyRouter.routes,
    ...WalletRouter.routes,
  ],
);
