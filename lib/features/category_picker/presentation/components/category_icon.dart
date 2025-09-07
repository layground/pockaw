import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/string_extension.dart';
import 'package:pockaw/features/category/data/model/icon_type.dart';

class CategoryIcon extends StatelessWidget {
  final IconType iconType;
  final String icon;
  final String iconBackground;

  const CategoryIcon({
    super.key,
    required this.iconType,
    required this.icon,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Container();
    Color? backgroundColor = context.purpleBackground(context.themeMode);

    if (iconBackground.isNotEmpty) {
      backgroundColor = Color(
        int.parse(iconBackground.replaceAll('#', '0xff')),
      );
    }

    // Log.d(
    //   'icon: $icon, iconType: $iconType, backgroundColor: $backgroundColor',
    //   label: 'icon',
    //   logToFile: false,
    // );

    switch (iconType) {
      case IconType.emoji:
        iconWidget = Center(child: Text(icon, style: AppTextStyles.heading4));
      case IconType.initial:
        iconWidget = Center(
          child: AutoSizeText(
            icon,
            minFontSize: 16,
            maxFontSize: 22,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading4.copyWith(
              height: 0.9,
              fontVariations: [FontVariation.weight(700)],
              color: context.primaryText(context.themeMode),
            ),
          ),
        );

        backgroundColor = null;
      case IconType.asset:
        if (icon.containsImageExtension) {
          iconWidget = Image.asset(icon);
        } else {
          iconWidget = Image.asset('assets/categories/$icon.webp');
        }

        backgroundColor = null;
    }

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: icon.isEmpty
            ? Icon(HugeIcons.strokeRoundedPizza01, size: 25)
            : iconWidget,
      ),
    );
  }
}
