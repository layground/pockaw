import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/router/routes.dart';

class CustomFab extends StatelessWidget {
  CustomFab({super.key});

  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    void toggleFAB() {
      final state = _key.currentState;
      if (state != null) {
        state.toggle();
      }
    }

    return Container(
      color: Colors.yellow,
      height: 80,
      child: Row(
        children: [
          ExpandableFab(
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
                  context.push(Routes.transactionForm);
                },
                onTap: toggleFAB,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedPlusSign,
                    color: AppColors.light,
                  ),
                ),
              ),
            ),
            closeButtonBuilder: DefaultFloatingActionButtonBuilder(
              shape: const CircleBorder(),
              child: const HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
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
                    heroTag: null,
                    shape: const CircleBorder(),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedMoneyReceive01,
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
                    heroTag: null,
                    shape: const CircleBorder(),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedMoneySend01,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      toggleFAB();
                      context.push(Routes.transactionForm);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
