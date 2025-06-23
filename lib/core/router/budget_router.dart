import 'package:go_router/go_router.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/presentation/screens/budget_details_screen.dart';
import 'package:pockaw/features/budget/presentation/screens/budget_form_screen.dart';

class BudgetRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.budgetDetails,
      builder: (context, state) {
        final budget = state.extra as Budget;
        return BudgetDetailsScreen(budget: budget);
      },
    ),
    GoRoute(
      path: Routes.budgetForm,
      builder: (context, state) => const BudgetFormScreen(),
    ),
  ];
}
