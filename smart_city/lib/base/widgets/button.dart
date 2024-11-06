import 'package:flutter/material.dart';

class Button {
  final double width;
  final double height;
  final Color? color;
  final Gradient? gradient;
  final Widget child;
  final bool isCircle;

  Button({
    required this.width,
    required this.height,
    this.color,
    this.gradient,
    this.isCircle = false,
    required this.child,
  });

  Widget getButton() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: gradient == null ? color : null, // Only apply color if gradient is null
        gradient: gradient,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(12),
      ),
      child: Center(child: child),
    );
  }
}
