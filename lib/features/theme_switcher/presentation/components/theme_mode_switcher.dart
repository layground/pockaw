import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class ThemeModeSwitcher extends ConsumerWidget {
  const ThemeModeSwitcher({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomIconButton(
      context,
      onPressed: () {
        // Toggle theme mode
        ref.read(themeModeProvider.notifier).toggleThemeMode();
      },
      icon: context.themeMode == ThemeMode.light
          ? HugeIcons.strokeRoundedMoon02
          : HugeIcons.strokeRoundedSun01,
      themeMode: context.themeMode,
    );
  }
}
