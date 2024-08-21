import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/user/user_info.dart';

class SharedPreferenceData{
  static String prefName = "com.fft_app";
  static String isFirstUsingApp = "${prefName}isLoggedIn";
  static String isLocationIn = "${prefName}isLocationIn";

  static Future<SharedPreferences> getPrefInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
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
  static Future<bool> isLogIn() async {
    UserInfo? userInfosList = await SqliteManager.getInstance.getCurrentLoginUserInfo();
    if(userInfosList!=null)
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

  static setLocation(bool location) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(isLocationIn, location);
  }

  static Future<bool> isLocation() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isLocationAvailable = preferences.getBool(isLocationIn) ?? false;
    return isLocationAvailable;
  }
}