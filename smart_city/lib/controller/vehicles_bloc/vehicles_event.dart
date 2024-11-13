part of 'vehicles_bloc.dart';

sealed class VehiclesEvent extends Equatable {
  const VehiclesEvent();

  @override
  List<Object> get props => [];
}

class OnChangeVehicleEvent extends VehiclesEvent {
  final VehicleType vehicleType;

  const OnChangeVehicleEvent(this.vehicleType);

  @override
  List<Object> get props => [vehicleType];
}
