import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/authentication_router.dart';
import 'package:pockaw/core/router/onboarding_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/router/transaction_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: Routes.index,
  routes: [
    ...OnboardingRouter.routes,
    ...AuthenticationRouter.routes,
    ...TransactionRouter.routes,
  ],
);
