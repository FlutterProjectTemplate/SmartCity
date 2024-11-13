part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String username;
  final String password;
  final int vehicleType;

  const RegisterSubmitted(this.name, this.username, this.password, this.vehicleType);

  @override
  List<Object?> get props => [name, username, password, vehicleType];
}
