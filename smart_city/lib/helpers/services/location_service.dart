import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
//import 'package:location/location.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:timezone/standalone.dart' as tz1;

import '../../controller/helper/map_helper.dart';
import '../../model/user/user_detail.dart';
import '../../mqtt_manager/MQTT_client_manager.dart';
import '../../mqtt_manager/mqtt_object/location_info.dart';

class LocationService with ChangeNotifier {
  //final _foregroundService = ForegroundService();
  static final LocationService _singletonLocationService = LocationService._internal();
  static LocationService get getInstance => _singletonLocationService;

  factory LocationService() {
    return _singletonLocationService;
  }

  LocationService._internal();
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

  Future<void> startService({void Function(dynamic)? onRecivedData, Function(LocationInfo)? onCallbackInfo}) async {
    //_foregroundService.start();
    await _sendMessageMqtt(onRecivedData: onRecivedData, onCallbackInfo: (p0) {
      if(onCallbackInfo!=null)
        {
          onCallbackInfo(p0);
        }
    },);
  }

  Future<void> stopService() async {
    //_foregroundService.stop();
    _timer?.cancel();
  }

  // Location location = new Location();
  //  bool? _serviceEnabled;
  // PermissionStatus? _permissionGranted;
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

  Future<void> _sendMessageMqtt({void Function(dynamic)? onRecivedData, Function(LocationInfo)? onCallbackInfo}) async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      // await MapHelper.getInstance().getCurrentLocation;
      UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();

      String time = _getTimeZoneTime();

      if (_mqttServerClientObject == null) {
        await _reconnectMQTT(onRecivedData: onRecivedData);
      }

      if (_mqttServerClientObject!.mqttServerClient!.connectionStatus!.state !=
          MqttConnectionState.connected) {
        await _reconnectMQTT(onRecivedData: onRecivedData);
      }

      Position? currentPosition = MapHelper().location;
      try{

        Location location = new Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            return;
          }
        }

        location.getLocation().then((value) {
          print(value);
        },);
      }
      catch(e){
        print(e);
      }
      LocationInfo locationInfo = LocationInfo(
        name: userDetail?.name ?? "Unknown",
        latitude: currentPosition?.latitude ?? 0,
        longitude: currentPosition?.longitude ?? 0,
        // altitude: position.longitude,
        speed: double.parse((MapHelper().getSpeed()).toStringAsFixed(1)),
        heading: (currentPosition?.heading ?? 0).toInt(),
        createdAt: time,
      );

      await MQTTManager().sendMessageToATopic(
          newMqttServerClientObject: _mqttServerClientObject!,
          message: jsonEncode(locationInfo.toJson()),
          onCallbackInfo: (p0) {
            if(onCallbackInfo!=null)
            {
              onCallbackInfo(locationInfo);
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

  _reconnectMQTT( {void Function(dynamic)? onRecivedData}) async {
    try {
      _mqttServerClientObject =
          await MQTTManager().initialMQTTTrackingTopicByUser(
        onConnected: (p0) async {
          if (kDebugMode) {
            print('connected');
          }
        },
            onRecivedData: (p0) {
          if(onRecivedData!=null)
            {
              onRecivedData!(p0);
            }
            },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
