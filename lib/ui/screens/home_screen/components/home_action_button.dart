import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pockaw/ui/widgets/buttons/outlined_icon_button.dart';

class HomeActionButton extends StatelessWidget {
  const HomeActionButton({super.key});

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
