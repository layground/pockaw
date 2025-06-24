import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/extensions/screen_utils_extensions.dart';
import 'package:pockaw/features/main/presentation/components/desktop_sidebar.dart';
import 'package:pockaw/features/main/presentation/components/mobile_bottom_app_bar.dart';

class CustomBottomAppBar extends ConsumerWidget {
  final PageController pageController;
  const CustomBottomAppBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (context.isDesktopLayout) {
      return DesktopSidebar(pageController: pageController);
    } else {
      return MobileBottomAppBar(pageController: pageController);
    }
  }
}
