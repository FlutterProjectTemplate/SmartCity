import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/services/api/register/register_model/register_model.dart';

class RegisterApi extends BaseApiRequest {
  final RegisterModel registerModel;
  RegisterApi({required this.registerModel})
      : super(
    serviceType: SERVICE_TYPE.USER,
    apiName: ApiName.getInstance().CREATE_USER,
  );

  Future<bool> call() async {
    getAuthorization();
    dynamic result = await postRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> getAuthorization() async {
    setApiBody(registerModel.toJson());
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
