import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_notifier.dart';

class TransactionImagePicker extends ConsumerWidget {
  const TransactionImagePicker({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final imageNotifier = ref.read(imageProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            onPressed: () async {
              imageNotifier.takePhoto().then((value) {
                imageNotifier.saveImage();
              });
            },
            label: 'Camera',
            icon: TablerIcons.focus_centered,
          ),
        ),
        const Gap(AppSpacing.spacing8),
        Expanded(
          child: SecondaryButton(
            onPressed: () {
              imageNotifier.pickImage().then((value) {
                imageNotifier.saveImage();
              });
            },
            label: 'Gallery',
            icon: TablerIcons.photo,
          ),
        ),
      ],
    );
  }
}
