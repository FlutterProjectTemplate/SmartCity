import 'package:smart_city/base/store/cached_storage.dart';

class AppSetting {
  static bool getDarkMode() {
    return SharedPreferencesStorage().getBoolean('darkmode') ?? false;
  }
}
