import 'dart:async';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/controller/login/get_customer_api.dart';
import 'package:smart_city/controller/login/login_request.dart';
import 'package:smart_city/controller/login/get_profile_api.dart';
import 'package:smart_city/model/user/user_info.dart';

import '../../model/customer/customer_model.dart';
import '../../model/user/user_detail.dart';

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
    getAuthorization();
    dynamic data = await postRequestAPI();
    if(data != null && data.runtimeType != ResponseCommon){
      UserInfo userInfo = UserInfo();
      userInfo.username = _loginRequest?.username;
      userInfo.password = _loginRequest?.password;
      userInfo.token = data['token'];
      userInfo.refreshToken = data['refreshToken'];
      userInfo.phoneNumber = "None";
      userInfo.expiredAt = data['expiredAt'];
      userInfo.address = "None";
      userInfo.rules = "None";
      await SqliteManager.getInstance.insertCurrentLoginUserInfo(userInfo);

      GetProfileApi getProfileApi = GetProfileApi();
      UserDetail userDetail = await getProfileApi.call();
      await SqliteManager.getInstance.insertCurrentLoginUserDetail(userDetail);

      // GetCustomerApi getCustomerApi = GetCustomerApi();
      // CustomerModel customerModel = await getCustomerApi.call();
      // await SqliteManager.getInstance.insertCurrentCustomerDetail(customerModel);

      userInfo.userId = userDetail.id.toString();
      await SqliteManager.getInstance.insertCurrentLoginUserInfo(userInfo);

      return true;
    }else{
      return false;
    }
  }

  Future<void> getAuthorization() async {
    if (ResponsiveInfo.isTablet() ) {
      setHeaderAdd({'client': 'Tablet'});
    } else {
      setHeaderAdd({'client': 'Mobile'});
    }
  }
}