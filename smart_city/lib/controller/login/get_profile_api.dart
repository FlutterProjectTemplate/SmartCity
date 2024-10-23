import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/model/user/user_detail.dart';

class GetProfileApi extends BaseApiRequest {
  GetProfileApi()
      : super(
          serviceType: SERVICE_TYPE.USER,
          apiName: ApiName.getInstance().PROFILE,
        );

  Future<UserDetail> call() async {
    await getAuthorization();
    dynamic result = await getRequestAPI();
    if (kDebugMode) {
      print(result.toString());
    }
    if (result.runtimeType == ResponseCommon) {
      return UserDetail();
    } else {
      return UserDetail.fromJson(result);
    }
  }

  Future<void> getAuthorization() async {}

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
