part of '../screens/dashboard_screen.dart';

class ActionButton extends ConsumerWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Row(
      spacing: context.isDesktopLayout
          ? AppSpacing.spacing16
          : AppSpacing.spacing8,
      children: [
        ThemeModeSwitcher(),
        CustomIconButton(
          context,
          onPressed: () => context.push(Routes.comingSoon),
          icon: HugeIcons.strokeRoundedNotification02,
          showBadge: true,
          themeMode: context.themeMode,
        ),
        CustomIconButton(
          context,
          onPressed: () {
            context.push(Routes.settings);
          },
          icon: HugeIcons.strokeRoundedSettings01,
          themeMode: context.themeMode,
        ),
      ],
    );
  }
}
