import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_constants.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/app_router.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    );
    const buttonMinimumSize = Size.fromHeight(48);

    // Define the light theme using the standard ThemeData
    final lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: AppConstants.fontFamilyPrimary,
      scaffoldBackgroundColor: AppColors.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primary100,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryAlpha10,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiary100,
        error: AppColors.red,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintStyle: AppTextStyles.body3.copyWith(color: AppColors.neutral300),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: buttonMinimumSize,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.spacing20),
          backgroundColor: context.colors.secondaryContainer,
          side: const BorderSide(color: AppColors.purpleAlpha10),
          minimumSize: buttonMinimumSize,
          shape: buttonShape,
          foregroundColor: AppColors.purple,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonMinimumSize,
          shape: buttonShape,
        ),
      ),
    );

    // Define the dark theme using the standard ThemeData
    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppConstants.fontFamilyPrimary,
      scaffoldBackgroundColor: AppColors.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary400,
        primaryContainer: AppColors.primary900,
        secondary: AppColors.secondary400,
        secondaryContainer: AppColors.secondaryAlpha25,
        tertiary: AppColors.tertiary400,
        tertiaryContainer: AppColors.tertiary900,
        error: AppColors.red400,
      ),
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.dark),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintStyle: AppTextStyles.body3.copyWith(color: AppColors.neutral600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: buttonMinimumSize,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.spacing20),
          backgroundColor: AppColors.secondaryAlpha10,
          side: const BorderSide(color: AppColors.purpleAlpha10),
          minimumSize: buttonMinimumSize,
          shape: buttonShape,
          foregroundColor: AppColors.light,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonMinimumSize,
          shape: buttonShape,
        ),
      ),
    );

    return ToastificationWrapper(
      child: MaterialApp.router(
        key: rootKey,
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode, // Set the theme mode from the provider
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(
              start: 0,
              end: AppConstants.mobileBreakpointEnd,
              name: MOBILE,
            ),
            const Breakpoint(
              start: AppConstants.tabletBreakpointStart,
              end: AppConstants.tabletBreakpointEnd,
              name: TABLET,
            ),
            const Breakpoint(
              start: AppConstants.desktopBreakpointStart,
              end: AppConstants.desktopBreakpointEnd,
              name: DESKTOP,
            ),
            const Breakpoint(
              start: AppConstants.fourKBreakpointStart,
              end: double.infinity,
              name: '4K',
            ),
          ],
        ),
        routerConfig: router,
      ),
    );
  }
}
