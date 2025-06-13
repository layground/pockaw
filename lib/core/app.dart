import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_constants.dart';
import 'package:pockaw/core/router/app_router.dart';
import 'package:toastification/toastification.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
          surfaceTint: AppColors.light,
          appBarBackground: Colors.white,
          scaffoldBackground: Colors.white,
          useMaterial3: true,
          fontFamily: AppConstants.fontFamilyPrimary,
        ),
        routerConfig: router,
      ),
    );
  }
}
