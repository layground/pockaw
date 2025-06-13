import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_details_screen.dart';

class GoalRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.goalDetails,
      builder: (context, state) {
        final goalId = state.extra as int;
        print('🗂️  Routing to GoalDetailsScreen for goalId=$goalId');
        return GoalDetailsScreen(goalId: goalId);
      },
    ),
  ];
}
