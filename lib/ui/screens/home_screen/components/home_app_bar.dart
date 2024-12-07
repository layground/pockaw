import 'package:flutter/material.dart';
import 'package:pockaw/ui/screens/home_screen/components/greeting_card.dart';
import 'package:pockaw/ui/screens/home_screen/components/home_action_button.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: GreetingCard()),
          HomeActionButton(),
        ],
      ),
    );
  }
}
