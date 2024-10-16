import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz1;

import '../../controller/helper/map_helper.dart';
import '../../mqtt_manager/MQTT_client_manager.dart';
import '../../mqtt_manager/mqtt_object/employee_location_info.dart';

class LocationService2 with ChangeNotifier {
  LocationInfo locationInfo = LocationInfo();
  MqttServerClientObject? _mqttServerClientObject;
  String? _currentTimeZone;
  Timer? _timer;

  void setMqttServerClientObject(MqttServerClientObject? mqttServerClientObject) {
    _mqttServerClientObject = mqttServerClientObject;
  }

  void setCurrentTimeZone(String? currentTimeZone) {
    _currentTimeZone = currentTimeZone;
  }

  Future<void> startService() async {
    // Start the background service
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,  // The callback for starting the service
        isForegroundMode: true,  // Optional, defines if it should run as a foreground service
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        autoStart: true,
      ),
    );
    service.startService();
  }

  Future<void> stopService() async {
    FlutterBackgroundService().sendData({"action": "stopService"});
    _timer?.cancel();
  }

  // This function will run inside the service
  void onStart(ServiceInstance service) {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!(await service.isRunning())) {
        timer.cancel();
        return;
      }

      // Get the location
      Position position = await MapHelper.getInstance().getCurrentLocation();

      String time = _getTimeZoneTime();

      // Create the LocationInfo object
      LocationInfo locationInfo = LocationInfo(
        latitude: position.latitude,
        longitude: position.longitude,
        speed: (position.speed).toInt(),
        heading: (position.heading).toInt(),
        createdAt: time,
      );

      // Retrieve the MQTT client object
      MqttServerClientObject? mqttClient = await service.getData<MqttServerClientObject?>('mqttClient');

      if (mqttClient.mqttServerClient!.connectionStatus!.state == MqttConnectionState.connected) {
        // Send the message
        MQTTManager().sendMessageToATopic(
          newMqttServerClientObject: mqttClient,
          message: jsonEncode(locationInfo.toJson()),
          onCallbackInfo: (p0) {
            if (kDebugMode) {
              print(locationInfo.toJson());
            }
          },
        );
      } else {
        // Attempt to reconnect
        mqttClient = await MQTTManager().initialMQTTTrackingTopicByUser(onConnected: (p0) {
          print('Reconnected to MQTT');
        });
        service.sendData({"mqttClient": mqttClient});
      }
    });
  }

  String _getTimeZoneTime() {
    if (_currentTimeZone == 'Asia/Saigon') _currentTimeZone='Asia/Ho_Chi_Minh';
    var location = tz1.getLocation(_currentTimeZone);
    String now = tz1.TZDateTime.now(location).toString();
    now = now.replaceAll("+", " +");
    now = now.replaceRange(now.length - 2, now.length - 2, ":");
    return now;
  }
}
