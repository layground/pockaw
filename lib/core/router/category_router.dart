import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/category/presentation/screens/category_form_screen.dart';
import 'package:pockaw/features/category_picker/presentation/screens/category_picker_screen.dart';

class CategoryRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.categoryList,
      builder: (context, state) => const CategoryPickerScreen(),
    ),
    GoRoute(
      path: Routes.categoryListPickingParent,
      builder: (context, state) =>
          const CategoryPickerScreen(isPickingParent: true),
    ),
    GoRoute(
      path: Routes.categoryForm,
      builder: (context, state) => const CategoryFormScreen(),
    ),
  ];
}
