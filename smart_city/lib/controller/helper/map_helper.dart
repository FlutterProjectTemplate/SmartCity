import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as geocodingLib;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as locationLib;
import 'package:polyline_codec/polyline_codec.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smart_city/base/store/cached_storage.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_key.dart';
import 'package:smart_city/helpers/services/location_service.dart';
import 'package:smart_city/model/tracking_event/tracking_event.dart';
import 'package:smart_city/mqtt_manager/MQTT_client_manager.dart';
import 'package:smart_city/view/map/component/polyline_model_info.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz1;
import '../../l10n/l10n_extention.dart';

class MapHelper {
  static final MapHelper _singletonMapHelper = MapHelper._internal();

  static MapHelper get getInstance => _singletonMapHelper;

  factory MapHelper() {
    return _singletonMapHelper;
  }

  MapHelper._internal();

  bool isSendMqtt = false;
  bool isRunningBackGround = false;
  LatLng? currentLocation;
  LatLng?initLocation;
  Position? location;

  PolylineModelInfo polylineModelInfo= PolylineModelInfo();
  double? speed;
  double? heading;
  TrackingEventInfo? trackingEvent;
  Timer? timer1;
  StreamSubscription? getPositionSubscription;
  StreamSubscription<ServiceStatus>? _getServiceSubscription;
  Timer? timerLimitOnChangeLocation;
  List<Marker> myLocationMarker = [];
  GoogleMapController? controller;
  Future<LatLng?> getCurrentLocation() async {
    if (currentLocation == null) {
      await getCurrentLocationData();
    }
    return currentLocation!;
  }

  Future<Position?> getCurrentPosition() async {
    if (location == null) {
      await getCurrentLocationData();
    }
    return location;
  }

  double getSpeed() {
    return speed ?? 0;
  }

  double getHeading() {
    return heading ?? 0;
  }

  Future<BitmapDescriptor> getPngPictureAssetWithCenterText(
      {required String imagePath,
        required String text,
        required double width,
        required double height,
        double fontSize = 30,
        Color? fontColor,
        Color? backgroundColor,
        FontWeight fontWeight = FontWeight.w500,
        double degree = 0}) async {
    ByteData imageFile = await rootBundle.load(imagePath);
    fontColor = fontColor ?? ConstColors.onSecondaryContainerColor;
    backgroundColor = backgroundColor ?? ConstColors.onPrimaryColor;
    double radians = degree / 180 * pi;
    // rotate icon according to degree
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas1 = Canvas(pictureRecorder);
    final Uint8List imageUint8List = imageFile.buffer.asUint8List();
    final ui.Codec codec1 = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec1.getNextFrame();

    final double r = sqrt(imageFI.image.width * imageFI.image.width +
        imageFI.image.height * imageFI.image.height) /
        2;
    final alpha = atan(imageFI.image.height / imageFI.image.width);
    final beta = alpha + radians;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = imageFI.image.width / 2 - shiftX;
    final translateY = imageFI.image.height / 2 - shiftY;
    canvas1.translate(translateX, translateY);

    canvas1.rotate(radians);
    canvas1.drawImage(imageFI.image, const Offset(0, 0), Paint());
    final iconImage = await pictureRecorder
        .endRecording()
        .toImage(imageFI.image.width, imageFI.image.height);

    // tiep theo can dua text vao icon

    ByteData? byteData =
    await iconImage.toByteData(format: ui.ImageByteFormat.png);

    Uint8List iconRotatedByte = byteData!.buffer.asUint8List();

    final ui.PictureRecorder pictureRecorder2 = ui.PictureRecorder();

    final ui.Codec codec2 = await ui.instantiateImageCodec(iconRotatedByte);

    final Canvas canvas2 = Canvas(pictureRecorder2);

    final ui.FrameInfo imageFIEnd = await codec2.getNextFrame();
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
          backgroundColor: backgroundColor.withOpacity(0.6),
          fontSize: fontSize,
          color: fontColor,
          fontWeight: fontWeight),
    );

    paintImage(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        canvas: canvas2,
        filterQuality: FilterQuality.high,
        rect:
        Rect.fromLTWH(width * 0.2, height * 0.4, width * 0.6, height * 0.6),
        image: imageFIEnd.image);
    painter.layout();
    painter.paint(
        canvas2,
        Offset((width * 10) - painter.width * 0.5,
            (height * 0.4) - painter.height));
    final image = await pictureRecorder2
        .endRecording()
        .toImage(width.toInt(), (height).toInt());

    // sau khi ve xon text. can chinh lai anchor cho icon, de hien thi tren map cho dung
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.bytes(
        data!.buffer.asUint8List(),
        height: height,
        width: width);
    return bitmapDescriptor;
  }

  Future<bool> getPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationLib.Location().requestService();
      if (!serviceEnabled) {
        SystemNavigator.pop();
        return Future.error('Location services are disabled.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SystemNavigator.pop();
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      SystemNavigator.pop();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  Future<void> listenLocation({Function(Position?)? onChangePosition,
    int? timeLimit,
    Duration? intervalDuration}) async {
    timerLimitOnChangeLocation ??= Timer.periodic(
      intervalDuration ?? Duration(seconds: 30),
          (timer) {
        if (onChangePosition != null) {
          onChangePosition(location);
        }
      },
    );
    LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
          forceLocationManager: false,
          intervalDuration: intervalDuration ?? const Duration(seconds: 30),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationText:
              "SmartHR will continue to receive your location even when you aren't using it",
              notificationTitle: "Running in Background",
              notificationChannelName: "my_foreground",
              enableWakeLock: true,
              enableWifiLock: true,
              setOngoing: true
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          activityType: ActivityType.fitness,
          distanceFilter: 0,
          pauseLocationUpdatesAutomatically: false,
          // Only set to true if our app will be started up in the background.
          showBackgroundLocationIndicator: true,
          allowBackgroundLocationUpdates: true);
    } else if (kIsWeb) {
      locationSettings = WebSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
        maximumAge: Duration(minutes: 5),
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      );
    }
    getPositionSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
              if(MapHelper().isRunningBackGround || !MapHelper().isSendMqtt)
               {
                 timerLimitOnChangeLocation?.cancel();
                 return;
               }
          calculateSpeed(
              calculateDistance(LatLng(location!.latitude, location!.longitude),
                  LatLng(position!.latitude, position.longitude)),
              location!.timestamp,
              position.timestamp);
          updateCurrentLocation(position);
          if (kDebugMode) {
            print("stream location:${location.toString()}");
          }
        });
  }

  Future<void> getCurrentLocationData() async {
    await getPermission();
    Position locationData = await Geolocator.getCurrentPosition();
    currentLocation =
        LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
    if(MapHelper().initLocation==null)
      {
        MapHelper().initLocation = LatLng(locationData.latitude??0, locationData.longitude??0);
      }
    heading = locationData.heading;
    if (kDebugMode) {
      print("get location:${currentLocation.toString()}");
    }
    updateCurrentLocation(locationData);
  }

  void updateCurrentLocation(Position newLocation) {
    currentLocation =
        LatLng(newLocation.latitude ?? 0, newLocation.longitude ?? 0);
    location = newLocation;
    heading = location?.heading;
  }

  Future<void> checkLocationService({required Function() whenDisabled,
    required Function() whenEnabled}) async {
    // user disable location service outside of map screen
    if (!await Geolocator.isLocationServiceEnabled()) {
      whenDisabled();
    }

    // user disable location service inside of map screen
    _getServiceSubscription = Geolocator.getServiceStatusStream()
        .listen((ServiceStatus status) async {
      if (status == ServiceStatus.disabled) {
        whenDisabled();
      } else {
        //when turn on
        await MapHelper().getCurrentLocationData();
        whenEnabled();
      }
      debugPrint(status.toString());
    });
  }

  void dispose() {
    timerLimitOnChangeLocation?.cancel();
    _getServiceSubscription?.cancel();
  }

  List<LatLng> decodePointsLatLng(String pointsEncode) {
    List<LatLng> points = [];

    List<List<num>> coordinates = PolylineCodec.decode(pointsEncode);
    for (List<num> point in coordinates) {
      points.add(
          LatLng(point.elementAt(0).toDouble(), point.elementAt(1).toDouble()));
    }
    return points;
  }

  double calculateDistance(LatLng p0, LatLng p1) {
    /// tinh khoang cach giua 2 toa doa tren google map, tinh ra (m)
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((p1.latitude - p0.latitude) * p) / 2 +
        cos(p0.latitude * p) *
            cos(p1.latitude * p) *
            (1 - cos((p1.longitude - p0.longitude) * p)) /
            2;
    return double.parse((12742 * asin(sqrt(a)) * 1000).toStringAsFixed(1));
  }

  void calculateSpeed(double distance, DateTime timeStart, DateTime timeEnd) {
    /// km/h
    Duration duration = timeEnd.difference(timeStart);
    int time = (duration.inMilliseconds).abs();
    if (time != 0) {
      speed = double.parse((distance / time * 1000 * 3.6).toStringAsFixed(1));
    }
  }

  Polyline drawPolyLine({required List<LatLng> polylineCoordinates,
    String? polylineId,
    Color? color,
    int? width}) {
    PolylineId id = PolylineId(polylineId ?? "poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: color ?? (Colors.blue.shade600),
      points: polylineCoordinates,
      width: width ?? 4,
    );
    return polyline;
  }

  Future<Polyline> getPolylines(
      {required LatLng current, required LatLng destination}) async {
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      googleApiKey: googleMapApi.key,
      request: PolylineRequest(
        origin: PointLatLng(current.latitude, current.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );
    String? polylineString = result.overviewPolyline;
    List<LatLng> coordinates = decodePointsLatLng(polylineString!);
    Polyline polyline = Polyline(
      points: coordinates,
      polylineId: PolylineId('polyline_id'.hashCode.toString()),
    );
    return polyline;
  }

  Future<Marker> getMarker({
    String? markerId,
    required LatLng latLng,
    double? rotation,
    String? image,
    int? size,
    String? name,
    Color? statusColor,
    Function(String markerId)? onTap,
  }) async {
    final Uint8List markerIcon = await getBytesFromImage(
        (image ?? "") != '' ? image! : "assets/images/cyclist.png",
        (image == "assets/images/pedestrian.png") ? 120 : (image ==
            "assets/images/car2.png") ? 160 : 60);

    final marker = Marker(
      markerId: MarkerId(markerId ?? latLng.latitude.toString()),
      rotation: rotation ?? 0,
      position: latLng,
      icon: BitmapDescriptor.fromBytes(markerIcon),
      infoWindow: InfoWindow(title: name ?? ''),
      onTap: () {
        if (onTap != null && markerId != null) {
          onTap(markerId);
        }
      },
    );
    return marker;
  }

  Future<Uint8List> getBytesFromUrl(String url, int width) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromImage(String imagePath, int width) async {
    try {
      // Load the image bytes from the asset bundle
      final ByteData bytes = await rootBundle.load(imagePath);
      final Uint8List bytesImage = bytes.buffer.asUint8List();

      // Instantiate the image codec with the target width
      final ui.Codec codec = await ui.instantiateImageCodec(
        bytesImage,
        targetWidth: width,
      );

      // Get the first frame from the codec
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      // Convert the frame to ByteData with the desired format (PNG)
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception("Failed to convert image to ByteData");
      }

      // Convert ByteData to Uint8List and return
      return byteData.buffer.asUint8List();
    } catch (e) {
      // Handle errors (e.g., missing image, codec failure)
      print("Error converting image: $e");
      rethrow;
    }
  }




  Future<Position?> getMyLocation({bool? streamLocation,
    Function(Position?)? onChangePosition,
    Duration? intervalDuration}) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    location = await Geolocator.getCurrentPosition();
    if(MapHelper().initLocation==null)
      {
        MapHelper().initLocation = LatLng(location?.latitude??0, location?.longitude??0);
      }
    if (onChangePosition != null) {
      onChangePosition(location);
      if((MapHelper().polylineModelInfo.points??[]).isEmpty)
      {
        MapHelper().polylineModelInfo = MapHelper().getPolylineModelInfoFromStorage();
      }
      (MapHelper().polylineModelInfo.points??[]).add(LatLng(location?.latitude??0, location?.longitude??0));
      MapHelper().savePolylineModelInfoFromStorage(MapHelper().polylineModelInfo);
    }
    heading = location?.heading;
    if (location != null) updateCurrentLocation(location!);
    if (streamLocation ?? false) {
      await listenLocation(
          onChangePosition: (p0) {
            if (onChangePosition != null) {
              onChangePosition(p0);
              if(MapHelper().initLocation==null)
              {
                MapHelper().initLocation = LatLng(location?.latitude??0, location?.longitude??0);
              }
              if((MapHelper().polylineModelInfo.points??[]).isEmpty)
                {
                  MapHelper().polylineModelInfo = MapHelper().getPolylineModelInfoFromStorage();
                }
              (MapHelper().polylineModelInfo.points??[]).add(LatLng(location?.latitude??0, location?.longitude??0));
            }
          },
          intervalDuration: intervalDuration);
    }
    return location;
  }

  Future<String> getAddressByLocation(LatLng latLng) async {
    try {
      List<geocodingLib.Placemark> placemarks = await geocodingLib
          .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        String address =
            "${(placemarks.first.subLocality != null &&
            placemarks.first.subLocality!.isNotEmpty) ? "${placemarks.first
            .subLocality!}, " : ""}"
            "${(placemarks.first.locality != null &&
            placemarks.first.locality!.isNotEmpty) ? '${placemarks.first
            .locality!}, ' : ''}"
            "${(placemarks.first.subAdministrativeArea != null &&
            placemarks.first.subAdministrativeArea!.isNotEmpty) ? '${placemarks
            .first.subAdministrativeArea!}, ' : ''}"
            "${(placemarks.first.administrativeArea != null &&
            placemarks.first.administrativeArea!.isNotEmpty) ? '${placemarks
            .first.administrativeArea!}, ' : ''}"
            "${(placemarks.first.country != null &&
            placemarks.first.country!.isNotEmpty)
            ? placemarks.first.country!
            : ''}";
        return address;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    /// OPTIONAL, using custom notification channel id

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStartAndroid,
        // auto start service
        autoStart: false,
        isForegroundMode: false,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.location, AndroidForegroundType.remoteMessaging],
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: false,
        // this will be executed when app is in foreground in separated isolate
        onForeground: onStartForceGroundIOS,

        // you have to enable background fetch capability on xcode project
        onBackground: onStartIosBackground,
      ),
    );
    await service.startService();
    service.invoke("setAsBackground");

  }

  static void stopBackgroundService() {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
  }
// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch


  @pragma('vm:entry-point')
  static void onStartAndroid(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();
    tz.initializeTimeZones();
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
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    LocationService locationService = LocationService();
    await SharedPreferencesStorage().initSharedPreferences();
    MQTTManager.mqttServerClientObject = await MQTTManager().initialMQTTTrackingTopicByUser(
      onConnected: (p0) async {
        print('connected');
      },
      onRecivedData: (p0) {},
    );
    locationService.setMqttServerClientObject(MQTTManager.mqttServerClientObject);
    await locationService.startService(
      isSenData: true,
      onRecivedData: (p0) {
        print("object");
        try {
          if (MapHelper().timer1 != null) {
            MapHelper().timer1?.cancel();
          }
          MapHelper().trackingEvent = TrackingEventInfo.fromJson(jsonDecode(p0));
          MapHelper().timer1 = Timer(
              Duration(seconds: 20),
                  () {
                MapHelper().timer1?.cancel();
              }
          );
        } catch (e) {}
      },
      onCallbackInfo: (p0) {
        print( "backgroundddData:${p0.toString()}");
      },
    );
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      MapHelper().getPermission();
      MapHelper().getMyLocation(
        streamLocation: false,
        onChangePosition: (p0) {
          print( "background onChangePosition Data:${p0?.toJson().toString()}");
        },);
    });

    // bring to foreground}
  }

  @pragma('vm:entry-point')
  static void onStartForceGroundIOS(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();
    tz.initializeTimeZones();
    // For flutter prior to version 3.0.0
    // We have to register the plugin manually
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    LocationService locationService = LocationService();
    await SharedPreferencesStorage().initSharedPreferences();
    MQTTManager.mqttServerClientObject = await MQTTManager().initialMQTTTrackingTopicByUser(
      onConnected: (p0) async {
        print('connected');
      },
      onRecivedData: (p0) {},
    );
    locationService.setMqttServerClientObject(MQTTManager.mqttServerClientObject);
    await locationService.startService(
      isSenData: true,
      onRecivedData: (p0) {
        print("object");
        try {
          if (MapHelper().timer1 != null) {
            MapHelper().timer1?.cancel();
          }
          MapHelper().trackingEvent = TrackingEventInfo.fromJson(jsonDecode(p0));
          MapHelper().timer1 = Timer(
              Duration(seconds: 20),
                  () {
                MapHelper().timer1?.cancel();
              }
          );
        } catch (e) {}
      },
      onCallbackInfo: (p0) {
        print( "backgroundddData:${p0.toString()}");
      },
    );
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      MapHelper().getPermission();
      MapHelper().getMyLocation(
        streamLocation: false,
        onChangePosition: (p0) {
          print( "background onChangePosition Data:${p0?.toJson().toString()}");
        },);
    });
  }
  @pragma('vm:entry-point')
  static Future<bool> onStartIosBackground(ServiceInstance service) async {
    print('Start background service');
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    LocationService locationService = LocationService();
    await SharedPreferencesStorage().initSharedPreferences();
    MQTTManager.mqttServerClientObject = await MQTTManager().initialMQTTTrackingTopicByUser(
      onConnected: (p0) async {
        print('connected');
      },
      onRecivedData: (p0) {},
    );
    locationService.setMqttServerClientObject(MQTTManager.mqttServerClientObject);
    await locationService.startService(
      isSenData: true,
      onRecivedData: (p0) {
        print("object");
        try {
          if (MapHelper().timer1 != null) {
            MapHelper().timer1?.cancel();
          }
          MapHelper().trackingEvent = TrackingEventInfo.fromJson(jsonDecode(p0));
          MapHelper().timer1 = Timer(
              Duration(seconds: 20),
                  () {
                MapHelper().timer1?.cancel();
              }
          );
        } catch (e) {}
      },
      onCallbackInfo: (p0) {
        print( "backgroundddData:${p0.toString()}");
      },
    );
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      MapHelper().getPermission();
      MapHelper().getMyLocation(
        streamLocation: false,
        onChangePosition: (p0) {
          print( "background onChangePosition Data:${p0?.toJson().toString()}");
        },);
    });
    return true;
  }

  PolylineModelInfo getPolylineModelInfoFromStorage(){
    PolylineModelInfo polylineModelInfo = PolylineModelInfo();
    String data = SharedPreferencesStorage().getString(Storage.savePositionsKey,);
    if(data.isNotEmpty)
    {
      polylineModelInfo = PolylineModelInfo.fromJson(jsonDecode(data));
    }
    return polylineModelInfo;
  }

  Future<void> savePolylineModelInfoFromStorage(PolylineModelInfo polylineModelInfo) async {
    String data = jsonEncode(polylineModelInfo.toJson());
    if(data.isNotEmpty)
    {
      await SharedPreferencesStorage().saveString(Storage.savePositionsKey,data);
    }
  }
}
