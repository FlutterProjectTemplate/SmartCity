import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';

import '../../../base/sqlite_manager/sqlite_manager.dart';
import 'models/get_vehicle_model.dart';


class GetVehicleTypeApi extends BaseApiRequest {
  GetVehicleTypeApi()
      : super(
    serviceType: SERVICE_TYPE.APPROACH_TYPE,
    apiName: ApiName.getInstance().ALL,
  );

  Future<VehicleTypeResponseModel?> call() async {
    await getAuthorization();
    dynamic result = await getRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return VehicleTypeResponseModel(list: []);
    } else {
      VehicleTypeResponseModel getVehicleModel = VehicleTypeResponseModel.fromJson(result);
      await SqliteManager().insertVehicleType(getVehicleModel);
      return getVehicleModel;
    }
  }

  Future<void> getAuthorization() async {

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
