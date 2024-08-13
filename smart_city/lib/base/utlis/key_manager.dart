class KeyManager {
  static KeyManager ?_instance;
  KeyManager._internal();

  static KeyManager getInstance() {
    _instance ??= KeyManager._internal();
    return _instance!;
  }
  static const String countryCodeKey ="local";
  static const String languageCodeKey = "language";
  String saveFileFolder = "smart_city";

  /// share preference keys
  String categoryItemKey = "categoryItemKey";
}