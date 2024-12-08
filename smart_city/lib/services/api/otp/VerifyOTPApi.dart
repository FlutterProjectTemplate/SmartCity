
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';

import 'RequestOTPApi.dart';

class VerifyOTPApi extends BaseApiRequest {
  String phone;
  String otp;
  OtpType otpType;

  VerifyOTPApi({required this.phone, required this.otp, required this.otpType})
      : super(
      serviceType: SERVICE_TYPE.AUTHEN,
      apiName: ApiName.getInstance().VERIFY_OTP,
      isCheckToken: false
  );
  Future<dynamic> call() async {
    await getAuthorization();
    dynamic data = await postRequestAPI();
   if(data!=null && data.runtimeType !=ResponseCommon)
     {
       return true;
     }
   else
     {
       return false;
     }
  }

  Future<void> getAuthorization() async {
    await setApiBody({
      "phone":phone,
      "otp":otp,
      "otpType":otpTypeMapStr[otpType]
    });
  }
  @override
  Future<void> onRequestSuccess(var data) async {
    // TODO: implement onRequestSuccess
    super.onRequestSuccess(data);
  }

  @override
  Future<void> onRequestError(int? statusCode, String? statusMessage) async{
    // TODO: implement onRequestError
    super.onRequestError(statusCode, statusMessage);
  }
}
