import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/resizer/fetch_pixel.dart';

class Dimens{
  static double size15Horizontal = FetchPixel.getPixelWidth(15.0,ResponsiveInfo.isTablet());

  static double size20Horizontal = FetchPixel.getPixelWidth(20.0,ResponsiveInfo.isTablet());

  static double size25Horizontal = FetchPixel.getPixelWidth(25.0,ResponsiveInfo.isTablet());

  static double size40Horizontal = FetchPixel.getPixelWidth(40.0,ResponsiveInfo.isTablet());

  static double size50Horizontal = FetchPixel.getPixelWidth(50.0,ResponsiveInfo.isTablet());

  static double size60Horizontal = FetchPixel.getPixelWidth(60.0,ResponsiveInfo.isTablet());

  static double size70Horizontal = FetchPixel.getPixelWidth(70.0,ResponsiveInfo.isTablet());

  static double size80Horizontal = FetchPixel.getPixelWidth(80.0,ResponsiveInfo.isTablet());

  static double size392Horizontal = FetchPixel.getPixelWidth(392.0,ResponsiveInfo.isTablet());

  static double size10Vertical = FetchPixel.getPixelHeight(10.0,ResponsiveInfo.isTablet());
  static double size12Vertical = FetchPixel.getPixelHeight(12.0,ResponsiveInfo.isTablet());

  static double size14Vertical = FetchPixel.getPixelHeight(14.0,ResponsiveInfo.isTablet());

  static double size15Vertical = FetchPixel.getPixelHeight(15.0,ResponsiveInfo.isTablet());

  static double size20Vertical = FetchPixel.getPixelHeight(20.0,ResponsiveInfo.isTablet());

  static double size25Vertical = FetchPixel.getPixelHeight(25.0,ResponsiveInfo.isTablet());

  static double size30Vertical = FetchPixel.getPixelHeight(30.0,ResponsiveInfo.isTablet());

  static double size40Vertical = FetchPixel.getPixelHeight(40.0,ResponsiveInfo.isTablet());

  static double size50Vertical = FetchPixel.getPixelHeight(50.0,ResponsiveInfo.isTablet());

  static double size60Vertical = FetchPixel.getPixelHeight(60.0,ResponsiveInfo.isTablet());

  static double size65Vertical = FetchPixel.getPixelHeight(65.0,ResponsiveInfo.isTablet());

  static double size70Vertical = FetchPixel.getPixelHeight(70.0,ResponsiveInfo.isTablet());

  static double size80Vertical = FetchPixel.getPixelHeight(80.0,ResponsiveInfo.isTablet());

  static double size100Vertical = FetchPixel.getPixelHeight(100.0,ResponsiveInfo.isTablet());

  static double size180Vertical(){
    return ResponsiveInfo.isTablet()? FetchPixel.getPixelHeight(200.0,true): FetchPixel.getPixelHeight(180.0,false);
  }

}