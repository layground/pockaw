import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/category_picker/presentation/screens/category_picker_screen.dart';

class CategoryRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.categoryList,
      builder: (context, state) => const CategoryPickerScreen(),
    ),
  ];
}
