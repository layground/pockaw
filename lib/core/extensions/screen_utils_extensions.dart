import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_constants.dart';

extension ScreenUtilsExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;

  bool get isDesktop {
    final TargetPlatform platform = Theme.of(this).platform;
    bool isDesktop = false;
    switch (platform) {
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        isDesktop = true;
        break;
      default:
        isDesktop = false;
    }
    return isDesktop;
  }

  /// Determines if the layout should be for a desktop-sized screen.
  /// This is based on screen width and is more reliable for responsive UI
  /// than checking the OS platform.
  bool get isDesktopLayout {
    return MediaQuery.of(this).size.width >=
        AppConstants.desktopBreakpointStart;
  }

  /// Determines if the layout should be for a tablet-sized screen.
  bool get isTabletLayout {
    final width = MediaQuery.of(this).size.width;
    // Corresponds to the TABLET breakpoint in responsive_framework
    return width >= AppConstants.tabletBreakpointStart &&
        width < AppConstants.desktopBreakpointStart;
  }

  /// Determines if the layout should be for a mobile-sized screen.
  bool get isMobileLayout {
    // Corresponds to the MOBILE breakpoint in responsive_framework
    return MediaQuery.of(this).size.width < AppConstants.tabletBreakpointStart;
  }
}
