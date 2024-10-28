import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart'if (kIsWeb) "dart:html" as html_cache;
import 'package:smart_city/base/utlis/file_utlis.dart';

class Storage {
  ///constant name key
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';
  static const logoutStateKey = 'logoutStateKey';
  static const recentUserInfoKey = 'recentUserInfoKey';
  static const currentUserInfoKey = 'currentUserInfoKey';
  static const currentUserProfileInfoKey = 'currentUserProfileInfoKey';
  static const darkModeKey = 'darkModeKey';

  // key encrypt
  static const languageCodeKey = "language_code";
  static const domainTypeIndexKey = "domainTypeIndexKey";
  static const mapSettingInfoKey = "mapSettingInfoKey";
  static const rootUserInfoKey = "rootUserInfoKey";
  static const rootUserDetailKey = "rootUserDetailKey";
  static const rootCustomerDetailKey = "rootCustomerDetailKey";
  static const vehicleTypeKey = "vehicleTypeKey";

  static const mapTypeKey = "mapTypeKey";

  static const notificationKey = "notificationKey";

  static List<String> hardKeys = <String>[
    accessToken,
    refreshToken,
    rootUserInfoKey,
    currentUserInfoKey,
    mapSettingInfoKey
  ];
  // quan ly cac key tuong minh
  static List<String> needSaveKeysLogoutSession = <String>[
    recentUserInfoKey,
    languageCodeKey,
    domainTypeIndexKey
  ]; // quan ly cac key can giu lai sau khi logout
  static List<String> dynamicKeys =
  <String>[]; // quan ly cac key khong tuong minh

  /// Lưu dữ liệu vào local storage của trình duyệt
  static final LocalStorage localStorage = LocalStorage();
  static final SharedPreferencesStorage sharedPreferencesStorage = SharedPreferencesStorage();

  /// Lưu dữ liệu vào session storage của trình duyệt
  static final SessionStorage sessionStorage = SessionStorage();

  /// Lưu dữ liệu vào cookie storage của trình duyệt
  static final CookieStorage cookieStorage = CookieStorage();
}

class SharedPreferencesStorage {
  static final SharedPreferencesStorage _singletonSharedPreferencesStorage = SharedPreferencesStorage._internal();
  static SharedPreferencesStorage get getInstance => _singletonSharedPreferencesStorage;
  factory SharedPreferencesStorage() {
    return _singletonSharedPreferencesStorage;
  }
  SharedPreferencesStorage._internal();
  late final SharedPreferences prefs;
  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<Map<String, String>> getKeyLogoutSessionByString() async {
    Map<String, String> keyLogoutSessions = await getStringByKeys(Storage.needSaveKeysLogoutSession);
    return keyLogoutSessions;
  }

  Future<void> saveKeyLogoutSession(Map<String, String> keyLogoutSessions) async{
    saveListValueString(keyLogoutSessions);
  }

  Future<Map<String, String>> getStringByKeys(List<String> keys) async {
    Map<String, String> keyLogoutSessions = {};
    for (String key in keys) {
      keyLogoutSessions[key] = getString(key);
    }
    return keyLogoutSessions;
  }

  Future<void> saveListValueString(Map<String, String> listStringValues) async{
    for (var key in listStringValues.keys) {
      await prefs.setString(key, listStringValues[key]!);
    }
  }

  Future<void> saveFileDataByKey(String key, Uint8List dataFile) async {
    String dataStr = String.fromCharCodes(dataFile);
    await saveDynamicString(key, dataStr);
  }

  Future<Uint8List> getFileDataByKey(String key) async {
    String dataStr = await getDynamicString(key);
    List<int> dataList = dataStr.codeUnits;
    Uint8List uint8ListData = Uint8List.fromList(dataList);
    return uint8ListData;
  }
  Future<void> removeFileDataByKey(String key) async {
    await removeDynamicByKey(key);
  }
  Future<void> removeFileDataByKeys(List<String> keys) async {
    await removeDynamicByKeys(keys);
  }
  Future<bool> isExitFileDataByKey(String key) async {
    bool isExits = await isExitDynamicStringKey(key);
    return isExits;
  }

  Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);

  }
  Future<void> saveDouble(String key, double value) async {
    await prefs.setDouble(key, value);

  }
  Future<void> saveInteger(String key, int value) async {
    await prefs.setInt(key,  value);
  }

  Future<void> saveBoolean(String key, bool value) async {
    await prefs.setBool(key,  value);
  }

  String getString(String key)  {
    return prefs.getString(key)??"";
  }

  int getInt(String key)  {
    return prefs.getInt(key)??0;
  }

  double getDouble(String key)  {
    return prefs.getDouble(key)??0.0;
  }
  bool getBoolean(String key) {
    return prefs.getBool(key)??false;
  }

  bool keyIsExit(String key) {
    if (prefs.containsKey(key)) {
      return true;
    }
    return false;
  }

  Future<void> removeByKey(String key) async {
    await prefs.remove(key);
    if (Storage.dynamicKeys.contains(key)) {
      Storage.dynamicKeys.remove(key);
    }
  }

  Future<void> removeByListKey(List<String> keys) async {
    await removeAllDynamicData();
    for (String key in keys) {
      removeByKey(key);
    }
  }

  /*----------------Xu ly localStorage cho cac key khong tuong minh -------------*/
  Future<void> saveDynamicString(String dynamicKey, String value) async {
    Storage.dynamicKeys.add(dynamicKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(dynamicKey, value);
  }

  Future<void> saveDynamicInteger(String dynamicKey, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(dynamicKey, value);
  }

  Future<void> saveDynamicBoolean(String dynamicKey, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(dynamicKey, value);  }

  Future<String> getDynamicString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }
  Future<bool> isExitDynamicStringKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
  Future<void> removeAllDynamicData() async {
    for(String key in Storage.dynamicKeys)
    {
      await removeDynamicByKey(key);
    }
  }
  Future<void> removeDynamicByKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if(Storage.dynamicKeys.contains(key))
    {
      await prefs.remove(key);
      Storage.dynamicKeys.remove(key);
    }
    removeByKey(key);
  }

  Future<void> removeDynamicByKeys(List<String> keys) async {
    final prefs = await SharedPreferences.getInstance();
    for(String key in keys)
    {
      if(Storage.dynamicKeys.contains(key))
      {
        await prefs.remove(key);
        Storage.dynamicKeys.remove(key);
      }
      removeByKey(key);
    }
  }
  int getDynamicInt(String dynamicKey) {
    return prefs.getInt(dynamicKey)??0;
  }

  bool getDynamicBoolean(String dynamicKey)  {
    return prefs.getBool(dynamicKey)??false;
  }


  Future<void> removeAllDynamicKeys() async {
    await removeByListKey(Storage.dynamicKeys);
    Storage.dynamicKeys.clear();
  }

  /*---------------------------------------------------------------*/
  Future<void> removeAll() async {
    Map<String, String> getKeyLogoutSessions = await getKeyLogoutSessionByString();
    await removeAllDynamicKeys();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    saveKeyLogoutSession(getKeyLogoutSessions);
  }
}

class LocalStorage {
  Map<String, String> getKeyLogoutSessionByString() {
    Map<String, String> keyLogoutSessions =
    getStringByKeys(Storage.needSaveKeysLogoutSession);
    return keyLogoutSessions;
  }

  Future<void> saveKeyLogoutSession(Map<String, String> keyLogoutSessions) async{
    saveListValueString(keyLogoutSessions);
  }

  Map<String, String> getStringByKeys(List<String> keys) {
    Map<String, String> keyLogoutSessions = {};
    for (String key in keys) {
      keyLogoutSessions[key] = getString(key);
    }
    return keyLogoutSessions;
  }

  Future<void> saveListValueString(Map<String, String> listStringValues) async{
    for (var key in listStringValues.keys) {
      html_cache.window.localStorage[key] = listStringValues[key]!;
    }
  }

  Future<void> saveFileDataByKey(String key, Uint8List dataFile) async {
    String dataStr = String.fromCharCodes(dataFile);
    await saveDynamicString(key, dataStr);
  }

  Future<Uint8List> getFileDataByKey(String key) async {
    String dataStr = await getDynamicString(key);
    List<int> dataList = dataStr.codeUnits;
    Uint8List uint8ListData = Uint8List.fromList(dataList);
    return uint8ListData;
  }
  Future<void> removeFileDataByKey(String key) async {
    await removeDynamicByKey(key);
  }
  Future<void> removeFileDataByKeys(List<String> keys) async {
    await removeDynamicByKeys(keys);
  }
  Future<bool> isExitFileDataByKey(String key) async {
    bool isExits = await isExitDynamicStringKey(key);
    return isExits;
  }

  void saveString(String key, String value) {
    html_cache.window.localStorage[key] = value;
  }

  void saveInteger(String key, int value) {
    html_cache.window.localStorage[key] = value.toString();
  }

  void saveDouble(String key, double value) {
    html_cache.window.localStorage[key] = value.toString();
  }
  void saveBoolean(String key, bool value) {
    html_cache.window.localStorage[key] = value.toString();
  }

  String getString(String key) {
    return html_cache.window.localStorage[key] ?? '';
  }

  int getInt(String key,{int? valueDefault}) {
    return int.tryParse(html_cache.window.localStorage[key] ?? "${valueDefault??0}")??0;
  }
  double getDouble(String key,{double? valueDefault}) {
    return double.tryParse(html_cache.window.localStorage[key] ?? "${valueDefault??0}")??0;
  }
  bool getBoolean(String key) {
    return html_cache.window.localStorage[key] == 'true';
  }

  bool keyIsExit(String key) {
    if (html_cache.window.localStorage.containsKey(key)) {
      return true;
    }
    return false;
  }

  void removeByKey(String key) {
    if (html_cache.window.localStorage.containsKey(key)) {
      html_cache.window.localStorage.remove(key);
    }
    if (Storage.dynamicKeys.contains(key)) {
      Storage.dynamicKeys.remove(key);
    }
  }

  Future<void> removeByListKey(List<String> keys) async {
    await removeAllDynamicData();
    for (String key in keys) {
      removeByKey(key);
    }
  }

  /*----------------Xu ly localStorage cho cac key khong tuong minh -------------*/
  Future<void> saveDynamicString(String dynamicKey, String value) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(dynamicKey, value);
      Storage.dynamicKeys.add(dynamicKey);

    }
    catch(e)
    {
      FileUtils.printLog(e.toString());
    }
    //html_cache.window.localStorage[dynamicKey] = value;
  }

  void saveDynamicInteger(String dynamicKey, int value) {
    html_cache.window.localStorage[dynamicKey] = value.toString();
  }

  void saveDynamicBoolean(String dynamicKey, bool value) {
    html_cache.window.localStorage[dynamicKey] = value.toString();
  }

  Future<String> getDynamicString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
    // return html_cache.window.localStorage[key] ?? '';
  }
  Future<bool> isExitDynamicStringKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
    // return html_cache.window.localStorage[key] ?? '';
  }
  Future<void> removeAllDynamicData() async {
    for(String key in Storage.dynamicKeys)
    {
      await removeDynamicByKey(key);
    }
    // return html_cache.window.localStorage[key] ?? '';
  }
  Future<void> removeDynamicByKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if(Storage.dynamicKeys.contains(key))
    {
      await prefs.remove(key);
      Storage.dynamicKeys.remove(key);
    }
    removeByKey(key);
  }

  Future<void> removeDynamicByKeys(List<String> keys) async {
    final prefs = await SharedPreferences.getInstance();
    for(String key in keys)
    {
      if(Storage.dynamicKeys.contains(key))
      {
        await prefs.remove(key);
        Storage.dynamicKeys.remove(key);
      }
      removeByKey(key);
    }
  }
  int getDynamicInt(String dynamicKey) {
    return int.tryParse(html_cache.window.localStorage[dynamicKey] ?? '0')??0;
  }

  bool getDynamicBoolean(String dynamicKey) {
    return html_cache.window.localStorage[dynamicKey] == 'true';
  }


  Future<void> removeAllDynamicKeys() async {
    await removeByListKey(Storage.dynamicKeys);
    Storage.dynamicKeys.clear();
  }

  /*---------------------------------------------------------------*/
  Future<void> removeAll() async {
    Map<String, String> getKeyLogoutSessions = getKeyLogoutSessionByString();
    await removeAllDynamicKeys();
    html_cache.window.localStorage.clear();
    saveKeyLogoutSession(getKeyLogoutSessions);
  }
}

class SessionStorage {
  void saveString(String key, String value) {
    html_cache.window.sessionStorage[key] = value;
  }

  void saveInteger(String key, int value) {
    html_cache.window.sessionStorage[key] = value.toString();
  }

  void saveBoolean(String key, bool value) {
    html_cache.window.sessionStorage[key] = value.toString();
  }

  String getString(String key) {
    return html_cache.window.sessionStorage[key] ?? '';
  }

  int getInt(String key) {
    return int.tryParse(html_cache.window.sessionStorage[key] ?? '0')??0;
  }

  bool getBoolean(String key) {
    return html_cache.window.sessionStorage[key] == 'true';
  }

  void removeByKey(String key) {
    if (html_cache.window.sessionStorage.containsKey(key)) {
      html_cache.window.sessionStorage.remove(key);
    }
  }

  void removeAll() {
    html_cache.window.sessionStorage.clear();
  }
}

class CookieStorage {
  void saveString(String key, int value, int secondExpired) {
    html_cache.window.document.cookie = "$key=$value;max-age=$secondExpired; ";
  }

  void saveInteger(String key, int value, int secondExpired) {
    html_cache.window.document.cookie = "$key=$value;max-age=$secondExpired; ";
  }

  void saveBoolean(String key, bool value, int secondExpired) {
    html_cache.window.document.cookie = "$key=$value;max-age=$secondExpired; ";
  }

  String getString(String key) {
    Map<dynamic, dynamic> cookieData = convertToMap();
    return cookieData.containsKey(key) ? cookieData[key] : '';
  }

  int getInt(String key) {
    Map<dynamic, dynamic> cookieData = convertToMap();
    return int.tryParse(cookieData.containsKey(key) ? cookieData[key] : '0')??0;
  }

  bool getBoolean(String key) {
    Map<dynamic, dynamic> cookieData = convertToMap();
    return cookieData.containsKey(key) ? (cookieData[key] == "true") : false;
  }

  void removeByKey(String key) {
    Map<dynamic, dynamic> cookieData = convertToMap();
    if (cookieData.containsKey(key)) {
      cookieData.remove(key);
      html_cache.window.document.cookie = cookieData.toString();
    }
  }

  void removeAll() {
    html_cache.window.document.cookie = "";
  }

  Map convertToMap() {
    final cookie = html_cache.window.document.cookie!;
    final entity = cookie.split("; ").map((item) {
      final split = item.split("=");
      return MapEntry(split[0], split[1]);
    });
    return Map.fromEntries(entity);
  }
}
