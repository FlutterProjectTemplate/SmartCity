import 'package:flutter/cupertino.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/popup_confirm/confirm_popup_page.dart';

class AppVersionCheckerManager {
  static final AppVersionCheckerManager _singletonAppVersionCheckerManager = AppVersionCheckerManager._internal();

  static AppVersionCheckerManager get getInstance => _singletonAppVersionCheckerManager;

  factory AppVersionCheckerManager() {
    return _singletonAppVersionCheckerManager;
  }

  AppVersionCheckerManager._internal();

  void checkAppNewVersion(BuildContext context){
    final _checker = AppVersionChecker();
    _checker.checkUpdate().then((value) {
      int currentVersion = int.tryParse(value.currentVersion.replaceAll(".", ""))??0;
      int storeVersion = int.tryParse((value.newVersion??"0").replaceAll(".", ""))??0;
      if(storeVersion> currentVersion)
        {
          ConfirmPopupPage(
            title: L10nX().notification,
            content: L10nX().update_notify,
            onCancel: () {

            },
            onAccept: () {
              Uri  uri = Uri.parse(value.appURL??"");
              launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ).show(context);
        }
      print("value");
    });
  }
}