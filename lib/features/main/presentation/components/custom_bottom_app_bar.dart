import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/features/main/presentation/components/desktop_sidebar.dart';
import 'package:pockaw/features/main/presentation/components/mobile_bottom_app_bar.dart';

class CustomBottomAppBar extends ConsumerWidget {
  static const double desktopSidebarWidth = 220.0; // Increased width for text
  final PageController pageController;
  const CustomBottomAppBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TargetPlatform platform = Theme.of(context).platform;
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

    if (kIsWeb || isDesktop) {
      return DesktopSidebar(pageController: pageController);
    } else {
      return MobileBottomAppBar(pageController: pageController);
    }
  }
}
