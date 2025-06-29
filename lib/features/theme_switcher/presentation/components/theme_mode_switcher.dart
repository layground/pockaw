import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class ThemeModeSwitcher extends ConsumerWidget {
  final ThemeMode themeMode;
  const ThemeModeSwitcher({super.key, required this.themeMode});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomIconButton(
      onPressed: () {
        // Toggle theme mode
        ref.read(themeModeProvider.notifier).toggleThemeMode();
      },
      icon: themeMode == ThemeMode.light
          ? HugeIcons.strokeRoundedMoon01
          : HugeIcons.strokeRoundedSun01,
      context: context,
      themeMode: themeMode,
    );
  }
}
