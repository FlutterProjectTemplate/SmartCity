import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';



class ForgotPasswordApi extends BaseApiRequest {
  String email;
  ForgotPasswordApi({required this.email})
      : super(
    serviceType: SERVICE_TYPE.AUTHEN,
    apiName: ApiName.getInstance().FORGOT_PASSWORD,
  );

  Future<dynamic> call() async {
    getAuthorization();
    dynamic result = await postRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      ResponseCommon responseCommon = result as ResponseCommon;
      return responseCommon.message??"";
    } else {
      return true;
    }
  }

  Future<void> getAuthorization() async {

    setApiBody({"email": email});
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
