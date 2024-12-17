

import 'package:smart_city/base/auth/author_manager.dart';
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';

class RefreshTokenApi extends BaseApiRequest {
  String refreshToken;
  RefreshTokenApi({required this.refreshToken})
      : super(
          serviceType: SERVICE_TYPE.AUTHEN,
          apiName: ApiName.getInstance().refreshToken,
          isCheckToken: false,
          isShowErrorPopup: false,
        );
  Future<AuthInfo?> call() async {
    setApiBody({"refreshToken": refreshToken});
    final result = await postRequestAPI();
    if (result != null) {
      AuthInfo authInfo = AuthInfo.fromJson(result);
      await AuthorManager().saveAuthInfo(authInfo);
      return authInfo;
    }
    return null;
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
