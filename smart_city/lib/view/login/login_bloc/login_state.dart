part of 'login_bloc.dart';

enum LoginStatus { initial, success, failure, loading }

class LoginState extends Equatable {
  final LoginStatus status;
  final String username;
  final String password;

  const LoginState({
    this.status = LoginStatus.initial,
    this.username = '',
    this.password = '',
  });

  LoginState copyWith(
      {LoginStatus? status, String? username, String? password}) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [status, username, password];
}
