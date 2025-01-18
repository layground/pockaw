part of '../screens/dashboard_screen.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedIconButton(
          onPressed: () {},
          icon: TablerIcons.bell,
          showBadge: true,
        ),
        OutlinedIconButton(
          onPressed: () {},
          icon: TablerIcons.settings_2,
        ),
      ],
    );
  }
}
