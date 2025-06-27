part of '../screens/dashboard_screen.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.isDesktopLayout
          ? AppSpacing.spacing16
          : AppSpacing.spacing0,
      children: [
        ThemeModeSwitcher(),
        CustomIconButton(
          onPressed: () {},
          icon: HugeIcons.strokeRoundedNotification02,
          showBadge: true,
        ),
        CustomIconButton(
          onPressed: () {
            context.push(Routes.settings);
          },
          icon: HugeIcons.strokeRoundedSettings01,
        ),
      ],
    );
  }
}
