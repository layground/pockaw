part of '../screens/login_screen.dart';

class LoginInfo extends StatelessWidget {
  const LoginInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text:
            'Use your name to login into different account.\nWe only store your data into local database '
            'on this device. So you are in charge! ',
        style: AppTextStyles.body4,
        children: [
          TextSpan(
            text: 'Read more.',
            style: AppTextStyles.body4.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: context.secondaryText(context.themeMode),
              color: context.secondaryText(context.themeMode),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                LinkLauncher.launch(AppConstants.privacyPolicyUrl);
              },
          ),
        ],
      ),
    );
  }
}
