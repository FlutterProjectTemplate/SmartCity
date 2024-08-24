import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:smart_city/controller/login/login_api.dart';
import 'package:smart_city/controller/login/login_request.dart';

part  'login_event.dart';
part  'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() :super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final loginRequest = LoginRequest(username: event.username, password: event.password);
    final loginSuccessfully = await LoginApi(loginRequest).call();
    if(loginSuccessfully){
      emit(state.copyWith(status: LoginStatus.success));
    }else{
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}
