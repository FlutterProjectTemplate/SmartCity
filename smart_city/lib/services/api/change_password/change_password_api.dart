import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/services/api/change_password/change_password_model/change_password_model.dart';



class ChangePasswordApi extends BaseApiRequest {
  final ChangePasswordModel changePasswordModel;
  ChangePasswordApi({required this.changePasswordModel})
      : super(
    serviceType: SERVICE_TYPE.USER,
    apiName: ApiName.getInstance().CHANGE_PASSWORD,
  );

  Future<bool> call() async {
    getAuthorization();
    dynamic result = await putRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> getAuthorization() async {
    setApiBody(changePasswordModel.toJson());
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
