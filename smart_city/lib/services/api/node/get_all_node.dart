import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';

import '../../../model/node/all_node_phase.dart';


class GetAllNodeApi extends BaseApiRequest {
  GetAllNodeApi()
      : super(
          serviceType: SERVICE_TYPE.NODE_PHASE,
          apiName: ApiName.getInstance().GET_ALL,
        );

  Future<AllNodePhase> call() async {
    getAuthorization();
    dynamic result = await getRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return AllNodePhase();
    } else {
      var list = AllNodePhase.fromJson(result);
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
