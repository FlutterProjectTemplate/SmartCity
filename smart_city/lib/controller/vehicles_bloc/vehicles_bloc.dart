import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/services/api/get_vehicle/models/get_vehicle_model.dart';
import 'package:smart_city/services/api/update_profile/update_profile_api.dart';
import 'package:smart_city/services/api/update_profile/update_profile_model/update_profile_model.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';

import '../../base/utlis/loading_common.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {

  VehiclesBloc() : super(VehiclesState()) {
    on<OnVehicleInitEventEvent>((event, emit) async {
      UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
      state.vehicleType = await userDetail?.getVehicleTypeInfo();
      emit(state.copyWith(
        blocStatus: BlocStatus.idle,
      ));
    });
    on<OnChangeVehicleEvent>((event, emit) async {
      CustomLoading().showLoading();
      try {
        UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
        userDetail?.vehicleTypeNum =event.vehicleType.id;
        final updateProfileApi = UpdateProfileApi(
          updateProfileModel: userDetail!,
        );
        bool success = await updateProfileApi.call();

        if (success) {
          emit(state.copyWith(
            vehicleType: event.vehicleType,
            blocStatus: BlocStatus.success,
          ));
        } else {
          emit(state.copyWith(
              blocStatus: BlocStatus.failed,
          ));
        }
      } catch (e) {
        emit(state.copyWith(blocStatus: BlocStatus.failed));
      }
      CustomLoading().dismissLoading();
    });
  }
}
