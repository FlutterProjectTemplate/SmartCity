import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/controller/login/login_request.dart';
import 'package:smart_city/controller/login/login_response.dart';
import 'package:smart_city/model/user/user_info.dart';

class LoginApi extends BaseApiRequest{
  ValueSetter<bool> _apiCallback = (value) {};
  LoginRequest? _loginRequest;
  LoginResponse? loginResponse;
  LoginApi(LoginRequest loginRequest, ValueSetter<bool> apiCallback)
      : super(
      serviceType: SERVICE_TYPE.AUTHEN,
      apiName: ApiName.getInstance().LOGIN,
      requestBody: loginRequest.toJson(),
      isCheckToken: false,
      isShowErrorPopup: false
  ) {
    _apiCallback = apiCallback;
    _loginRequest = loginRequest;
  }

  Future<dynamic> call()async{
    dynamic data = await postRequestAPI();
    if(data != null && data.runtimeType != ResponseCommon){
      UserInfo userInfo = UserInfo();
      userInfo.userId = "0";
      userInfo.username = loginResponse?.username;
      userInfo.password = _loginRequest?.password;
      userInfo.token = loginResponse?.token;
      userInfo.phoneNumber = "None";
      userInfo.expiredAt = loginResponse?.expiredAt;
      userInfo.address = "None";
      userInfo.rules = "None";
      await SqliteManager.getInstance.insertCurrentLoginUserInfo(userInfo);
      return true;
    }else{
      return false;
    }
  }
  @override
  Future<void> onRequestSuccess(var data) async {
    // TODO: implement onRequestSuccess
    super.onRequestSuccess(data);
    _apiCallback(true);
  }

  @override
  Future<void> onRequestError(int? statusCode, String? statusMessage) async{
    // TODO: implement onRequestError
    super.onRequestError(statusCode, statusMessage);
    _apiCallback(false);
  }
}