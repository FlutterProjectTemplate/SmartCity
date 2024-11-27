import 'dart:async';

import 'package:dio/dio.dart';
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';

import '../../../model/user/user_detail.dart';
import '../login/get_profile_api.dart';

class UploadAvatarApi extends BaseApiRequest {
  final MultipartFile multipartFile;
  UploadAvatarApi({required this.multipartFile})
      : super(
    serviceType: SERVICE_TYPE.USER,
    apiName: ApiName.getInstance().AVATAR,
    bodyMethod: BodyMethod.formData,
  );

  Future<bool> call() async {
    getAuthorization();
    dynamic result = await postRequestAPI();
    if (result.runtimeType == ResponseCommon) {
      return false;
    } else {
      if (result == null) {
        return false;
      } else {
        GetProfileApi getProfileApi = GetProfileApi();
        await getProfileApi.call();
        return true;
      }
    }
  }

  Future<void> getAuthorization() async {
    setApiBody({'avatar': multipartFile});
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
