import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/controller/helper/map_helper.dart';
import 'package:smart_city/services/api/vector/vector_model/vector_model.dart';

import '../../../model/node/all_node_phase.dart';
import '../../../model/user/user_detail.dart';


class GetVectorApi extends BaseApiRequest {
  //distance (km)
  final double? distance;
  final LatLng? location;
  GetVectorApi(this.distance, this.location)
      : super(
    serviceType: SERVICE_TYPE.VECTOR,
    apiName: ApiName.getInstance().Seach_by_radious,
  );

  Future<VectorModel> call() async {
    getAuthorization();
    dynamic result = await postRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return VectorModel([]);
    } else {
      var list = VectorModel.fromJson(result);
      return list;
    }
  }

  Future<void> getAuthorization() async {
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();

    Position? position = await MapHelper().getCurrentPosition();

    setHeaderAdd({"customerId": userDetail?.customerId});

    if (distance != null && location != null) {
      setApiBody({
        "latitude": location?.latitude,
        "longitude": location?.longitude,
        "radius": (distance??0 * 2) < 5 ? 5 : distance??0 * 2,
      });
    } else
      if (distance != null) {
      setApiBody({
      "latitude": position?.latitude,
      "longitude": position?.longitude,
      "radius": (distance??0 * 2) < 5 ? 5 : distance??0 * 2,
      });
    }
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
