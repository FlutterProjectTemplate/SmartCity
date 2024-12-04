import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/controller/helper/user_helper.dart';
import 'package:smart_city/model/user/user_detail.dart';

class UpdateAppManager{
  static final UpdateAppManager _singletonUpdateAppManager = UpdateAppManager._internal();
  static UpdateAppManager get getInstance => _singletonUpdateAppManager;

  factory UpdateAppManager() {
    return _singletonUpdateAppManager;
  }
  UpdateAppManager._internal();
  final updater = ShorebirdUpdater();

  void checkAppVersion(){

    try{
      updater.readCurrentPatch().then((currentPatch) {
        print('The current patch number is: ${currentPatch?.number}');
      });
    }
    catch(e){

    }
  }
  Future<void> checkForUpdates() async {
    // Check whether a new update is available.
    try{
      final status = await updater.checkForUpdate();
      UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
      if (userDetail!=null && status == UpdateStatus.outdated) {
        try {
          // Perform the update
          await updater.update();
        } on UpdateException catch (error) {
          // Handle any errors that occur while updating.
          print("Can't update app with error: ${error.toString()}");

        }
      }
    }
    catch(e){

    }
  }
}