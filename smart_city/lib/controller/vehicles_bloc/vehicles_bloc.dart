import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent,VehiclesState>{
  VehiclesBloc() : super(const VehiclesState(vehicleType: VehicleType.pedestrians)){
    on<PedestriansEvent>((event, emit) {
      emit(const VehiclesState(vehicleType: VehicleType.pedestrians));
    });
    on<CyclistsEvent>((event, emit) {
      emit(const VehiclesState(vehicleType: VehicleType.cyclists));
    });
    on<TruckEvent>((event, emit) {
      emit(const VehiclesState(vehicleType: VehicleType.truck));
    });
    on<CarEvent>((event, emit) {
      emit(const VehiclesState(vehicleType: VehicleType.car));
    });
  }

}