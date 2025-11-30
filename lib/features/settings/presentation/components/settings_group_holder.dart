import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';

class SettingsGroupHolder extends StatelessWidget {
  final String title;
  final List<Widget> settingTiles;
  const SettingsGroupHolder({
    super.key,
    required this.title,
    required this.settingTiles,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.spacing8,
        children: [
          Text(title, style: AppTextStyles.body2.bold),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.spacing8,
            children: settingTiles,
          ),
        ],
      ),
    );
  }
}
