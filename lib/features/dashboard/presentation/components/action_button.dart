part of '../screens/dashboard_screen.dart';

class ActionButton extends ConsumerWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Row(
      spacing: context.isDesktopLayout
          ? AppSpacing.spacing16
          : AppSpacing.spacing8,
      children: [
        ThemeModeSwitcher(themeMode: themeMode),
        CustomIconButton(
          onPressed: () => context.push(Routes.comingSoon),
          icon: HugeIcons.strokeRoundedNotification02,
          showBadge: true,
          context: context,
          themeMode: themeMode,
        ),
        CustomIconButton(
          onPressed: () {
            context.push(Routes.settings);
          },
          icon: HugeIcons.strokeRoundedSettings01,
          context: context,
          themeMode: themeMode,
        ),
      ],
    );
  }
}
