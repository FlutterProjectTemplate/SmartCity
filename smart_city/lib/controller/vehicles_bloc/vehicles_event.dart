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

class OnChangeVehicleSuccessEvent extends VehiclesEvent {
  const OnChangeVehicleSuccessEvent();

  @override
  List<Object> get props => [];
}

class OnChangeVehicleFailedEvent extends VehiclesEvent {
  const OnChangeVehicleFailedEvent();

  @override
  List<Object> get props => [];
}
