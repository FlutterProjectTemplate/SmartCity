part of 'vehicles_bloc.dart';


enum BlocStatus {
  idle,
  waiting,
  success,
  failed,
}

class VehiclesState extends Equatable {
  BlocStatus? blocStatus;
  VehicleTypeInfo? vehicleType;
  VehiclesState({this.blocStatus, this.vehicleType});

  VehiclesState copyWith({
    BlocStatus? blocStatus,
    VehicleTypeInfo? vehicleType,
  }) {
    return VehiclesState(
      blocStatus: blocStatus ?? this.blocStatus,
      vehicleType: vehicleType ?? this.vehicleType,
    );
  }

  @override
  List<dynamic> get props => [blocStatus, vehicleType];
}
