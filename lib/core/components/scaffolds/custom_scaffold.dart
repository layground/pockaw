import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';

part 'balance_status_bar.dart';

class CustomScaffold extends Scaffold {
  CustomScaffold({
    Key? key,
    required BuildContext context,
    required Widget body,
    String title = '',
    bool showBackButton = true,
    bool showBalance = true,
    List<Widget>? actions,
  }) : super(
          key: key,
          body: body,
          appBar: AppBar(
            leadingWidth: 80,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            leading: !showBackButton
                ? null
                : CustomIconButton(
                    onPressed: () => context.pop(),
                    icon: TablerIcons.arrow_narrow_left,
                  ),
            title: title.isEmpty
                ? null
                : Text(
                    title,
                    style: AppTextStyles.heading6,
                  ),
            actions: actions,
            bottom: !showBalance ? null : BalanceStatusBar(),
          ),
        );
}
