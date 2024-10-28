import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/services/api/vector/vector_model/vector_model.dart';

import '../../../model/node/all_node_phase.dart';


class GetVectorApi extends BaseApiRequest {
  GetVectorApi()
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
