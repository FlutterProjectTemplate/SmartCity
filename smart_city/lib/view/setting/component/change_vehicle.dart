import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/services/api/get_vehicle/models/get_vehicle_model.dart';

import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../controller/vehicles_bloc/vehicles_bloc.dart';

class ChangeVehicle extends StatefulWidget {
  final VehiclesBloc vehiclesBloc;
  final Function(VehicleTypeInfo?) onChange;

  const ChangeVehicle(
      {super.key, required this.onChange, required this.vehiclesBloc});

  @override
  State<ChangeVehicle> createState() => _ChangeVehicleState();
}

class _ChangeVehicleState extends State<ChangeVehicle> {
  final userDetail = SqliteManager().getCurrentLoginUserDetail();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            L10nX.getStr.vehicle,
            style: ConstFonts().copyWithTitle(
              fontSize: 25,
              color: ConstColors.surfaceColor,
            ),
          ),
          const SizedBox(width: 25),
          const SizedBox(height: 20),

          BlocConsumer<VehiclesBloc, VehiclesState>(
            bloc: widget.vehiclesBloc,
            listener: (context, state) {
              if (state.blocStatus == BlocStatus.success) {
                widget.onChange(state.vehicleType);
              } else if (state.blocStatus == BlocStatus.failed) {
                EasyLoading.showToast('Failed to update vehicle');
              } else {
                EasyLoading.showToast('Failed to update vehicle');
              }
            },
            builder: (context, vehicleState) {
              return FutureBuilder(
                  future: InstanceManager().getVehicleTypeModel(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) {
                      return SizedBox();
                    }
                    VehicleTypeResponseModel? vehicleTypeResponseModel = snapshot.data;
                    return Flexible(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: (vehicleTypeResponseModel?.list??[]).length,
                        separatorBuilder: (ctx, index) => const SizedBox(height: 15),
                        itemBuilder: (context, int index) {
                          VehicleTypeInfo vehicleTypeInfo = (vehicleTypeResponseModel?.list??[]).elementAt(index);
                          final isSelected = vehicleTypeInfo.id == vehicleState.vehicleType?.id;

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: isSelected
                                    ? ConstColors.primaryColor
                                    : ConstColors.surfaceColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Image.network(vehicleTypeInfo.icon??""),
                                ),
                              ),
                              horizontalTitleGap: 15,
                              title: Text(
                                vehicleTypeInfo.text ?? "unknown",
                                style: ConstFonts().copyWithTitle(
                                  fontSize: 16,
                                  color: ConstColors.surfaceColor,
                                ),
                              ),
                              trailing: Visibility(
                                visible: isSelected,
                                child:
                                const Icon(Icons.done, color: Colors.blueAccent),
                              ),
                              onTap: () async {
                                widget.vehiclesBloc.add(OnChangeVehicleEvent(vehicleTypeInfo));
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },);
            },
          ),
        ],
      ),
    );
  }
}
