import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/model/customer/customer_model.dart';

class GetCustomerApi extends BaseApiRequest {
  GetCustomerApi()
      : super(
          serviceType: SERVICE_TYPE.CUSTOMER,
          apiName: '',
        );

  Future<CustomerModel> call() async {
    await getAuthorization();
    dynamic result = await getRequestAPI();
    print(result.toString());
    if (result.runtimeType == ResponseCommon) {
      return CustomerModel();
    } else {
      return CustomerModel.fromJson(result);
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
