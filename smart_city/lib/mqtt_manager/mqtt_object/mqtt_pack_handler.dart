import 'dart:convert';

import '../../base/utlis/file_utlis.dart';
import '../MQTT_client_manager.dart';
import 'employee_location_info.dart';
class MQTTPackInfo{
  MqttPackageType mqttPackageType = MqttPackageType.none;
  dynamic data;
  MQTTPackInfo({required this.mqttPackageType, this.data});
}
class MQTTPackageHandler {
  static final MQTTPackageHandler _singletonMQTTPackageHandler = MQTTPackageHandler._internal();
  static MQTTPackageHandler get getInstance => _singletonMQTTPackageHandler;
  factory MQTTPackageHandler() {
    return _singletonMQTTPackageHandler;
  }
  MQTTPackageHandler._internal();
  
  void decodePackByType(String message, MqttPackageType mqttPackageType, Function(MQTTPackInfo)? onRecievedData){
    switch(mqttPackageType)
        {
      case MqttPackageType.none:
        
         FileUtils.printLog(message);
        break;
      case MqttPackageType.realTime:
        EmployeeLocationInfo mqttRealtimeObject = EmployeeLocationInfo.fromJson(jsonDecode(message));
        MQTTPackInfo mqttPackInfo = MQTTPackInfo(mqttPackageType:mqttPackageType, data:  mqttRealtimeObject );
        if(onRecievedData!=null) {
          onRecievedData(mqttPackInfo);
        }
         FileUtils.printLog(mqttRealtimeObject.toString());
        
        break;
    }
  }

}