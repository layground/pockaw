import 'package:flutter/material.dart';
import 'package:pockaw/ui/screens/components/custom_bottom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(),
          const Positioned(
            bottom: 20,
            left: 94,
            right: 94,
            child: CustomBottomAppBar(),
          ),
        ],
      ),
    );
  }
}
