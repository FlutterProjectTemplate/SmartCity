import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';

import '../../../model/node/node_model.dart';


class GetNodeApi extends BaseApiRequest {
  int nodeId;

  GetNodeApi({required this.nodeId})
      : super(
          serviceType: SERVICE_TYPE.NODE,
          apiName: "/$nodeId",
        );

  Future<NodeModel> call() async {
    await getAuthorization();
    dynamic result = await getRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return NodeModel();
    } else {
      return NodeModel.fromJson(result);
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
