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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city/base/app_settings/app_setting.dart';
import 'package:smart_city/base/firebase_manager/notifications/local_notifications.dart';
import 'package:smart_city/base/store/cached_storage.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_key.dart';
import 'package:smart_city/helpers/services/location_service.dart';
import 'package:smart_city/main.dart';
import 'package:smart_city/model/tracking_event/tracking_event.dart';
import 'package:smart_city/model/vector_status/vector_status.dart';
import 'package:smart_city/mqtt_manager/MQTT_client_manager.dart';
import 'package:smart_city/view/map/component/event_log.dart';
import 'package:smart_city/view/map/component/polyline_model_info.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz1;
import '../../l10n/l10n_extention.dart';
import 'package:hive/hive.dart';

class MapHelper {
  static final MapHelper _singletonMapHelper = MapHelper._internal();

  static MapHelper get getInstance => _singletonMapHelper;

  factory MapHelper() {
    return _singletonMapHelper;
  }

  MapHelper._internal();
  LocationService locationService = LocationService();

  bool isSendMqtt = false;
  bool isRunningBackGround = false;
  Position? location;
  Position? tempPosition;
  PolylineModelInfo polylineModelInfo= PolylineModelInfo();
  double? speed;
  double? heading;
  VectorStatus? vectorStatus;
  TrackingEventInfo? logEventNormal;
  TrackingEventInfo? logEventService;
  bool allowListening = false;
  Timer? timer1;
  StreamSubscription? getPositionSubscription;
  StreamSubscription<ServiceStatus>? _getServiceSubscription;
  Timer? timerLimitOnChangeLocation;
  static int foregroundServiceNotificationId= 888;
  Marker? myLocationMarker;
  GoogleMapController? controller;
  bool isOPenPopupRequest= false;

  Future<Position?> getCurrentPosition() async {
    if (location == null) {
      await getCurrentLocationData();
    }
    return location;
  }
  void setCurrentPosition({Position? locationInput}) async {
    location = locationInput;
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
    print("call listenLocation");
    timerLimitOnChangeLocation?.cancel();
    timerLimitOnChangeLocation= null;
    timerLimitOnChangeLocation ??= Timer.periodic(
      intervalDuration ?? Duration(seconds: 30),
          (timer) async {
        if(Platform.isIOS)
          {
            location = await Geolocator.getCurrentPosition();
          }
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
              "SmartCity will continue to receive your location even when you aren't using it",
              notificationTitle: "SmartCity in Background",
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
    getPositionSubscription?.cancel();
    print("begin stream");
    getPositionSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
              if(!MapHelper().isSendMqtt)
               {
                 print("not stream location:${location.toString()}");
                 timerLimitOnChangeLocation?.cancel();
                 return;
               }
              updateCurrentLocation(position!);
              print("stream location:${location.toString()}");
              if (tempPosition == null) {
                tempPosition = location;
              } else if ((tempPosition!.timestamp.difference(position.timestamp).inMilliseconds).abs() >= 2000) {
                calculateSpeed(
                    calculateDistance(
                        LatLng(tempPosition!.latitude, tempPosition!.longitude),
                        LatLng(position.latitude, position.longitude)),
                    tempPosition!.timestamp,
                    position.timestamp);
                tempPosition = position;
              }

        });
  }

  Future<void> stopListenLocation() async {
    getPositionSubscription?.cancel();
    getPositionSubscription = null;
    timerLimitOnChangeLocation?.cancel();
    timerLimitOnChangeLocation= null;
  }

  Future<void> getCurrentLocationData() async {
    await getPermission();
    Position locationData = await Geolocator.getCurrentPosition();
    heading = locationData.heading;
    if (kDebugMode) {
      print("get location:${locationData.toString()}");
    }
    updateCurrentLocation(locationData);
  }

  void updateCurrentLocation(Position newLocation) {
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
    getPositionSubscription?.cancel();
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
      speed = double.parse((distance /time * 1000).toStringAsFixed(1));
      switch (AppSetting.getSpeedUnit) {
        case 'km/h':
          speed = speed??0 * 3.6;
          break;
        case 'mph':
          speed = speed??0 * 3.6 * 0.621371;
        default:
          speed = speed;
      }
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
      anchor: Offset(0.5,0.5),
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
    print('call getMyLocation');
    try{
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        var permissions  = await Geolocator.requestPermission();
        if (permissions == LocationPermission.denied ||
            permissions == LocationPermission.deniedForever ||
            permissions == LocationPermission.unableToDetermine) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          print('Location permissions are denied');
         await openAppSetting();
          return getDefaultLocationFromStore();
        }
      }
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        print('Location services are disabled.');
        await openAppSetting();
        return getDefaultLocationFromStore();
      }
      location = await Geolocator.getCurrentPosition();
    if (onChangePosition != null) {
      onChangePosition(location);
    }
    heading = location?.heading;
    if (location != null) {
      updateCurrentLocation(location!);
    }
    if (streamLocation ?? false) {
      await listenLocation(
          onChangePosition: (p0) {
            location = p0;
            if (onChangePosition != null) {
              onChangePosition(p0);
            }
          },
          intervalDuration: intervalDuration);
    }
    return location;
    }
    catch(e){
      print("Error when get location");
      getDefaultLocationFromStore();
    }
  }

  Position getDefaultLocationFromStore() {

    final LatLng latLngHanoi = const LatLng(21.035140,105.818714);

    Position hanoiPostion= Position(
        longitude: latLngHanoi.longitude,
        latitude: latLngHanoi.latitude,
        timestamp: DateTime.now(),
        accuracy:0 ,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0);
    return hanoiPostion;
  }
  Future<void> openAppSetting() async {
    print("call openAppSetting");
    if(isOPenPopupRequest)
    {
      isOPenPopupRequest= true;
      await Geolocator.openLocationSettings();
      isOPenPopupRequest= false;

    }
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


  PolylineModelInfo getPolylineModelInfoFromStorage(){
    PolylineModelInfo polylineModelInfo = PolylineModelInfo();
    final box = Hive.box();
    String? data = box.get(Storage.savePositionsKey);
    if((data??"").isNotEmpty)
    {
      polylineModelInfo = PolylineModelInfo.fromJson(jsonDecode(data!));
    }

    return polylineModelInfo;
  }

  Future<void> savePolylineModelInfoFromStorage(PolylineModelInfo polylineModelInfo) async {
    String data = jsonEncode(polylineModelInfo.toJson());
    if(data.isNotEmpty)
    {
      final box = Hive.box();
      box.put(Storage.savePositionsKey, data);
    }
  }
  Future<void> removePolylineModelInfoFromStorage() async {
      final box = Hive.box();
      box.delete(Storage.savePositionsKey);
  }

  Future<void> requestNotificationPermissions() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
    }
  }
}


