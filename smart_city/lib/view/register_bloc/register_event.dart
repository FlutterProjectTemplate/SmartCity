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
  {required this.name, required this.username, required this.password, required this.vehicleType, required this.phone, required this.email,}
      );
  @override
  List<Object?> get props => [name, username, password, vehicleType, phone, email];
}
