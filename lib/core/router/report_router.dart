import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/reports/presentation/screens/basic_monthly_report_screen.dart';

class ReportRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.basicMonthlyReports,
      builder: (context, state) {
        return BasicMonthlyReportScreen();
      },
    ),
  ];
}
