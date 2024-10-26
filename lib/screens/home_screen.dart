import 'package:buddyjet/utils/extensions/text_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    void openFAB() {
      final state = _key.currentState;
      if (state != null) {
        state.toggle();
      }
    }

    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        type: ExpandableFabType.fan,
        pos: ExpandableFabPos.center,
        fanAngle: 180,
        duration: const Duration(milliseconds: 100),
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onLongPress: () {
              debugPrint('quick action');
            },
            onTap: openFAB,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(TablerIcons.plus),
            ),
          ),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
          shape: const CircleBorder(),
          child: const Icon(TablerIcons.x),
        ),
        onOpen: () {},
        onClose: () {},
        overlayStyle: const ExpandableFabOverlayStyle(
          color: Colors.black38,
          blur: 1.2,
        ),
        children: [
          Column(
            children: [
              const Text('Income'),
              const Gap(10),
              FloatingActionButton(
                shape: const CircleBorder(),
                child: const Icon(
                  TablerIcons.arrow_bar_to_down,
                  color: Colors.green,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Column(
            children: [
              const Text('Expense'),
              const Gap(10),
              FloatingActionButton(
                shape: const CircleBorder(),
                child: const Icon(
                  TablerIcons.arrow_bar_up,
                  color: Colors.red,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Hello!',
          style: context.textHeadlineLarge,
        ),
      ),
    );
  }
}
