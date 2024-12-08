import 'dart:async';

import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/services/api/get_vehicle/get_vehicle_model/get_vehicle_model.dart';

import '../../../base/sqlite_manager/sqlite_manager.dart';
import 'get_vehicle_model/get_customer_model.dart';


class GetAllCustomerApi extends BaseApiRequest {
  GetAllCustomerApi()
      : super(
    serviceType: SERVICE_TYPE.CUSTOMER,
    apiName: ApiName.getInstance().GET_ALL_CUSTOMER,
    isCheckToken: false,

  );

  Future<GetCustomerModel> call() async {
    getAuthorization();
    dynamic result = await getRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return InstanceManager().customerModel;
    } else {
      GetCustomerModel getVehicleModel = GetCustomerModel.fromJsonList(result);
      InstanceManager().customerModel = getVehicleModel;
      return InstanceManager().customerModel;
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
