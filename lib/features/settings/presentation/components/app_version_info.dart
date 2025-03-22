part of '../screens/settings_screen.dart';

class AppVersionInfo extends StatelessWidget {
  const AppVersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'App Version',
            style: AppTextStyles.body3,
          ),
          Text(
            '1.0.12 (32930) • Release: 12 January 2025',
            style: AppTextStyles.body4,
          ),
        ],
      ),
    );
  }
}
