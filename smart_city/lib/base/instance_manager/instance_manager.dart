import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/l10n/l10n_extention.dart';

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

  Position? location;
  String _errorLoginMessage = 'Authentication Failure';

  Map<VehicleType, String> getTransport() {
    return (ResponsiveInfo.isTablet())
        ? {
      VehicleType.car: 'assets/images/car2.png',
      VehicleType.officialVehicle: 'assets/images/police_car.png',
      VehicleType.truck: 'assets/images/truck.png',
    }
        : {
      VehicleType.bicycle: 'assets/images/cyclist.png',
      VehicleType.pedestrian: 'assets/images/pedestrian.png',
    };
  }

  String getVehicleString(VehicleType type) {
    switch (type) {
      case VehicleType.truck:
        return L10nX.getStr.truck;
      case VehicleType.pedestrian:
        return L10nX.getStr.pedestrians;
      case VehicleType.bicycle:
        return L10nX.getStr.cyclists;
      case VehicleType.car:
        return L10nX.getStr.car;
      case VehicleType.officialVehicle:
        return L10nX.getStr.official;
      default: return "";
    }
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
