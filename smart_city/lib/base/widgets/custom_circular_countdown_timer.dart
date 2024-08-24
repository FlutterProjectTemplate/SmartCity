import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';

class CustomCircularCountdownTimer extends StatelessWidget {
  final void Function()? onCountdownComplete;
  const CustomCircularCountdownTimer({super.key,this.onCountdownComplete});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return CircularCountDownTimer(
      isReverse: true,
      isReverseAnimation: false,
      duration: 3,
      width: width/3,
      height: width/3,
      fillColor: ConstColors.primaryColor,
      ringColor: ConstColors.tertiaryContainerColor,
      strokeWidth: 5.0,
      strokeCap: StrokeCap.round,
      autoStart: true,
      textStyle: ConstFonts().heading,
      onComplete: onCountdownComplete,
    );
  }
}
