// part of '../../components/dashboard_screen.dart';
//
// class GoalsCarousel extends StatelessWidget {
//   const GoalsCarousel({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 145,
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         itemBuilder: (context, index) => const AspectRatio(
//           aspectRatio: 6 / 3,
//           child: GoalCard(),
//         ),
//         separatorBuilder: (context, index) => const Gap(AppSpacing.spacing20),
//         itemCount: 3,
//       ),
//     );
//   }
// }
