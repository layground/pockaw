import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/loading_indicators/loading_indicator.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';

enum IconSize { large, medium, small, tiny }

class CustomIconButton extends IconButton {
  CustomIconButton(
    BuildContext context, {
    super.key,
    required GestureTapCallback super.onPressed,
    required List<List<dynamic>> icon,
    ThemeMode themeMode = ThemeMode.system,
    Color? backgroundColor,
    Color? borderColor,
    Color? color,
    bool active = false,
    bool showBadge = false,
    bool isLoading = false,
    double padding = 6,
    IconSize iconSize = IconSize.small,
    VisualDensity visualDensity = VisualDensity.compact,
  }) : super(
         visualDensity: visualDensity,
         constraints: const BoxConstraints(),
         padding: EdgeInsets.zero,
         style: IconButton.styleFrom(
           minimumSize: Size.zero,
           padding: EdgeInsets.zero,
           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
           visualDensity: VisualDensity.compact,
         ),
         icon: Container(
           padding: EdgeInsets.all(padding),
           decoration: BoxDecoration(
             color:
                 backgroundColor ??
                 (active
                     ? context.purpleBackgroundActive
                     : context.purpleBackground),
             borderRadius: BorderRadius.circular(AppRadius.radius8),
             border: Border.all(
               color: borderColor ?? context.purpleBorderLighter,
             ),
           ),
           child: isLoading
               ? SizedBox.square(dimension: 18, child: LoadingIndicator())
               : Stack(
                   children: [
                     HugeIcon(
                       icon: icon,
                       color:
                           color ??
                           (active
                               ? context.purpleIconActive
                               : context.purpleIcon),
                       size: _getIconSize(iconSize),
                     ),
                     !showBadge
                         ? const SizedBox()
                         : Positioned(top: 2, right: 2, child: _badge()),
                   ],
                 ),
         ),
       );

  static double _getIconSize(IconSize size) => switch (size) {
    IconSize.large => 26,
    IconSize.medium => 22,
    IconSize.small => 18,
    IconSize.tiny => 12,
  };

  static Widget _badge() => Container(
    width: 6,
    height: 6,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.red,
    ),
  );
}
