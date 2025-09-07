import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';

class CategoryIconEmojiPicker extends StatelessWidget {
  const CategoryIconEmojiPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: 'Select Emoji',
      padding: EdgeInsets.all(AppSpacing.spacing12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            context.pop(emoji.emoji);
          },
          config: Config(
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              backgroundColor: context.floatingContainer,
              emojiSizeMax:
                  28 *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.20
                      : 1.0),
              replaceEmojiOnLimitExceed: true,
              buttonMode: ButtonMode.CUPERTINO,
            ),
            categoryViewConfig: CategoryViewConfig(
              iconColorSelected: context.purpleBackgroundActive,
              indicatorColor: context.purpleBackgroundActive,
              categoryIcons: CategoryIcons(
                recentIcon: HugeIcons.strokeRoundedTimeQuarter02,
                smileyIcon: HugeIcons.strokeRoundedSmile,
                animalIcon: HugeIcons.strokeRoundedHorse,
                foodIcon: HugeIcons.strokeRoundedTaco01,
                objectIcon: HugeIcons.strokeRoundedTools,
                activityIcon: HugeIcons.strokeRoundedWorkoutRun,
                travelIcon: HugeIcons.strokeRoundedLake,
                symbolIcon: HugeIcons.strokeRoundedCharacterPhonetic,
                flagIcon: HugeIcons.strokeRoundedFlag02,
              ),
            ),
            searchViewConfig: SearchViewConfig(
              backgroundColor: context.purpleBackground,
            ),
            bottomActionBarConfig: BottomActionBarConfig(
              backgroundColor: context.purpleBackground,
              buttonColor: Colors.transparent,
              buttonIconColor: context.isDarkMode
                  ? Colors.white
                  : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
