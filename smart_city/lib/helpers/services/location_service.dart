import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz1;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../controller/helper/map_helper.dart';
import '../../mqtt_manager/MQTT_client_manager.dart';
import '../../mqtt_manager/mqtt_object/employee_location_info.dart';

class LocationService with ChangeNotifier {
  final _foregroundService = ForegroundService();
  final _geolocator = Geolocator();
  LocationInfo locationInfo = LocationInfo();
  MqttServerClientObject? mqttServerClientObject;
  String? currentTimeZone;

  void setMqttServerClientObject(MqttServerClientObject? mqttServerClientObject) {
    this.mqttServerClientObject = mqttServerClientObject;
  }

  void setCurrentTimeZone(String currentTimeZone) {
    this.currentTimeZone = currentTimeZone;
  }

  Future<void> startService() async {
    _foregroundService.start();
        await Geolocator.checkPermission();
        await Geolocator.requestPermission();
        // await Geolocator.getPositionStream().listen((Position position) {
        //   // Handle location updates here
        //   print('Location: ${position.latitude}, ${position.longitude}');
        // });
        _sendMessageMqtt();
  }

  Future<void> stopService() async {
    _foregroundService.stop();
  }

  void _sendMessageMqtt() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await MapHelper.getInstance().getCurrentLocation;

      String time = await _getTimeZoneTime();

      Position position = MapHelper.currentPosition;
      locationInfo = LocationInfo(
          latitude: position.latitude,
          longitude: position.longitude,
          // altitude: position.longitude,
          speed: (position.speed).toInt(),
          heading: (position.heading).toInt(),
          // address: address,
          createdAt: time);

      await MQTTManager().sendMessageToATopic(
        newMqttServerClientObject: mqttServerClientObject!,
        message: jsonEncode(locationInfo.toJson()),
        onCallbackInfo: (p0) {
          if (kDebugMode) {
            // InstanceManager().showSnackBar(
            //     context: context, text: locationInfo!.toJson().toString());
          }
        },
      );
    });
  }

  Future<String> _getTimeZoneTime() async {
    // final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var detroit = tz1.getLocation(currentTimeZone!);
    String now = tz1.TZDateTime.now(detroit).toString();
    now = now.replaceAll("+", " +");
    now = now.replaceRange(now.length - 2, now.length - 2, ":");
    return now; //"${timeStr} ${timeZone}";
  }
}