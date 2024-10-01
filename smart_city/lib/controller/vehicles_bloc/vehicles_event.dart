part of 'vehicles_bloc.dart';

sealed class VehiclesEvent extends Equatable {
  const VehiclesEvent();

  @override
  List<Object> get props => [];
}

class PedestriansEvent extends VehiclesEvent {}

class CyclistsEvent extends VehiclesEvent {}

class TruckEvent extends VehiclesEvent {}

class CarEvent extends VehiclesEvent {}
