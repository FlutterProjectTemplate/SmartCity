import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/user/user_info.dart';

class SharedPreferenceData{
  static String prefName = "com.fft_app";
  static String isFirstUsingApp = "${prefName}isLoggedIn";
  static String isLocationIn = "${prefName}isLocationIn";
  static String isSignInBiometric = "${prefName}isSignInBiometric";
  static String isLogOut = "${prefName}isLogOut";

  static Future<SharedPreferences> getPrefInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static Future<bool> setLogOut() async {
    SharedPreferences preferences = await getPrefInstance();
    return preferences.setBool(isLogOut, true);
  }

  static Future<bool> getLogOut() async {
    SharedPreferences preferences = await getPrefInstance();
    return preferences.getBool(isLogOut)??true;
  }

  static setHaveFirstUsingApp() async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(isFirstUsingApp, false);
  }

  static Future<bool> getHaveFirstUsingApp() async {
    SharedPreferences preferences = await getPrefInstance();
    bool? result = preferences.getBool(isFirstUsingApp);
    return result??true;
  }

  static Future<bool> turnOnSignInBiometric() async {
    SharedPreferences preferences = await getPrefInstance();
    return preferences.setBool(isSignInBiometric, true);
  }

  static Future<bool> checkSignInBiometric() async {
    SharedPreferences preferences = await getPrefInstance();
    return (preferences.getBool(isSignInBiometric)??false);
  }

  static Future<bool> isLogIn() async {
    UserInfo? userInfosList = await SqliteManager.getInstance.getCurrentLoginUserInfo();
    final isLogOut = await getLogOut();
    if(userInfosList!=null&&!isLogOut)
    {
      UserInfo currentUserInfo = userInfosList;
      if((currentUserInfo.token??"").isNotEmpty)
      {
        if((currentUserInfo.expiredAt??"").isNotEmpty)
        {
          DateTime dateTimeExpiredAt =DateTime.parse(currentUserInfo.expiredAt!);
          if(dateTimeExpiredAt.millisecondsSinceEpoch/1000 > DateTime.now().millisecondsSinceEpoch/1000+30)
          {
            return true;
          }
        }
      }
    }
    return false;
  }

  static Future<bool> isCheckUserSignedIn() async {
    UserInfo? userInfosList = await SqliteManager.getInstance.getCurrentLoginUserInfo();
    if(userInfosList!=null)
    {
      return true;
    }
    return false;
  }
}