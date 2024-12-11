part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String username;
  final String phone;
  final String password;
  final String email;
  final int vehicleType;
//  final int customerId;

  const RegisterSubmitted(
      this.name, this.username, this.password, this.vehicleType, this.phone, this.email,
      );
  @override
  List<Object?> get props => [name, username, password, vehicleType, phone, email];
}
