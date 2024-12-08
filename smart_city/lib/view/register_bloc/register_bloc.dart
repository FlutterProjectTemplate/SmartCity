import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/services/api/otp/RequestOTPApi.dart';
import 'package:smart_city/services/api/otp/VerifyOTPApi.dart';

import '../../../services/api/login/login_api.dart';
import '../../../services/api/login/login_request.dart';
import '../../services/api/register/register_api.dart';
import '../../services/api/register/register_model/register_model.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  void _onRegisterSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    RequestOTPApi requestOTPApi = RequestOTPApi(phone: event.phone, otpType: OtpType.createCustomer);
    dynamic result = await requestOTPApi.call();
    VerifyOTPApi verifyOTPApi = VerifyOTPApi(phone: event.phone, otp: "123456", otpType: OtpType.createCustomer);
    bool resultVerify =await verifyOTPApi.call();
    if(resultVerify)
      {
        RegisterApi registerApi = RegisterApi(
            registerModel: RegisterModel(
                name: event.name,
                username: event.username,
                password: event.password,
                // phone: _phoneController.text,
                email: event.email,
                vehicleType: event.vehicleType,
                phone: event.phone,
                pinCode: event.password,
              customerId: event.customerId
            ));
        final registerSuccessfully = await registerApi.call();
        if (registerSuccessfully) {
          emit(state.copyWith(status: RegisterStatus.success));
        } else {
          emit(state.copyWith(status: RegisterStatus.failure));
        }
      }
    else
      {
        emit(state.copyWith(status: RegisterStatus.failure));
      }

  }
}
