import 'dart:math';
import 'package:flutter/material.dart';

class CustomContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double curve = 30;

    final path = Path()
      ..moveTo(0, height)
      ..lineTo(0, curve)
      ..quadraticBezierTo(width / 2, -curve, width, curve)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomContainerIntro1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double curve = 30;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, height - curve)
      ..quadraticBezierTo(width / 2, height + curve, 0, height - curve)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomContainerIntro2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double curve = 30;

    final path = Path()
      ..moveTo(0, height)
      ..lineTo(0, curve)
      ..quadraticBezierTo(width / 2, -curve, width, curve)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomContainerMobile extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double curve = 60;
    double radious = height / 1.7;

    final path = Path()
      ..moveTo(curve, 0)
      ..lineTo(width / 2 - radious, 0)
      ..arcToPoint(
        Offset(width / 2 + radious, 0),
        radius: Radius.circular(radious / 2),
        clockwise: false,
      )
      ..lineTo(width - curve, 0)
      ..arcTo(
          Rect.fromPoints(
              Offset(size.width - curve, 0), Offset(size.width, height)),
          // Rect
          1.5 * pi, // Start angle
          pi, // Sweep angle
          true)
      ..lineTo(curve, height)
      ..arcTo(Rect.fromLTWH(0, 0, curve, height), 0.5 * pi, pi, false)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomContainerTablet extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double curve = 120;
    double radious = height / 1.7;

    final path = Path()
      ..moveTo(curve, 0)
      ..lineTo(width / 2 - radious, 0)
      ..arcToPoint(
        Offset(width / 2 + radious, 0),
        radius: Radius.circular(radious / 2),
        clockwise: false,
      )
      ..lineTo(width - curve, 0)
      ..arcTo(
          Rect.fromPoints(
              Offset(size.width - curve, 0), Offset(size.width, height)),
          // Rect
          1.5 * pi, // Start angle
          pi, // Sweep angle
          true)
      ..lineTo(curve, height)
      ..arcTo(Rect.fromLTWH(0, 0, curve, height), 0.5 * pi, pi, false)
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
    Rect rect = const Offset(0, 0) & Size(size.width, size.height);

    var paint = Paint()
      ..color = const Color(0xffCC0000)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startAngle = pi / 2;
    double sweepAmount = 2 * currentState * pi;

    canvas.drawArc(rect, startAngle, sweepAmount, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CurvedRectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint1 = Offset(size.width / 4, size.height - 60);
    var endPoint1 = Offset(size.width / 2, size.height - 30);
    var controlPoint2 = Offset(size.width / 4 * 3, size.height);
    var endPoint2 = Offset(size.width, size.height - 30);

    var controlPoint3 = Offset(size.width * 5 / 6, size.height);
    var endPoint3 = Offset(size.width, size.height - 30);

    Path path = Path()
    ..lineTo(0, size.height - 30) // Start from the bottom left
    ..quadraticBezierTo(controlPoint1.dx,controlPoint1.dy, endPoint1.dx,endPoint1.dy,)
      ..quadraticBezierTo(controlPoint2.dx, controlPoint2.dy, endPoint2.dx,endPoint2.dy,)
      // ..quadraticBezierTo(controlPoint3.dx, controlPoint3.dy, endPoint3.dx,endPoint3.dy,)
    ..lineTo(size.width, 0)
    ..lineTo(0, 0)
    ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // Return true if you want to reclip when the widget rebuilds
  }
}
