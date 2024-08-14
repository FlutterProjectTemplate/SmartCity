import 'package:flutter/material.dart';

class Button{
  double width;
  double height;
  Color color;
  TextButton? text;
  IconButton? icon;
  Button({required this.width,required this.height,required this.color,this.text,this.icon});

  Widget getButton(){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: text??icon,
      ),
    );
  }
}