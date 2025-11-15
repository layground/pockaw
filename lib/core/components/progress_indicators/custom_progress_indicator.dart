import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  /// Between 0.0 - 1.0
  final double value;
  final Color color;
  final double height;
  final BorderRadiusGeometry? radius;
  const CustomProgressIndicator({
    super.key,
    required this.value,
    required this.color,
    this.height = 8,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: (value * 100).toInt(),
      child: Container(
        height: height,
        decoration: BoxDecoration(color: color, borderRadius: radius),
        /*child: const Center(
          child: Text(
            'Groceries',
            style: TextStyle(color: Colors.white),
          ),
        ),*/
      ),
    );
  }
}
