import 'package:go_router/go_router.dart';
import 'package:pockaw/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:pockaw/router/routes.dart';

class OnboardingRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.index,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ];
}
