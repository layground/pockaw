import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/category_form/presentation/screens/category_form_screen.dart';
import 'package:pockaw/features/category_picker/presentation/screens/category_picker_screen.dart';

class CategoryRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.categoryList,
      builder: (context, state) {
        final String? initialType = state.extra as String?;
        print(
            '📝 CategoryRouter: Received initialType for CategoryPickerScreen: ${initialType}');
        return CategoryPickerScreen(initialType: initialType);
      },
    ),
    GoRoute(
      path: Routes.categoryListPickingParent,
      builder: (context, state) =>
          const CategoryPickerScreen(isPickingParent: true),
    ),
    GoRoute(
      path: Routes.categoryForm,
      builder: (context, state) {
        final String? initialType = state.extra as String?;
        print(
            '📝 CategoryRouter: Received initialType for CategoryFormScreen: ${initialType}');
        return CategoryFormScreen(initialType: initialType);
      },
    ),
  ];
}
