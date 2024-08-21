import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part  'login_event.dart';
part  'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() :super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try{
      await Future.delayed(const Duration(seconds: 2));
      // Assuming login is successful
      emit(state.copyWith(status: LoginStatus.success, username: event.username));
    } on Exception {
      emit(state.copyWith(status: LoginStatus.failure));
      return;
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}
