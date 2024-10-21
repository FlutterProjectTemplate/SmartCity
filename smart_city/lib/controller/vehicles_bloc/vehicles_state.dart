part of 'vehicles_bloc.dart';

enum VehicleType { pedestrians, cyclists, cityVehicle , truck, car, official}

class VehiclesState extends Equatable {
  final VehicleType vehicleType;
  const VehiclesState({ required this.vehicleType });

  @override
  List<Object> get props => [vehicleType];
}