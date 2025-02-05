part of '../screens/onboarding_screen.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: AppColors.light,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: PrimaryButton(
          label: 'Get Started',
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('has_session', true);
            if (context.mounted) context.push(Routes.index); // route '/'
          },
        ),
      ),
    );
  }
}
