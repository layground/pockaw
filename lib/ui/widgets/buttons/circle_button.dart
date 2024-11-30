import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final double? radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData icon;
  final GestureTapCallback? onTap;

  const CircleIconButton({
    super.key,
    required this.icon,
    this.radius,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: Center(
          child: Icon(
            icon,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}
