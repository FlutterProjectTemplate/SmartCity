part of 'vehicles_bloc.dart';

enum VehicleType { pedestrians, cyclists, cityVehicle }

class VehiclesState extends Equatable {
  final VehicleType vehicleType;
  const VehiclesState({ required this.vehicleType });

  @override
  List<Object> get props => [vehicleType];
}