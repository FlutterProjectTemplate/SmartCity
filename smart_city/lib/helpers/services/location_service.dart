import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/user/user_info.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz1;

import '../../controller/helper/map_helper.dart';
import '../../model/user/user_detail.dart';
import '../../mqtt_manager/MQTT_client_manager.dart';
import '../../mqtt_manager/mqtt_object/location_info.dart';

class LocationService with ChangeNotifier {
  //final _foregroundService = ForegroundService();
  LocationInfo locationInfo = LocationInfo();
  MqttServerClientObject? _mqttServerClientObject;
  String? _currentTimeZone;
  double maxSpeed = 0;
  Position? _previousPosition;

  void setMqttServerClientObject(
      MqttServerClientObject? mqttServerClientObject) {
    _mqttServerClientObject = mqttServerClientObject;
  }

  void setCurrentTimeZone(String? currentTimeZone) {
    _currentTimeZone = currentTimeZone;
  }

  Future<void> startService(BuildContext context) async {
    //_foregroundService.start();
    await _sendMessageMqtt(context);
  }

  Future<void> stopService() async {
    //_foregroundService.stop();
    _timer?.cancel();
  }

 // Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
 // LocationData? _locationData;
/*
  Future<bool> _enableBackgroundMode() async {
    bool _bgModeEnabled = await location.isBackgroundModeEnabled();
    if (_bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        _bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      print(_bgModeEnabled); //True!
      return _bgModeEnabled;
    }
  }

  Future<void> _getLocation() async {
    _locationData = await location.getLocation();
    // String s= 'lat: ${_locationData.latitude} \n long: ${_locationData.longitude} \n speed: ${_locationData.speed?.toStringAsFixed(1)} \n heading: ${_locationData.heading}';
  }*/


  Timer? _timer;

  Future<void> _sendMessageMqtt(BuildContext context) async{
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      // await MapHelper.getInstance().getCurrentLocation;
      UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();

      String time = _getTimeZoneTime();

      if (_mqttServerClientObject == null) {
        await _reconnectMQTT();
      }

      if (_mqttServerClientObject!.mqttServerClient!.connectionStatus!.state != MqttConnectionState.connected) {
        await _reconnectMQTT();
      }

      Position? currentPosition = await MapHelper().getCurrentPosition();
      double speed = 0;

      //await _enableBackgroundMode();
      //await _getLocation();

      locationInfo = LocationInfo(
        name: userDetail?.name ?? "Unknown",
        latitude: currentPosition?.latitude??0,
        longitude: currentPosition?.longitude??0,
        // altitude: position.longitude,
        speed: currentPosition?.speed??0,
        heading: (currentPosition?.heading??0).toInt(),
        // address: address,

        // previousLatitude:  _locationData!.latitude,
        // previousLongitude:  _locationData!.longitude,
        // previousSpeed: _locationData!.speed??0,
        // previousHeading: (_locationData!.heading)?.toInt(),
        createdAt: time,
      );


      if (speed > maxSpeed) maxSpeed = speed;

      _previousPosition = currentPosition;

      await MQTTManager().sendMessageToATopic(
          newMqttServerClientObject: _mqttServerClientObject!,
          message: jsonEncode(locationInfo.toJson()),
          onCallbackInfo: (p0) {
            if (kDebugMode) {
              InstanceManager().showSnackBar(context: context, text: jsonEncode(locationInfo.toJson()),);
            }
          });
    });
  }

  String _getTimeZoneTime() {
    if (_currentTimeZone == 'Asia/Saigon') {
      _currentTimeZone = 'Asia/Ho_Chi_Minh';
    }
    var detroit = tz1.getLocation(_currentTimeZone!);
    String now = tz1.TZDateTime.now(detroit).toString();
    now = now.replaceAll("+", " +");
    now = now.replaceRange(now.length - 2, now.length - 2, ":");
    return now; //"${timeStr} ${timeZone}";
  }

  _reconnectMQTT() async {
    try {
      _mqttServerClientObject =
          await MQTTManager().initialMQTTTrackingTopicByUser(
        onConnected: (p0) async {
          print('connected');
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
