part of '../screens/login_screen.dart';

class LoginInfo extends StatelessWidget {
  const LoginInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text:
            'You can add more wallets later.\nWe only store your data into local database '
            'on this device.\nSo you are in charge! ',
        style: AppTextStyles.body4,
        children: [
          TextSpan(
            text: 'Read more',
            style: AppTextStyles.body4.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: context.secondaryText,
              color: context.secondaryText,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                LinkLauncher.launch(AppConstants.privacyPolicyUrl);
              },
          ),
          TextSpan(text: ' to find out.'),
        ],
      ),
    );
  }
}
