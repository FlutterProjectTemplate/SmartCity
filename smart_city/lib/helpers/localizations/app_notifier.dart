/*
* File : App Theme Notifier (Listener)
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_helper.dart';

class AppNotifier extends ChangeNotifier {
  AppNotifier();

  Future<void> init() async {
    notifyListeners();
  }

  Future<void> changeLanguage(LanguageInfo language,
      {
        bool notify = true,
        bool changeDirection = true,
        
      }) async {
    Locale locale = LANGUAGE_MAPS[language.languageIndex]!;
    LanguageHelper().setLocale(locale);
    if (notify) notifyListeners();
  }

}
