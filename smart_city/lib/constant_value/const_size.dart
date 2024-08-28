import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/resizer/fetch_pixel.dart';

class Dimens{
  static double size15Horizontal = FetchPixel.getPixelWidth(15.0);

  static double size20Horizontal = FetchPixel.getPixelWidth(20.0);

  static double size10Vertical = FetchPixel.getPixelHeight(10.0);

  static double size15Vertical = FetchPixel.getPixelHeight(15.0);

  static double get size20Vertical {return FetchPixel.getPixelHeight(!ResponsiveInfo.isTablet()?20.0:22.0);}

  static double get size50Vertical {return FetchPixel.getPixelHeight(!ResponsiveInfo.isTablet()?50.0:55.0);}
}