
import 'package:smart_city/base/services/base_request/base_api_request.dart';
import 'package:smart_city/base/services/base_request/domain.dart';
import 'package:smart_city/base/services/base_request/models/response_error_objects.dart';

enum OtpType{
  login,
  createCustomer,
  forgetPin
}
Map<OtpType, String>otpTypeMapStr={
  OtpType.login:"Login",
  OtpType.createCustomer:"CreateCustomer",
  OtpType.forgetPin:"ForgetPin"

};
class RequestOTPApi extends BaseApiRequest {
  String phone;
  OtpType otpType;
  RequestOTPApi({required this.phone, required this.otpType})
      : super(
      serviceType: SERVICE_TYPE.AUTHEN,
      apiName: ApiName.getInstance().REQUEST_OTP,
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
    await setApiBody(
        {
          "phone":phone,
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
