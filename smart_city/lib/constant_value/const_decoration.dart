import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'const_colors.dart';
import 'const_fonts.dart';

class ConstDecoration{
  static InputDecoration inputDecoration({required String hintText,double? borderRadius,bool? isFilled}){
    return InputDecoration(
      counterText: '',
      filled: isFilled??true,
      fillColor: ConstColors.secondaryContainerColor,
      hintText: hintText,
      hintStyle: ConstFonts().copyWithTitle(color: ConstColors.onSecondaryContainerColor,fontSize: 16),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder:  OutlineInputBorder(
        borderSide: const BorderSide(color: ConstColors.onPrimaryColor),
        borderRadius: BorderRadius.circular(borderRadius??12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ConstColors.primaryColor),
        borderRadius: BorderRadius.circular(borderRadius??12),
      ),
    );
  }

  static PinTheme defaultPinTheme(double height,double width){
    return PinTheme(
      width: width,
      height: height,
      textStyle: ConstFonts().copyWithTitle(fontSize: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ConstColors.secondaryColor),
      )
    );
  }
  static PinTheme focusedPinTheme(double height,double width){
    return defaultPinTheme(height, width).copyBorderWith(
      border: Border.all(color: ConstColors.primaryColor),
    );
  }

  static PinTheme errorPinTheme(double height,double width){
    return defaultPinTheme(height, width).copyBorderWith(
      border: Border.all(color: ConstColors.errorColor),
    );
  }

  static PinTheme summitedPinTheme(double height,double width){
    return defaultPinTheme(height, width).copyDecorationWith(
      color: ConstColors.primaryContainerColor,
    );
  }
}