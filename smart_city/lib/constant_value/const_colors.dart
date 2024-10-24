import 'package:flutter/material.dart';
import 'package:smart_city/base/app_settings/app_setting.dart';

class ConstColors {
  static bool _darkMode = AppSetting.getDarkMode();

  static void updateDarkMode(bool isDark) {
    _darkMode = isDark;
  }

  static Color get primaryColor => Color(0xff66bb66);

  static Color get primaryContainerColor => Color(0xff76FF76);

  static Color get onPrimaryColor => _darkMode ? const Color(0xff121212) : const Color(0xffffffff);

  static Color get secondaryColor => _darkMode ? const Color(0xff484848) : const Color(0xffffffff);

  static Color get controlBtn => _darkMode ? const Color(0xff818181) : const Color(0xffffffff);

  static Color get secondaryContainerColor => _darkMode ? const Color(0xff3C3C3C) : const Color(0xffD9D9D9);

  static Color get onSecondaryContainerColor => _darkMode ? Colors.white70 : Colors.black54;

  static Color get textFormFieldColor => _darkMode ? Colors.white70 : Colors.black87;

  static Color get tertiaryColor => _darkMode ? const Color(0xffECECEC) : const Color(0xff8C8C8E);

  static Color get tertiaryContainerColor => const Color(0xff3C4C4D);

  static Color get surfaceColor => _darkMode ? const Color(0xffEDEDED) : const Color(0xff24242B);

  static Color get errorColor => Color(0xffFF0000);

  static Color get errorContainerColor => Color(0xffFF6262);
}
