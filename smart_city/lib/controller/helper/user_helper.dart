import 'package:smart_city/base/firebase_manager/firebase_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/user/user_info.dart';
import 'dart:convert';
import 'package:smart_city/base/store/cached_storage.dart';

class UserHelper{
  static final UserHelper _singletonUserHelper = UserHelper._internal();
  factory UserHelper(){
    return _singletonUserHelper;
  }
  UserHelper._internal();

  Future<void> saveCurrentUserInfo(UserInfo userInfo) async {
   await SharedPreferencesStorage().saveString(Storage.currentUserInfoKey, json.encode(userInfo.toJson()));
  }

  Future<void> handleLogoutData() async {
    UserInfo? userInfos = await SqliteManager.getInstance.getCurrentSelectUserInfo();
    if(userInfos!=null){
      FirebaseManager.getInstance.removeSubscribeTopic(userInfos.userId!);
    }
    SqliteManager.getInstance.deleteDataWhenLogout();
  }

}