import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base/store/cached_storage.dart';
import '../../base/utlis/key_manager.dart';
import '../services/navigation_service.dart';
import 'app_notifier.dart';
import 'bloc/main_bloc.dart';

class LanguageHelper {
  static final LanguageHelper _singletonLanguageHelper =
  LanguageHelper._internal();

  static LanguageHelper get getInstance => _singletonLanguageHelper;

  factory LanguageHelper() {
    return _singletonLanguageHelper;
  }

  LanguageHelper._internal();

  final List<LanguageInfo> supportedLanguages = [
    LanguageInfo(
      languageCode: 'en',
      country: 'US',
      language: 'English',
      languageIndex: LANGUAGE_INDEX.ENGLISH,
    ),
    LanguageInfo(
        languageCode: 'vi',
        country: 'VN',
        language: 'VietNam',
        languageIndex: LANGUAGE_INDEX.VIETNAMESE),
  ];
  Locale? _locale;

  void setLocale(Locale inputLocale) {
    _locale = inputLocale;
    SharedPreferencesStorage().saveString(
        KeyManager
            .getInstance()
            .COUNTRY_CODE_KEY, inputLocale.countryCode!);
    SharedPreferencesStorage().saveString(
        KeyManager
            .getInstance()
            .LANGUAGE_CODE_KEY, inputLocale.languageCode);
  }

  Locale getCurrentLocale() {
    if (_locale != null) {
      return _locale!;
    } else {
      String languageCode = SharedPreferencesStorage()
          .getString(KeyManager
          .getInstance()
          .LANGUAGE_CODE_KEY)
          .isNotEmpty
          ? SharedPreferencesStorage()
          .getString(KeyManager
          .getInstance()
          .LANGUAGE_CODE_KEY)
          : "en";
      String countryCode = SharedPreferencesStorage()
          .getString(KeyManager
          .getInstance()
          .COUNTRY_CODE_KEY)
          .isNotEmpty
          ? SharedPreferencesStorage()
          .getString(KeyManager
          .getInstance()
          .COUNTRY_CODE_KEY)
          : "US";
      _locale = Locale(languageCode, countryCode);
      return _locale!;
    }
  }

  void changeLanguage(LanguageInfo language, BuildContext context) {
    Locale locale = LANGUAGE_MAPS[language.languageIndex]!;
    AppNotifier().changeLanguage(language, notify: false);
    BlocProvider.of<MainBloc>(NavigationService.globalContext!)
        .add(MainChangeLanguageEvent(locale: locale));
  }
}

enum LANGUAGE_INDEX {
  ENGLISH,
  SPANISH,
  CHINESE,
  GERMAN,
  VIETNAMESE,
}

const Map<LANGUAGE_INDEX, String> LANGUAGE_VIEW = {
  LANGUAGE_INDEX.ENGLISH: "English",
  LANGUAGE_INDEX.SPANISH: "Spanish",
  LANGUAGE_INDEX.CHINESE: "Chinese",
  LANGUAGE_INDEX.GERMAN: "German",
  LANGUAGE_INDEX.VIETNAMESE: "Tiếng Việt",
};
const Map<LANGUAGE_INDEX, Locale> LANGUAGE_MAPS = {
  LANGUAGE_INDEX.ENGLISH: Locale('en', 'US'),
  LANGUAGE_INDEX.SPANISH: Locale('es', 'US'),
  LANGUAGE_INDEX.CHINESE: Locale('zh', 'CN'),
  LANGUAGE_INDEX.GERMAN: Locale('de', 'US'),
  LANGUAGE_INDEX.VIETNAMESE: Locale('vi', 'VN'),
};
const Map<String, LANGUAGE_INDEX> LANGUAGE_INDEX_MAPS = {
  'en': LANGUAGE_INDEX.ENGLISH,
  'es': LANGUAGE_INDEX.SPANISH,
  'zh': LANGUAGE_INDEX.CHINESE,
  'de': LANGUAGE_INDEX.GERMAN,
  'vi': LANGUAGE_INDEX.VIETNAMESE,
};

class LanguageInfo {
  /// the country code (IT,AF..)
  String? languageCode;
  String? countryCode;
  LANGUAGE_INDEX languageIndex;

  /// the locale (en, es, da)
  String? country;

  /// the full name of language (English, Danish..)
  String? language;

  /// the full name of language (English, Danish..)
  String? scripCode;

  /// map of keys used based on industry type (service worker, route etc)
  Map<String, String>? dictionary;
  bool supportRTL;

  LanguageInfo({this.countryCode,
    this.languageCode,
    this.country,
    this.language,
    this.dictionary,
    this.scripCode,
    required this.languageIndex,
    this.supportRTL = false});
}
