import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class ThemeModeSwitcher extends ConsumerWidget {
  const ThemeModeSwitcher({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.watch(themeModeProvider.notifier);

    return CustomIconButton(
      onPressed: () {
        // Toggle theme mode
        themeModeNotifier.toggleThemeMode();
      },
      icon: themeMode == ThemeMode.light
          ? HugeIcons.strokeRoundedMoon01
          : HugeIcons.strokeRoundedSun01,
    );
  }
}
