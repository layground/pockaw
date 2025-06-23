part of '../screens/dashboard_screen.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIconButton(
          onPressed: () {},
          iconWidget: Icon(TablerIcons.bell),
          showBadge: true,
        ),
        CustomIconButton(
          onPressed: () {
            context.push(Routes.settings);
          },
          iconWidget: Icon(TablerIcons.settings_2),
        ),
      ],
    );
  }
}
