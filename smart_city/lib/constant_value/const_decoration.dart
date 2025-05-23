import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'const_colors.dart';
import 'const_fonts.dart';

class ConstDecoration{
  static InputDecoration inputDecoration(
      {required String hintText,double? borderRadius,
        Widget? suffixIcon,
        Widget? prefixIcon,
        double? hintTextFontSize
      }){
    return InputDecoration(
      counterText: '',
      filled: true,
      fillColor: ConstColors.secondaryContainerColor,
      hintText: hintText,
      hintStyle: ConstFonts().copyWithTitle(
          color: ConstColors.onSecondaryContainerColor,
          fontSize: hintTextFontSize??14),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: ConstColors.surfaceColor),
      ),
      enabledBorder:  OutlineInputBorder(
        borderSide: BorderSide(color: ConstColors.onPrimaryColor),
        borderRadius: BorderRadius.circular(borderRadius??20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ConstColors.primaryColor),
        borderRadius: BorderRadius.circular(borderRadius??20),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      suffixIconConstraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
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