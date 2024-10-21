import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_city/base/common/responsive_info.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent,VehiclesState>{
  VehicleType? vehicleType;
  VehiclesBloc({this.vehicleType}) : super(VehiclesState(vehicleType: (vehicleType != null) ? vehicleType : (ResponsiveInfo.isTablet()) ? VehicleType.car : VehicleType.pedestrians)){
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
    on<OfficialEvent>((event, emit) {
      emit(const VehiclesState(vehicleType: VehicleType.official));
    });
  }

}