import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/services/api/get_vehicle/get_vehicle_model/get_vehicle_model.dart';

import '../../../base/sqlite_manager/sqlite_manager.dart';


class GetVehicleApi extends BaseApiRequest {
  GetVehicleApi()
      : super(
    serviceType: SERVICE_TYPE.VEHICLE_TYPE,
    apiName: ApiName.getInstance().ALL,
  );

  Future<bool> call() async {
    getAuthorization();
    dynamic result = await getRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return false;
    } else {
      GetVehicleModel getVehicleModel = GetVehicleModel.fromJson(result);
      await SqliteManager().insertVehicleType(getVehicleModel);
      return true;
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
