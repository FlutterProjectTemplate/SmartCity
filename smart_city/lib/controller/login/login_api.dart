import 'dart:async';
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/controller/login/login_request.dart';
import 'package:smart_city/model/user/user_info.dart';

class LoginApi extends BaseApiRequest{
  LoginRequest? _loginRequest;
  LoginApi(LoginRequest loginRequest)
      : super(
      serviceType: SERVICE_TYPE.AUTHEN,
      apiName: ApiName.getInstance().LOGIN,
      requestBody: loginRequest.toJson(),
      isCheckToken: false,
      isShowErrorPopup: false
  ) {
    _loginRequest = loginRequest;
  }

  Future<bool> call()async{
    dynamic data = await postRequestAPI();
    if(data != null && data.runtimeType != ResponseCommon){
      UserInfo userInfo = UserInfo();
      userInfo.userId = "0";
      userInfo.username = _loginRequest?.username;
      userInfo.password = _loginRequest?.password;
      userInfo.token = data['token'];
      userInfo.phoneNumber = "None";
      userInfo.expiredAt = data['expiredAt'];
      userInfo.address = "None";
      userInfo.rules = "None";
      await SqliteManager.getInstance.insertCurrentLoginUserInfo(userInfo);
      return true;
    }else{
      return false;
    }
  }
}