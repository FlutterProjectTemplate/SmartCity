import 'package:flutter/material.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';

class MainNavigator {

  static final MainNavigator _singletonMainNavigator = MainNavigator._internal();
  static MainNavigator get getInstance => _singletonMainNavigator;
  factory MainNavigator() {
    return _singletonMainNavigator;
  }
  MainNavigator._internal();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final String loginPage = "/loginPage";
  final String settingsPage = "/settingsPage";
  final String homePage = "/homePage";
  final String mapSettingPage ="/mapSettingPage";
  final String detailFirebaseMessagePage = "/detailFirebaseMessagePage";


  void goBackLogin() {
    // TODO: go to Login Screen
    // MainNavigator.getInstance.route(
    //     context: InstanceManager.getInstance.rootContext,
    //     pageName: MainNavigator.getInstance.loginPage,
    //     page: const LoginScreen());
  }

  Future<dynamic>? route(
      {
        BuildContext? context,
        required String pageName,
        required Widget page,
        bool ?isReplace
      }) async{
    context ??= InstanceManager.getInstance.navigatorKey.currentContext;
    isReplace??=true;
    String? name = ModalRoute.of(context!)?.settings.name;
    if(name == pageName) {
      /// neu da o trang hien tai thi khong reload nua
      return null;
    }
    Route route = MaterialPageRoute(
        builder: (context) {
          InstanceManager.getInstance.rootContext = context;
          return page;
        },
        settings: RouteSettings(name: pageName)
    );
    // WebRouter.setHistoryState(title: pageName,url: pageName, data: null );
    if(isReplace)
    {
      Navigator.pushReplacement(
        context,
        route,
      ).then((value) {
        return value;
      },);
    }
    else
    {
      Navigator.push(
        context,
        route,
      ).then((value) {
        return value;
      },);
    }

    }

}
