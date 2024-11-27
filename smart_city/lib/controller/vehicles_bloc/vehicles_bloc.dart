import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/services/api/update_profile/update_profile_api.dart';
import 'package:smart_city/services/api/update_profile/update_profile_model/update_profile_model.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  VehicleType? vehicleType;

  VehiclesBloc({this.vehicleType})
      : super(VehiclesState(
    vehicleType: vehicleType ?? VehicleType.PED,
    blocStatus: BlocStatus.idle,
  )) {
    on<OnChangeVehicleEvent>((event, emit) async {
      if (state.blocStatus == BlocStatus.waiting) return;

      emit(state.copyWith(blocStatus: BlocStatus.waiting));

      try {
        int vehicleNum = InstanceManager().getVehicleTypeNum(event.vehicleType);
        final updateProfileApi = UpdateProfileApi(
          updateProfileModel: UpdateProfileModel(vehicleType: vehicleNum),
        );
        bool success = await updateProfileApi.call();

        if (success) {
          emit(state.copyWith(
            vehicleType: event.vehicleType,
            blocStatus: BlocStatus.success,
          ));
        } else {
          emit(state.copyWith(blocStatus: BlocStatus.failed));
        }
      } catch (e) {
        emit(state.copyWith(blocStatus: BlocStatus.failed));
      }
    });
  }
}
