import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/presentation/screens/budget_details_screen.dart';

class BudgetRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.budgetDetails,
      builder: (context, state) => const BudgetDetailsScreen(),
    ),
  ];
}
