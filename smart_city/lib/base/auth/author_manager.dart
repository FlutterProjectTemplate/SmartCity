import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/routes/error_route_screen.dart';
import 'package:smart_city/base/store/cached_storage.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/helpers/services/location_service.dart';
import 'package:smart_city/helpers/services/navigation_service.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/services/api/refresh_token/refresh_token_api.dart';

import '../sqlite_manager/sqlite_manager.dart';

class AuthorManager {
  static final AuthorManager _singletonAuthorManager = AuthorManager._internal();
  static AuthorManager get getInstance => _singletonAuthorManager;

  factory AuthorManager() {
    return _singletonAuthorManager;
  }

  AuthorManager._internal();

  bool allowCallRefreshToken = true;
  static const String _loggedInUserKey = "isLoggedIn";
  bool isLoggedIn = false;
  Future<void> init() async {
    await initData();
  }

  Future<void> initData() async {
    isLoggedIn = SharedPreferencesStorage().getBoolean(_loggedInUserKey);
  }


  Future<void> setLoggedInUser(bool loggedIn) async {
    return await SharedPreferencesStorage().saveBoolean(_loggedInUserKey, loggedIn);
  }

  Future<void> removeLoggedInUser() async {
    return SharedPreferencesStorage().removeByKey(_loggedInUserKey);
  }

  Future<void> deleteDataWhenLogout() async {
    await setLoggedInUser(false);
    await SharedPreferencesStorage().removeAllDynamicData();
    await SharedPreferencesStorage().removeAllDynamicKeys();
  }

  // Define a function that inserts dogs into the database
  Future<void> saveAuthInfo(AuthInfo loginResponse) async {
    await setLoggedInUser(true);
    SharedPreferencesStorage().saveString(Storage.currentAuthInfoKey, jsonEncode(loginResponse.toJson()));
  }

  AuthInfo? getAuthInfo() {
    String authStr = SharedPreferencesStorage().getString(Storage.currentAuthInfoKey);
    AuthInfo? userInfo;
    if (authStr.isNotEmpty) {
      userInfo = AuthInfo.fromJson(jsonDecode(authStr));
    }
    return userInfo;
  }

  Future<void> refreshToken() async {

    try{
      if (allowCallRefreshToken == false) {
        return;
      }
      allowCallRefreshToken = false;
      AuthInfo? authInfo = getAuthInfo();
      RefreshTokenApi refreshTokenApi = RefreshTokenApi(refreshToken: authInfo!.refreshToken!);
      final result = await refreshTokenApi.call();
      if (result == null) {
        await SharedPreferenceData.setLogOut();
        SqliteManager.getInstance.deleteCurrentLoginUserInfo();
        SqliteManager.getInstance.deleteCurrentLoginUserDetail();
        SqliteManager.getInstance.deleteCurrentCustomerDetail();
        if(NavigationService.navigatorKey.currentState?.context!=null) {
          BuildContext context = NavigationService.navigatorKey.currentState!.context;
          context.go('/login');
        }
      }
      allowCallRefreshToken = true;
    }
    catch(e){
      allowCallRefreshToken = true;
      if(NavigationService.navigatorKey.currentState?.context!=null) {
        BuildContext context = NavigationService.navigatorKey.currentState!.context;
        context.go('/login');
        }
        await SharedPreferenceData.setLogOut();
        SqliteManager.getInstance.deleteCurrentLoginUserInfo();
        SqliteManager.getInstance.deleteCurrentLoginUserDetail();
        SqliteManager.getInstance.deleteCurrentCustomerDetail();
    }

  }

  Future<void> removeAuthInfo() async {
    SharedPreferencesStorage().removeByKey(Storage.currentAuthInfoKey);
  }

  Future<void> handleLogout() async {
    await removeAuthInfo();
    AuthorManager().deleteDataWhenLogout();
    await LocationService().stopService();
    setLoggedInUser(false);
  }
}

class AuthInfo {
  String? pageMain;
  String? accessToken;
  String? refreshToken;
  String? refreshTokenExpiredAt;
  String? username;
  String? expiredAt;

  AuthInfo({this.pageMain, this.accessToken, this.username, this.expiredAt});

  AuthInfo.fromJson(Map<String, dynamic> json) {
    pageMain = json['pageMain'];
    accessToken = json['token'];
    refreshToken = json['refreshToken'];
    username = json['username'];
    expiredAt = json['expiredAt'];
    refreshTokenExpiredAt = json['refreshTokenExpiredAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageMain'] = pageMain;
    data['token'] = accessToken;
    data['username'] = username;
    data['refreshToken'] = refreshToken;
    data['expiredAt'] = expiredAt;
    data['refreshTokenExpiredAt'] = refreshTokenExpiredAt;
    return data;
  }
}
