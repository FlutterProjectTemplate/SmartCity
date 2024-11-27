import 'dart:async';

import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
import 'package:smart_city/services/api/update_profile/update_profile_model/update_profile_model.dart';

import '../../../base/sqlite_manager/sqlite_manager.dart';
import '../../../model/user/user_detail.dart';
import '../login/get_profile_api.dart';



class UpdateProfileApi extends BaseApiRequest {
  final UpdateProfileModel updateProfileModel;
  UpdateProfileApi({required this.updateProfileModel})
      : super(
    serviceType: SERVICE_TYPE.USER,
    apiName: ApiName.getInstance().PROFILE,
  );

  Future<bool> call() async {
    getAuthorization();
    dynamic result = await putRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return false;
    } else {
      GetProfileApi getProfileApi = GetProfileApi();
      UserDetail userDetail = await getProfileApi.call();
      return true;
    }
  }

  Future<void> getAuthorization() async {
    setApiBody(updateProfileModel.toJson());
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
