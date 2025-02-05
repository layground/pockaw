part of '../screens/login_screen.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon/icon-transparent-full.png',
            width: 150,
          ),
          const Gap(AppSpacing.spacing12),
          const Text(
            AppConstants.appName,
            style: AppTextStyles.heading2,
          ),
        ],
      ),
    );
  }
}
