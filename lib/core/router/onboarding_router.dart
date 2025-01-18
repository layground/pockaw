import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/onboarding/presentation/screens/onboarding_screen.dart';

class OnboardingRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.index,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ];
}
