class KeyManager {
  static KeyManager ?_instance;
  KeyManager._internal();

  static KeyManager getInstance() {
    _instance ??= KeyManager._internal();
    return _instance!;
  }
  final String COUNTRY_CODE_KEY ="local";
  final String LANGUAGE_CODE_KEY = "language";
  String saveFileFolder = "smart_city";

  /// share preference keys
  String categoryItemKey = "categoryItemKey";
}

