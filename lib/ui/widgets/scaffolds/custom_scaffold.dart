import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';

class CustomScaffold extends Scaffold {
  CustomScaffold({
    Key? key,
    required BuildContext context,
    required Widget body,
    String title = '',
    bool showBackButton = true,
  }) : super(
          key: key,
          body: body,
          appBar: AppBar(
            leadingWidth: 80,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            leading: !showBackButton
                ? null
                : IconButton(
                    onPressed: () => context.pop(),
                    padding: const EdgeInsets.all(AppSpacing.spacing8),
                    icon: const Icon(TablerIcons.arrow_narrow_left),
                  ),
            title: title.isEmpty
                ? null
                : Text(
                    title,
                    style: AppTextStyles.heading6,
                  ),
          ),
        );
}
