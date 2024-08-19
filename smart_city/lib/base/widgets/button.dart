import 'package:flutter/material.dart';

class Button{
  double width;
  double height;
  Color color;
  Widget child;
  bool isCircle=false;
  Button({required this.width,required this.height,required this.color,required this.isCircle,required  this.child});

  Widget getButton(){
    return isCircle?Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: child,
      ),
    ):Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: child,
      ),
    );
  }
}