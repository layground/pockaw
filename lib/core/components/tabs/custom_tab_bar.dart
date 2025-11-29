import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';

class CustomTabBar extends StatelessWidget {
  final TabController? tabController;
  final List<Tab> tabs;
  const CustomTabBar({super.key, this.tabController, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.spacing12),
        border: Border.all(color: context.secondaryBorderLighter),
      ),
      child: SizedBox(
        height: 30,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.spacing8),
          child: TabBar(
            controller: tabController,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing8,
            ),
            isScrollable: true,
            dividerHeight: 0,
            splashBorderRadius: BorderRadius.circular(AppSpacing.spacing8),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(AppSpacing.spacing8),
            ),
            unselectedLabelStyle: AppTextStyles.body4,
            labelStyle: AppTextStyles.body4.extraBold,
            labelColor: AppColors.secondary50,
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}
