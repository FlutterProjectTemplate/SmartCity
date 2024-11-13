part of 'register_bloc.dart';

enum RegisterStatus { initial, success, failure, loading }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String name;
  final String username;
  final String password;
  final int vehicleType;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.name = '',
    this.username = '',
    this.password = '',
    this.vehicleType = 1,
  });

  RegisterState copyWith(
      {RegisterStatus? status,String? name, String? username, String? password, int? vehicleType}) {
    return RegisterState(
      status: status ?? this.status,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      vehicleType: vehicleType ?? this.vehicleType
    );
  }

  @override
  List<Object> get props => [status,name, username, password, vehicleType];
}
