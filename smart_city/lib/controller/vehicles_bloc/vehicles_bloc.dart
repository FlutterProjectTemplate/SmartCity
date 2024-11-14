import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/services/api/update_profile/update_profile_api.dart';
import 'package:smart_city/services/api/update_profile/update_profile_model/update_profile_model.dart';

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
        UpdateProfileApi updateProfileApi = UpdateProfileApi(updateProfileModel: UpdateProfileModel(
          vehicleType: VehicleTypeExtension.getVehicleId(event.vehicleType),
        ));

    });
  }
}
