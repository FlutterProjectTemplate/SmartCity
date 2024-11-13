import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/base/common/responsive_info.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  VehicleType? vehicleType;

  VehiclesBloc({this.vehicleType})
      : super(VehiclesState(
            vehicleType: (vehicleType != null)
                ? vehicleType
                : (ResponsiveInfo.isTablet())
                    ? VehicleType.car
                    : VehicleType.pedestrian)) {
    on<OnChangeVehicleEvent>((event, emit) {
      emit(VehiclesState(vehicleType: event.vehicleType));
    });
  }
}
