import 'dart:math';
import 'package:flutter/cupertino.dart';

enum DeviceType{
  tablet,
  mobile
}
class ResponsiveInfo {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static bool _isTablet = false;
  static bool _isPhone = false;

  static bool isTablet() {
    return _isTablet;
  }

  static bool isPhone() {
    return _isPhone;
  }
  static DeviceType getDeviceType(){
    return isTablet()?DeviceType.tablet:DeviceType.mobile;
  }

  void init(BuildContext context) async {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _isTablet = checkTabletType(context);
    _isPhone = !_isTablet;
  }

  static bool checkTabletType(BuildContext context)  {
    bool isTab = false;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double realHeightInInch = (height)/160;
    double realWidthInInch = (width)/160;
    double crossLineInInch = sqrt((realHeightInInch*realHeightInInch) + (realWidthInInch*realWidthInInch));
    if(crossLineInInch>=7) {
      ///tablet
      isTab = true;
    } else {
      isTab = false;
    }
    return isTab;
  }
}