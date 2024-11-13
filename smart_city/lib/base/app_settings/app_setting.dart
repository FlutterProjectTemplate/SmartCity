import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_city/base/store/cached_storage.dart';

class AppSetting {
  static PackageInfo? _packageInfo;

  static Future<void> initialize() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  static bool get enableDarkMode {
    return SharedPreferencesStorage().getBoolean('darkmode') ?? false;
  }

  static String get getSpeedUnit {
    return SharedPreferencesStorage().getString('speedUnit').isEmpty ?? true ? 'mph' : SharedPreferencesStorage().getString('speedUnit');
  }

  static String get appName => _packageInfo?.appName ?? 'Unknown';
  static String get packageName => _packageInfo?.packageName ?? 'Unknown';
  static String get version => _packageInfo?.version ?? 'Unknown';
  static String get buildNumber => _packageInfo?.buildNumber ?? 'Unknown';
}
