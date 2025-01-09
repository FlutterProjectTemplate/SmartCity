import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:smart_city/background_service.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:timezone/standalone.dart' as tz1;
import 'package:timezone/data/latest.dart' as tz;

import '../../controller/helper/map_helper.dart';
import '../../model/user/user_detail.dart';
import '../../mqtt_manager/MQTT_client_manager.dart';
import '../../mqtt_manager/mqtt_object/location_info.dart';

class LocationService with ChangeNotifier {
  static final LocationService _singletonLocationService = LocationService._internal();
  static LocationService get getInstance => _singletonLocationService;

  factory LocationService() {
    return _singletonLocationService;
  }

  LocationService._internal();
  String? _currentTimeZone;
  double maxSpeed = 0;
  Position? _previousPosition;

  void setMqttServerClientObject(
      MqttServerClientObject? mqttServerClientObject) {
    MQTTManager().mqttServerClientObject = mqttServerClientObject;
  }

  void setCurrentTimeZone(String? currentTimeZone) {
    _currentTimeZone = currentTimeZone;
  }

  Future<void> startService(
      {
        void Function(dynamic)? onRecivedData,
        Function(LocationInfo)? onCallbackInfo,
        bool? isSenData
      }) async {
    //_foregroundService.start();
    await _sendMessageMqtt(
      onRecivedData: onRecivedData,
        isSenData: isSenData,
      onCallbackInfo: (p0) {
      if(onCallbackInfo!=null)
        {
          onCallbackInfo(p0);
        }
    },);
  }

  Future<void> stopService({bool? isStopFromBackGround}) async {
    //_foregroundService.stop();
    _timer?.cancel();
    MQTTManager().disconnectAndRemoveAllTopic();
    await MapHelper().stopListenLocation();
    if(!(isStopFromBackGround??false)) {
      await stopBackgroundService();
    }
  }

  Timer? _timer;

  Future<void> _sendMessageMqtt(
      {
        void Function(dynamic)? onRecivedData,
        bool? isSenData,
        Function(LocationInfo)? onCallbackInfo}) async {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // await MapHelper.getInstance().getCurrentLocation;
      UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();


      String time = await _getTimeZoneTime();

      if (MQTTManager().mqttServerClientObject == null) {
        await _reconnectMQTT(onRecivedData: onRecivedData);
      }

      if (MQTTManager().mqttServerClientObject?.mqttServerClient?.connectionStatus?.state !=
          MqttConnectionState.connected) {
        await _reconnectMQTT(onRecivedData: onRecivedData);
      }

      Position? currentPosition = await MapHelper().getCurrentPosition();
      LocationInfo locationInfo = LocationInfo(
        name: userDetail?.name ?? "Unknown",
        latitude: currentPosition?.latitude ?? 0,
        longitude: currentPosition?.longitude ?? 0,
        // altitude: position.longitude,
        speed: double.parse((MapHelper().getSpeed()).toStringAsFixed(1)),
        heading: (currentPosition?.heading ?? 0).toInt(),
        vehicleType: userDetail?.vehicleTypeNum,
        createdAt: time,
      );

      if((isSenData??false) || defaultTargetPlatform == TargetPlatform.android)
        {
          await MQTTManager().sendMessageToATopic(
              newMqttServerClientObject: MQTTManager().mqttServerClientObject,
              message: jsonEncode(locationInfo.toJson()),
              onCallbackInfo: (p0) {
                if(onCallbackInfo!=null)
                {
                  onCallbackInfo(locationInfo);
                }
              });
        }

    });
  }

  Future<String> _getTimeZoneTime() async {
    if (_currentTimeZone == 'Asia/Saigon') {
      _currentTimeZone = 'Asia/Ho_Chi_Minh';
    }
    tz1.Location detroit;
    try{
      _currentTimeZone??=await FlutterTimezone.getLocalTimezone();
      detroit = tz1.getLocation(_currentTimeZone!);
    }
    catch(e){
      tz.initializeTimeZones();
      _currentTimeZone??=await FlutterTimezone.getLocalTimezone();
      detroit = tz1.getLocation(_currentTimeZone!);

    }

    String now = tz1.TZDateTime.now(detroit).toString();
    now = now.replaceAll("+", " +");
    now = now.replaceRange(now.length - 2, now.length - 2, ":");
    return now; //"${timeStr} ${timeZone}";
  }

  _reconnectMQTT( {void Function(dynamic)? onRecivedData}) async {
    try {
      MQTTManager().disconnectAndRemoveAllTopic();
      MQTTManager().mqttServerClientObject?.mqttServerClient?.disconnect();
      MQTTManager().mqttServerClientObject = await MQTTManager().initialMQTTTrackingTopicByUser(
        onConnected: (p0) async {
          if (kDebugMode) {
            print('connected');
          }
        },
            onRecivedData: (p0) {
          if(onRecivedData!=null)
            {
              onRecivedData(p0);
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
