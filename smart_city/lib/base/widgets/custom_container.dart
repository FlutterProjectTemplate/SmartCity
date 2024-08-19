import 'dart:math';
import 'package:flutter/material.dart';

class CustomContainer extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double curve = 60.0;
    var control1 = Offset(width/2-55, 30);
    var control2 = Offset(width/2-80,5);
    var endPoint1 = Offset(width/2-25, 0);

    var control3 = Offset(width/2+80, 5);
    var control4 = Offset(width/2+55, 30);
    var endPoint2 = Offset(width/2+100, 35);
    final path = Path()
      ..moveTo(curve, 35)
      ..lineTo(width/2-100,35)
      ..cubicTo(control1.dx,control1.dy, control2.dx, control2.dy, endPoint1.dx, endPoint1.dy)
      ..lineTo(width/2+25,0)
      ..cubicTo(control3.dx,control3.dy, control4.dx, control4.dy, endPoint2.dx, endPoint2.dy)
      ..lineTo(width-curve, 35)
      ..arcTo(
          Rect.fromPoints(
              Offset(size.width - curve, 35), Offset(size.width, height)), // Rect
          1.5 * pi,   // Start angle
          pi,  // Sweep angle
          true)
      ..lineTo(curve, height)
      ..arcTo(Rect.fromLTWH(0,35, curve, height-35),  0.5* pi,  pi, false)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}