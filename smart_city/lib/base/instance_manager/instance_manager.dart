import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/services/api/get_customer/get_customer_api.dart';
import 'package:smart_city/services/api/get_customer/models/get_customer_model.dart';
import 'package:smart_city/services/api/get_vehicle/get_vehicle_type_api.dart';
import 'package:smart_city/services/api/get_vehicle/models/get_vehicle_model.dart';
import 'package:smart_city/services/api/update_profile/update_profile_api.dart';

import '../sqlite_manager/sqlite_manager.dart';


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

  GetCustomerModel customerModel = GetCustomerModel();
  VehicleTypeResponseModel? _vehicleTypeResponseModel;
  String getVehicleString(VehicleTypeInfo type) {
    return type.text??"";
  }

  Future<VehicleTypeResponseModel?> getVehicleTypeModel() async {
    if(_vehicleTypeResponseModel==null)
      {
        GetVehicleTypeApi getVehicleApi = GetVehicleTypeApi();
        _vehicleTypeResponseModel = await getVehicleApi.call();
      }
    return _vehicleTypeResponseModel;
  }

  Future<VehicleTypeInfo?> getVehicleTypeInfoById(int vehicleNum) async {
    _vehicleTypeResponseModel = await getVehicleTypeModel();
    List<VehicleTypeInfo> vehicleTypeInfoList = [...(_vehicleTypeResponseModel?.list??[]).where((element) => element.id == vehicleNum,)];
    if(vehicleTypeInfoList.isNotEmpty) {
      return vehicleTypeInfoList.first;
    } else if((_vehicleTypeResponseModel?.list??[]).isNotEmpty){
      UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
      userDetail?.vehicleTypeNum =(_vehicleTypeResponseModel?.list??[]).first.id;
      final updateProfileApi = UpdateProfileApi(
        updateProfileModel: userDetail!,
      );
      updateProfileApi.call();
      return (_vehicleTypeResponseModel?.list??[]).first;
    }
    else
      {
        return null;
      }
  }



  String get errorLoginMessage => _errorLoginMessage;

  void setErrorLoginMessage(String message) {
    _errorLoginMessage = message;
  }

  void showSnackBar({required BuildContext context, required String text, Duration? duration}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: duration??Duration(seconds: 3),
        content: Text(
          text,
          style: ConstFonts().copyWithTitle(fontSize: 16),
        ),
        backgroundColor: ConstColors.tertiaryContainerColor,
      ));
  }
  Future<GetCustomerModel> getGetCustomer()async{
    if((customerModel.list??[]).isNotEmpty) {
      return customerModel;
    } else{
      GetAllCustomerApi getCustomerApi = GetAllCustomerApi();
      customerModel = await getCustomerApi.call();
      return customerModel;
    }
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
