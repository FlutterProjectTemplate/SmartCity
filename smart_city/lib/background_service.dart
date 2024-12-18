import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city/view/map/command_box.dart';
import 'package:smart_city/view/map/component/event_log.dart';
import 'package:smart_city/view/map/component/polyline_model_info.dart';

import 'base/firebase_manager/notifications/local_notifications.dart';
import 'base/store/cached_storage.dart';
import 'controller/helper/map_helper.dart';
import 'helpers/services/location_service.dart';
import 'model/tracking_event/tracking_event.dart';
import 'model/vector_status/vector_status.dart';
import 'mqtt_manager/MQTT_client_manager.dart';

class ServiceKey {
  static  final updateInfoKeyToBackGround = "updateInfoKeyToBackGround";
  static  final updateInfoKeyToForeGround = "updateInfoKeyToForeGround";

  static  final senMQTTMessageKey = "senMQTTMessageKey";
  static  final stopBackGroundServiceKey = "stopBackGroundKey";
  static  final startInBackGroundKey = "startInBackGroundKey";
  static  final stopInBackGroundKey = "stopInBackGroundKey";

}
Future<void> initializeBackGroundService({bool? autoStart}) async {
  final service = FlutterBackgroundService();
  await LocalNotification().initialLocalNotification();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      // auto start service
      autoStart: autoStart??false,
      isForegroundMode: false,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: LocalNotification.foregroundServiceNotificationId,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: autoStart??false,
      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  if(!(autoStart??false)){
    service.startService();
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  await LocalNotification().initialLocalNotification();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on(ServiceKey.stopBackGroundServiceKey).listen((event) async {
   await stopInBackground(service);
   await service.stopSelf();
  });
  service.on(ServiceKey.updateInfoKeyToBackGround).listen((event) {
    if((event??{}).containsKey("polylineModelInfo") && (event??{})['polylineModelInfo']!=null){
      MapHelper().polylineModelInfo = PolylineModelInfo.fromJson((event??{})['polylineModelInfo']);
    }
  });
  service.on(ServiceKey.stopInBackGroundKey).listen((event) async {
    await stopInBackground(service);
  });
  service.on(ServiceKey.startInBackGroundKey).listen((event) async {
    await startInBackground(service);
  });

}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await LocalNotification().initialLocalNotification();
  service.on(ServiceKey.stopBackGroundServiceKey).listen((event) async {
    await stopInBackground(service);
    await service.stopSelf();
  });
  service.on(ServiceKey.updateInfoKeyToBackGround).listen((event) {
    if((event??{}).containsKey("polylineModelInfo") && (event??{})['polylineModelInfo']!=null){
      MapHelper().polylineModelInfo = PolylineModelInfo.fromJson((event??{})['polylineModelInfo']);
    }
  });
  service.on(ServiceKey.stopInBackGroundKey).listen((event) async {
    await stopInBackground(service);
  });
  service.on(ServiceKey.startInBackGroundKey).listen((event) async {
    await startInBackground(service);
  });
  service.invoke(ServiceKey.startInBackGroundKey);
  return true;
}

Future<void> stopBackgroundService() async {
  FlutterBackgroundService().invoke(ServiceKey.stopBackGroundServiceKey);
}

Future<void> startInBackground(ServiceInstance service) async {

  MapHelper().polylineModelInfo = PolylineModelInfo(points: []);
  await SharedPreferencesStorage().initSharedPreferences();
  MQTTManager().disconnectAndRemoveAllTopic();
  MQTTManager().mqttServerClientObject = await MQTTManager().initialMQTTTrackingTopicByUser(
    onConnected: (p0) async {
      print('connected');
    },
    onRecivedData: (p0) {
      try {
        MapHelper().logEventNormal = TrackingEventInfo.fromJson(jsonDecode(p0));
        if (MapHelper().logEventNormal?.virtualDetectorState ==
            VirtualDetectorState.Service) {
          MapHelper().logEventService = MapHelper().logEventNormal;
        } else {
          MapHelper().logEventService = null;
        }

        service.invoke(
          ServiceKey.updateInfoKeyToForeGround,
          {
            "logEventService": MapHelper().logEventService?.toJson(),
            "logEventNormal": MapHelper().logEventNormal?.toJson(),
          },
        );
        EventLogManager().handlerVoiceCommandEvent(
          trackingEvent: MapHelper().logEventService,
          onChangeIndex: (p0) {},
          onSetState: (p0) {},
        );
      } catch (e) {}
      try {
        MapHelper().vectorStatus = VectorStatusInfo.fromJson(jsonDecode(p0));
      } catch (e) {}
    },
  );
  LocationService().setMqttServerClientObject(MQTTManager().mqttServerClientObject);
  await LocationService().startService(
    isSenData: true,
    onRecivedData: (p0) {},
    onCallbackInfo: (p0) {
      print("backgroundddData:${p0.toString()}");
    },
  );
  Timer.periodic(const Duration(seconds: 2), (timer) async {
    try {
     await MapHelper().getPermission();
     await MapHelper().getMyLocation(
        streamLocation: true,
        onChangePosition: (p0) {
          print("background onChangePosition Data:${p0?.toJson().toString()}");
          MapHelper().polylineModelInfo.points?.add(LatLng(MapHelper().location?.latitude??0, MapHelper().location?.longitude??0));
        },
      );
      print("stream background");
    } catch (e) {
      print("get location error");
    }
  });
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    try {
      await LocalNotification().showLocalNotification();
    } catch (e) {
    }
  });
}
Future<void> stopInBackground(ServiceInstance service) async {
  service.invoke(
    ServiceKey.updateInfoKeyToForeGround,
    {
      "polylineModelInfo":MapHelper().polylineModelInfo.toJson()
    },
  );
  try{
    await LocationService().stopService(isStopFromBackGround: true);

  }
  catch(e){

  }
}
