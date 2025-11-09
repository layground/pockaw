import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_constants.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/app_router.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ToastificationWrapper(
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        themeMode: themeMode, // Set the theme mode from the provider
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(
                context,
              ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2),
            ),
            child: child!,
          ),
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
        // Add the observer to the router's navigator observers
        // Note: GoRouter automatically adds this to its navigator.
        // We just need to pass it in the constructor.
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = brightness == Brightness.light
        ? const ColorScheme.light(
            primary: AppColors.primary,
            primaryContainer: AppColors.primary100,
            secondary: AppColors.secondary,
            secondaryContainer: AppColors.secondaryAlpha10,
            tertiary: AppColors.tertiary,
            tertiaryContainer: AppColors.tertiary100,
            error: AppColors.red,
            surface: AppColors.light,
          )
        : const ColorScheme.dark(
            primary: AppColors.primary400,
            primaryContainer: AppColors.primary900,
            secondary: AppColors.secondary400,
            secondaryContainer: AppColors.secondaryAlpha25,
            tertiary: AppColors.tertiary400,
            tertiaryContainer: AppColors.tertiary900,
            error: AppColors.red400,
            surface: AppColors.dark,
          );

    // Use FlexThemeData.dark for the dark theme.
    final baseTheme = brightness == Brightness.light
        ? FlexThemeData.light(
            colorScheme: colorScheme,
            useMaterial3: true,
            fontFamily: AppConstants.fontFamilyPrimary,
          )
        : FlexThemeData.dark(
            colorScheme: colorScheme,
            useMaterial3: true,
            fontFamily: AppConstants.fontFamilyPrimary,
          );

    return baseTheme.copyWith(
      // Let FlexColorScheme handle the text theme colors.
      // If you need to override font size or weight, do it like this,
      // but avoid setting a specific color.
      textTheme: baseTheme.textTheme.copyWith(
        bodyMedium: AppTextStyles.body2.copyWith(
          color: colorScheme.onSurface, // Explicitly use theme color
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintStyle: AppTextStyles.body3, // Let the theme handle hint color
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        modalBarrierColor: colorScheme.shadow.withAlpha(180),
      ),
    );
  }
}
