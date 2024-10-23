import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/l10n/l10n_extention.dart';

import '../../../base/common/responsive_info.dart';
import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../controller/vehicles_bloc/vehicles_bloc.dart';
import '../../../helpers/localizations/language_helper.dart';
import 'country_flag.dart';

class ChangeVehicle extends StatefulWidget {
  const ChangeVehicle({super.key});

  @override
  State<ChangeVehicle> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeVehicle> {
  Map<VehicleType, String> transport = InstanceManager().getTransport();
  Map<VehicleType, String> transportString = {
    VehicleType.truck: L10nX.getStr.truck,
    VehicleType.cyclists: L10nX.getStr.cyclists,
    VehicleType.pedestrians: L10nX.getStr.pedestrians,
    VehicleType.car: L10nX.getStr.car,
    VehicleType.official: L10nX.getStr.official
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehiclesBloc(),
      child: Scaffold(
        // backgroundColor: ConstColors.surfaceColor,
        appBar: AppBar(
          // backgroundColor: ConstColors.surfaceColor,
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
            icon: const Icon(
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
                        Border.all(width: 1, color: ConstColors.surfaceColor),
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Image.asset(transport.values.elementAt(index))),
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
                    switch (transport.keys.elementAt(index)) {
                      case VehicleType.pedestrians:
                        context.read<VehiclesBloc>().add(PedestriansEvent());
                        break;
                      case VehicleType.cyclists:
                        context.read<VehiclesBloc>().add(CyclistsEvent());
                        break;
                      case VehicleType.cityVehicle:
                      case VehicleType.truck:
                        context.read<VehiclesBloc>().add(TruckEvent());
                        break;
                      case VehicleType.car:
                        context.read<VehiclesBloc>().add(CarEvent());
                        break;
                      case VehicleType.official:
                        context.read<VehiclesBloc>().add(OfficialEvent());
                        break;
                    }
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
