import 'package:pockaw/ui/screens/expense_form_screen/expense_form_screen.dart';
import 'package:pockaw/ui/screens/home_screen/home_screen.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: AppRouter.index,
  routes: [
    GoRoute(
      path: AppRouter.index,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRouter.expenseForm,
      builder: (context, state) => const ExpenseFormScreen(),
    ),
  ],
);

class AppRouter {
  static const String index = '/';
  static const String expenseForm = '/expense-form';
}
