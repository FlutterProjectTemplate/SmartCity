import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_city/constant_value/const_size.dart';

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

class CustomContainerTablet extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double curve = 100;
    var controlPoint = Offset(width/2,height);
    var endPoint = Offset(width/2+80,0);

    final path = Path()
      ..moveTo(curve, 0)
      ..lineTo(width/2-80,0)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(width-curve, 0)
      ..arcTo(
          Rect.fromPoints(
              Offset(size.width - curve, 0), Offset(size.width, height)), // Rect
          1.5 * pi,   // Start angle
          pi,  // Sweep angle
          true)
      ..lineTo(curve, height)
      ..arcTo(Rect.fromLTWH(0,0, curve, height),  0.5* pi,  pi, false)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class BorderPainter extends CustomPainter {

  final double currentState;

  BorderPainter({required this.currentState});

  @override
  void paint(Canvas canvas, Size size) {

    double strokeWidth = 15;
    Rect rect = const Offset(0,0) & Size(size.width, size.height);

    var paint = Paint()
      ..color = const Color(0xffCC0000)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startAngle = pi / 2;
    double sweepAmount = 2*currentState * pi;

    canvas.drawArc(rect, startAngle, sweepAmount, false, paint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
