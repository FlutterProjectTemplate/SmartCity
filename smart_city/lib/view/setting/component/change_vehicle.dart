import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/services/api/get_vehicle/get_vehicle_model/get_vehicle_model.dart';
import 'package:smart_city/services/api/update_profile/update_profile_api.dart';
import 'package:smart_city/services/api/update_profile/update_profile_model/update_profile_model.dart';

import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../controller/vehicles_bloc/vehicles_bloc.dart';
import '../../../helpers/localizations/bloc/main_bloc.dart';
import '../../../model/user/user_info.dart';

class ChangeVehicle extends StatefulWidget {
  const ChangeVehicle({super.key});

  @override
  State<ChangeVehicle> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeVehicle> {
  UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
  Map<VehicleType, String> transport = InstanceManager().getTransport();
  Map<VehicleType, String> transportString = {
    VehicleType.truck: L10nX.getStr.truck,
    VehicleType.bicycle: L10nX.getStr.cyclists,
    VehicleType.pedestrian: L10nX.getStr.pedestrians,
    VehicleType.car: L10nX.getStr.car,
    VehicleType.officialVehicle: L10nX.getStr.official
  };

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
  create: (context) => VehiclesBloc(
    vehicleType: VehicleType.pedestrian
  ),
  child: Scaffold(

      backgroundColor: ConstColors.onPrimaryColor,
      appBar: AppBar(
        backgroundColor: ConstColors.onPrimaryColor,
        title: Text(
          L10nX.getStr.vehicle,
          style: ConstFonts()
              .copyWithTitle(fontSize: 25, color: ConstColors.surfaceColor),
        ),
        automaticallyImplyLeading: false,
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ConstColors.surfaceColor),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ConstColors.surfaceColor,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<VehiclesBloc, VehiclesState>(
          builder: (context, vehicleState) {
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: transport.length,
          separatorBuilder: (ctx, index) => const SizedBox(
            height: 15,
          ),
          itemBuilder: (context, int index) {
            // String s = transport.keys.elementAt(index).toString().substring(12);
            return Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: vehicleState.vehicleType ==
                          transport.keys.elementAt(index) ? ConstColors.primaryColor : ConstColors.surfaceColor),
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: RotatedBox(quarterTurns: 1, child: Image.asset(transport.values.elementAt(index)))),
                horizontalTitleGap: 15,
                title: Text(
                  transportString[transport.keys.elementAt(index)] ??
                      "unknown",
                  style: ConstFonts().copyWithTitle(
                      fontSize: 16, color: ConstColors.surfaceColor),
                ),
                trailing: Visibility(
                  visible: vehicleState.vehicleType ==
                      transport.keys.elementAt(index),
                  child: const Icon(Icons.done, color: Colors.blueAccent),
                ),
                onTap: () async {
                  int vehicleType = 1;
                  GetVehicleModel? vehicleModel = SqliteManager().getVehicleModel();
                  context.read<VehiclesBloc>().add(OnChangeVehicleEvent(VehicleType.pedestrian));
                  UpdateProfileApi updateProfileApi = UpdateProfileApi(updateProfileModel: UpdateProfileModel(
                    vehicleType: vehicleType
                  ));
                  // await updateProfileApi.call();
                  context.read<MainBloc>().add(MainChangeDarkModeEvent());
                },
              ),
            );
          },
        );
      }),
    ),
);
  }
}
