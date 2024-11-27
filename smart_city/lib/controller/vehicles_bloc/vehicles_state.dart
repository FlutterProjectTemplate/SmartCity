part of 'vehicles_bloc.dart';

enum VehicleType {
  BIK,
  PED,
  BUS,
  TRK,
  AMB,
  FTR,
  MLV,
  AMC,
  TRC,
  AGV,
  OFV,
  EVP,
}

enum BlocStatus {
  idle,
  waiting,
  success,
  failed,
}

class VehiclesState extends Equatable {
  final BlocStatus blocStatus;
  final VehicleType vehicleType;

  const VehiclesState({required this.blocStatus, required this.vehicleType});

  VehiclesState copyWith({
    BlocStatus? blocStatus,
    VehicleType? vehicleType,
  }) {
    return VehiclesState(
      blocStatus: blocStatus ?? this.blocStatus,
      vehicleType: vehicleType ?? this.vehicleType,
    );
  }

  @override
  List<Object> get props => [blocStatus, vehicleType];
}
