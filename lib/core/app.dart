import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_constants.dart';
import 'package:pockaw/core/router/app_router.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // Define the light theme using FlexColorScheme and AppColors
    final lightTheme = FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: AppColors.primary,
        primaryContainer: AppColors.primary100,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondary100,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiary100,
        appBarColor: Colors.white, // Explicitly white for light mode AppBar
        error: AppColors.red,
      ),
      scaffoldBackground: AppColors.light, // Main background color
      useMaterial3: true,
      fontFamily: AppConstants.fontFamilyPrimary,
      subThemesData: FlexSubThemesData(
        blendOnLevel: 10, // Blend colors on surfaces
        blendOnColors: false, // Don't blend on primary/secondary
        defaultRadius: 8.0, // Consistent border radius
        inputDecoratorRadius: 8.0,
        buttonMinSize: Size.fromHeight(48), // Standard button height
      ),
    );

    // Define the dark theme using FlexColorScheme and AppColors
    final darkTheme = FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: AppColors.primary400, // Slightly lighter primary for dark mode
        primaryContainer: AppColors.primary900,
        secondary: AppColors.secondary400, // Slightly lighter secondary
        secondaryContainer: AppColors.secondaryAlpha25,
        tertiary: AppColors.tertiary400, // Slightly lighter tertiary
        tertiaryContainer: AppColors.tertiary900,
        appBarColor: AppColors.dark, // Explicitly dark for dark mode AppBar
        error: AppColors.red400, // Lighter red for dark mode
      ),
      scaffoldBackground: AppColors.dark, // Main background color
      useMaterial3: true,
      fontFamily: AppConstants.fontFamilyPrimary,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20, // More blending on dark surfaces
        blendOnColors: false,
        defaultRadius: 8.0,
        inputDecoratorRadius: 8.0,
        buttonMinSize: Size.fromHeight(48),
        outlinedButtonSchemeColor: SchemeColor.secondary,
      ),
    );

    return ToastificationWrapper(
      child: MaterialApp.router(
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
