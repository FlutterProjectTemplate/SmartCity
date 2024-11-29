import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/services/api/get_vehicle/get_vehicle_model/get_vehicle_model.dart';

import '../../controller/vehicles_bloc/vehicles_bloc.dart';

class InstanceManager {
  static final InstanceManager _singletonBlocManager =
      InstanceManager._internal();

  static InstanceManager get getInstance => _singletonBlocManager;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory InstanceManager() {
    return _singletonBlocManager;
  }

  InstanceManager._internal();

  String phoneNumber = '+1 (408) 916‑8141';
  String email = 'admin@smartcitysignals.com';

  Position? location;
  String _errorLoginMessage = 'Authentication Failure';

  Map<VehicleType, String> getTransport() {
    return {
      // VehicleType.AMB: 'assets/images/car2.png',
      // VehicleType.FTR: 'assets/images/car2.png',
      // VehicleType.MLV: 'assets/images/car2.png',
      // VehicleType.AMC: 'assets/images/car2.png',
      // VehicleType.EVP: 'assets/images/car2.png',
      // VehicleType.TRC: 'assets/images/car2.png',
      // VehicleType.AGV: 'assets/images/car2.png',
      // VehicleType.BUS: 'assets/images/car2.png',
      // VehicleType.OFV: 'assets/images/police_car.png',
      // VehicleType.TRK: 'assets/images/truck.png',
      VehicleType.BIK: 'assets/images/cyclist.png',
      VehicleType.PED: 'assets/images/pedestrian.png',
    };
  }

  String getVehicleString(VehicleType type) {
    switch (type) {
      case VehicleType.BIK:
        return L10nX.getStr.BIK;
      case VehicleType.PED:
        return L10nX.getStr.PED;
      case VehicleType.BUS:
        return L10nX.getStr.BUS;
      case VehicleType.TRK:
        return L10nX.getStr.TRK;
      case VehicleType.AMB:
        return L10nX.getStr.AMB;
      case VehicleType.FTR:
        return L10nX.getStr.FTR;
      case VehicleType.MLV:
        return L10nX.getStr.MLV;
      case VehicleType.AMC:
        return L10nX.getStr.AMC;
      case VehicleType.TRC:
        return L10nX.getStr.TRC;
      case VehicleType.AGV:
        return L10nX.getStr.AGV;
      case VehicleType.OFV:
        return L10nX.getStr.OFV;
      case VehicleType.EVP:
        return L10nX.getStr.EVP;
      default:
        return "";
    }
  }

  VehicleType getVehicleType(int vehicleNum) {
    GetVehicleModel? listVehicleModel = SqliteManager().getVehicleModel();

    if (listVehicleModel != null) {
      for (VehicleModel vehicleModel in listVehicleModel.list!) {
        if (vehicleModel.id == vehicleNum) {
          return VehicleType.values.firstWhere(
                (e) => e.toString().split('.').last.toLowerCase() == vehicleModel.shortName?.toLowerCase(),
            orElse: () => throw Exception('VehicleType not found for shortName: ${vehicleModel.shortName}'),
          );
        }
      }
    }
    throw Exception('Vehicle not found for ID: $vehicleNum');
  }

  int getVehicleTypeNum(VehicleType vehicleType) {
    GetVehicleModel? listVehicleModel = SqliteManager().getVehicleModel();

    if (listVehicleModel != null) {
      for (VehicleModel vehicleModel in listVehicleModel.list!) {
        if (vehicleModel.shortName == vehicleType.toString().split('.').last)  {
          return vehicleModel.id??0;
        }
      }
    }
    return 1;
  }


  String get errorLoginMessage => _errorLoginMessage;

  void setErrorLoginMessage(String message) {
    _errorLoginMessage = message;
  }

  void showSnackBar({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          text,
          style: ConstFonts().copyWithTitle(fontSize: 16),
        ),
        backgroundColor: ConstColors.tertiaryContainerColor,
      ));
  }
}

class TimerManager {
  static final TimerManager _singletonTimerManager = TimerManager._internal();

  static TimerManager get getInstance => _singletonTimerManager;

  factory TimerManager() {
    return _singletonTimerManager;
  }

  TimerManager._internal();

  Timer? timer, timerKeepAliveTracking;
  final String keepAliveTrackingTimerKey = "keepAliveTrackingTimerKey";

  final String trackingTimerKey = "trackingTimerKey";

  Map<String, Timer?> timeMapManager = {};

  void startTimer(
      {required String timerKey,
      Duration? duration,
      void Function(Timer)? callback}) {
    stopTimer(timerKey: timerKey);
    if (timeMapManager[timerKey] == null) {
      timeMapManager[timerKey] = Timer.periodic(
          duration ?? const Duration(seconds: 10), callback ?? (timer) {});
    }
  }

  void stopTimer({required String timerKey}) {
    if (timeMapManager[timerKey] != null) {
      timeMapManager[timerKey]!.cancel();
      timeMapManager[timerKey] = null;
    }
  }
}
