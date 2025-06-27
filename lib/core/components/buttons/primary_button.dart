import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/button_type.dart';
import 'package:pockaw/core/components/loading_indicators/loading_indicator.dart';
import 'package:pockaw/core/constants/app_button_styles.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_font_families.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class PrimaryButton extends FilledButton {
  PrimaryButton({
    required String label,
    bool isLoading = false,
    bool isOutlined = false,
    String loadingText = 'Please wait...',
    IconData? icon,
    EdgeInsets? padding,
    ButtonType type = ButtonType.primary,
    ButtonState state = ButtonState.active,
    ThemeMode themeMode = ThemeMode.system,
    VoidCallback? onPressed,
    super.key,
  }) : super(
         onPressed: isLoading ? null : onPressed,
         style:
             _styleFromTypeAndState(
               type: type,
               state: state,
               themeMode: themeMode,
               isLoading: isLoading,
             ).copyWith(
               textStyle: WidgetStatePropertyAll<TextStyle>(
                 AppTextStyles.body1.copyWith(
                   fontFamily: AppFontFamilies.montserrat,
                 ),
               ),
               padding: padding == null
                   ? null
                   : WidgetStatePropertyAll<EdgeInsetsGeometry>(padding),
             ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             if (isLoading)
               const SizedBox.square(
                 dimension: 16,
                 child: LoadingIndicator(color: Colors.grey),
               ),
             if (isLoading) const Gap(AppSpacing.spacing12),
             if (icon != null) Icon(icon),
             if (icon != null) const Gap(AppSpacing.spacing8),
             Text(isLoading ? loadingText : label),
           ],
         ),
       );

  static ButtonStyle _styleFromTypeAndState({
    ButtonType type = ButtonType.primary,
    ButtonState state = ButtonState.active,
    ThemeMode themeMode = ThemeMode.system,
    bool isLoading = false,
  }) {
    switch (type) {
      case ButtonType.primary:
        switch (state) {
          case ButtonState.active:
            if (isLoading) {
              return AppButtonStyles.primaryInactive(themeMode);
            }
            return AppButtonStyles.primaryActive(themeMode);
          case ButtonState.inactive:
            return AppButtonStyles.primaryInactive(themeMode);
          case ButtonState.outlinedActive:
            if (isLoading) {
              return AppButtonStyles.primaryOutlinedInactive(themeMode);
            }
            return AppButtonStyles.primaryOutlinedActive(themeMode);
          case ButtonState.outlinedInactive:
            return AppButtonStyles.primaryOutlinedInactive(themeMode);
        }
      case ButtonType.secondary:
        switch (state) {
          case ButtonState.active:
            if (isLoading) {
              return AppButtonStyles.secondaryInactive(themeMode);
            }
            return AppButtonStyles.secondaryActive(themeMode);
          case ButtonState.inactive:
            return AppButtonStyles.secondaryInactive(themeMode);
          case ButtonState.outlinedActive:
            if (isLoading) {
              return AppButtonStyles.secondaryOutlinedInactive(themeMode);
            }
            return AppButtonStyles.secondaryOutlinedActive(themeMode);
          case ButtonState.outlinedInactive:
            return AppButtonStyles.secondaryOutlinedInactive(themeMode);
        }
      case ButtonType.tertiary:
        switch (state) {
          case ButtonState.active:
            if (isLoading) {
              return AppButtonStyles.tertiaryInactive(themeMode);
            }
            return AppButtonStyles.tertiaryActive(themeMode);
          case ButtonState.inactive:
            return AppButtonStyles.tertiaryInactive(themeMode);
          case ButtonState.outlinedActive:
            if (isLoading) {
              return AppButtonStyles.tertiaryOutlinedActive(themeMode);
            }
            return AppButtonStyles.tertiaryOutlinedActive(themeMode);
          case ButtonState.outlinedInactive:
            return AppButtonStyles.tertiaryOutlinedInactive(themeMode);
        }
    }
  }
}

extension ButtonExtension on ButtonStyleButton {
  Widget get floatingBottom => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return Container(
          color: context.colors.surface,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: this,
        );
      },
    ),
  );

  Widget floatingBottomWithContent({required Widget content}) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Consumer(
        builder: (context, ref, child) {
          return Container(
            color: context.colors.surface,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(children: [content, this]),
          );
        },
      ),
    );
  }
}
