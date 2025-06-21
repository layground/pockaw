import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/presentation/screens/budget_details_screen.dart';
import 'package:pockaw/features/budget/presentation/screens/budget_form_screen.dart';

class BudgetRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: '${Routes.budgetDetails}/:budgetId',
      builder: (context, state) {
        final budgetId =
            int.tryParse(state.pathParameters['budgetId'] ?? '') ?? 0;
        return BudgetDetailsScreen(budgetId: budgetId);
      },
    ),

    GoRoute(
      path: '${Routes.budgetForm}/edit/:budgetId', // For editing
      builder: (context, state) {
        final budgetId = int.tryParse(state.pathParameters['budgetId'] ?? '');
        // budgetId can be null if it's not a valid int, handle appropriately
        return BudgetFormScreen(budgetId: budgetId);
      },
    ),
    GoRoute(
      path: Routes.budgetForm,
      builder: (context, state) => const BudgetFormScreen(),
    ),
  ];
}
