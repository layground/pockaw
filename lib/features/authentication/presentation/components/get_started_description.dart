part of '../screens/login_screen.dart';

class GetStartedDescription extends StatelessWidget {
  const GetStartedDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      style: AppTextStyles.body3,
      TextSpan(
        text: 'Please enter your ',
        children: [
          TextSpan(
            text: 'name or brand name',
            style: TextStyle(fontVariations: [FontVariation.weight(700)]),
          ),
          TextSpan(
            text: ', pick your best ',
          ),
          TextSpan(
            text: 'picture',
            style: TextStyle(fontVariations: [FontVariation.weight(700)]),
          ),
          TextSpan(
            text: ' and choose your ',
          ),
          TextSpan(
            text: 'currency',
            style: TextStyle(fontVariations: [FontVariation.weight(700)]),
          ),
          TextSpan(
            text: ' to personalize your account.',
          ),
        ],
      ),
    );
  }
}
