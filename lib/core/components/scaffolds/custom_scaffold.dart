import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

part 'balance_status_bar.dart';
part 'balance_status_bar_content.dart';

class CustomScaffold extends Scaffold {
  CustomScaffold({
    super.key,
    required BuildContext context,
    required Widget super.body,
    String title = '',
    bool showBackButton = true,
    bool showBalance = true,
    List<Widget>? actions,
    super.floatingActionButton,
    super.backgroundColor,
  }) : super(
         resizeToAvoidBottomInset: true,
         appBar: AppBar(
           leadingWidth: 80,
           titleSpacing: showBackButton ? 0 : AppSpacing.spacing20,
           toolbarHeight: 60,
           automaticallyImplyLeading: false,
           leading: !showBackButton
               ? null
               : CustomIconButton(
                   onPressed: () => context.pop(),
                   icon: HugeIcons.strokeRoundedArrowLeft01,
                 ),
           title: title.isEmpty
               ? null
               : Text(title, style: AppTextStyles.heading6),
           actions: [...?actions, const Gap(AppSpacing.spacing20)],
           bottom: !showBalance ? null : BalanceStatusBar(),
         ),
       );
}
