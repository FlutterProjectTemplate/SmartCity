import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/user/user_detail.dart';



class DeleteUserApi extends BaseApiRequest {
  DeleteUserApi()
      : super(
    serviceType: SERVICE_TYPE.USER,
    apiName: ApiName.getInstance().DELETE_USER,
  );

  Future<bool> call() async {
    getAuthorization();
    dynamic result = await deleteRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> getAuthorization() async {
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    setPathVariAble({
      "userId":userDetail?.id
    });
  }

  @override
  Future<void> onRequestSuccess(var data) async {
    // TODO: implement onRequestSuccess
    super.onRequestSuccess(data);
  }

  @override
  Future<void> onRequestError(int? statusCode, String? statusMessage) async {
    // TODO: implement onRequestError
    super.onRequestError(statusCode, statusMessage);
  }
}
