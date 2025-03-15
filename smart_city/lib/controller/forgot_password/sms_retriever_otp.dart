import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class SmsRetrieverOTP implements SmsRetriever {
  const SmsRetrieverOTP(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsRetrieverApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsWithUserConsentApi(
    );
    if (res.hasData) {
      return res.data?.code;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
