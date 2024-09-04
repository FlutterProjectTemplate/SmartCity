import 'package:flutter/material.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/constant_value/const_size.dart';

class FetchPixel{
  static double mockupWidth = 392;
  static double mockupHeight = 872;
  static double mockupHeightTablet = 768;
  static double mockupWidthTablet = 1280;
  static double width = 0;
  static double height = 0;

  FetchPixel(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  static double getHeightPercentSize(double percent) {
    return (percent * height) / 100;
  }

  static double getWidthPercentSize(double percent) {
    return (percent * width) / 100;
  }

  static double getPixelWidth(double val,bool isTablet) {
    return isTablet?(val / mockupWidthTablet*width):(val / mockupWidth * width);
  }

  static double getPixelHeight(double val,bool isTablet) {
    return isTablet?(val / mockupHeightTablet*height):(val / mockupHeight * height);
  }

  static double getDefaultHorSpace(BuildContext context) {
    return (Dimens.size20Vertical);
  }

  static double getTextScale() {
    double textScaleFactor =
    (width > height) ? width / mockupWidth : height / mockupHeight;
    if (ResponsiveInfo.isTablet()) {
      textScaleFactor = height / mockupHeight;
    }

    return textScaleFactor;
  }

  static double getScale() {
    double scale =
    (width > height) ? mockupWidth / width : mockupHeight / height;

    if (ResponsiveInfo.isTablet()) {
      scale = height / mockupHeight;
    }

    return scale;
  }
}