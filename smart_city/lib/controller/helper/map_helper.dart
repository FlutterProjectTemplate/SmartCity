import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart'as permission_handler;
import 'package:polyline_codec/polyline_codec.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_key.dart';

import '../../base/common/responsive_info.dart';
import '../../constant_value/const_size.dart';
import 'package:http/http.dart' as http;


class MapHelper{
  LatLng? _currentLocation;// current user location
  static MapHelper? _instance;
  StreamSubscription<ServiceStatus>? _getServiceSubscription;
  MapHelper._internal();
  static getInstance(){
    _instance ??= MapHelper._internal();
    return _instance;
  }

  static get currentLocation {
    return getInstance()._currentLocation;
  }

  Future<BitmapDescriptor> getPngPictureAssetWithCenterText({
    required String imagePath,
    required String text,
    required double width,
    required double height,
    double fontSize = 30,
    Color? fontColor = ConstColors.onSecondaryContainerColor,
    Color backgroundColor = ConstColors.onPrimaryColor,
    FontWeight fontWeight = FontWeight.w500,
    double degree = 0
  })async{
    ByteData imageFile = await rootBundle.load(imagePath); // load icon tu asset folder

    double radians = degree/180*pi;
    // rotate icon according to degree
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas1 = Canvas(pictureRecorder);
    final Uint8List imageUint8List = imageFile.buffer.asUint8List();
    final ui.Codec codec1 = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec1.getNextFrame();

    final double r = sqrt(imageFI.image.width * imageFI.image.width +
        imageFI.image.height * imageFI.image.height) / 2;
    final alpha = atan(imageFI.image.height / imageFI.image.width);
    final beta = alpha + radians;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = imageFI.image.width / 2 - shiftX;
    final translateY = imageFI.image.height / 2 - shiftY;
    canvas1.translate(translateX, translateY);

    canvas1.rotate(radians);
    canvas1.drawImage(imageFI.image, const Offset(0, 0), Paint());
    final iconImage = await pictureRecorder.endRecording().toImage(imageFI.image.width, imageFI.image.height);

    // tiep theo can dua text vao icon

    ByteData? byteData = await iconImage.toByteData(format: ui.ImageByteFormat.png);

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
          fontSize: fontSize, color: fontColor, fontWeight: fontWeight),
    );


    paintImage(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        canvas: canvas2,
        filterQuality: FilterQuality.high,
        rect: Rect.fromLTWH(width* 0.2, height * 0.4, width*0.6, height*0.6),
        image: imageFIEnd.image);
    painter.layout();
    painter.paint(canvas2,Offset((width * 10) - painter.width * 0.5, (height * 0.4) - painter.height));
    final image = await pictureRecorder2.endRecording().toImage(width.toInt(), (height).toInt());

    // sau khi ve xon text. can chinh lai anchor cho icon, de hien thi tren map cho dung
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.bytes(data!.buffer.asUint8List(),height: height,width: width );
    return bitmapDescriptor;
  }



  Future<bool> getPermission()async {
    await permission_handler.Permission.locationWhenInUse.request();
    if (await permission_handler.Permission.locationWhenInUse.serviceStatus.isEnabled) {
      LocationPermission permission;
      bool serviceEnabled ;

      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } on PlatformException catch (err) {
        debugPrint(err.message);
        serviceEnabled = false;
      }

      if(!serviceEnabled){
        return false;
      }

      permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.denied){
          return false;
        }
      }

      return true;
    } else {
      return false;
    }
  }

  Future<void> listenLocationUpdate()async{
    if(await getPermission()){
      Geolocator.getPositionStream().listen((Position position) {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    }
  }

  Future<void> getCurrentLocation()async{
    if(await getPermission()){
      Position locationData = await Geolocator.getCurrentPosition();
      _currentLocation = LatLng(locationData.latitude, locationData.longitude);
    }
  }

  Future<void> checkLocationService({required Function() whenDisabled, required Function() whenEnabled})async{

    // user disable location service outside of map screen
    if(!await Geolocator.isLocationServiceEnabled()){
      whenDisabled();
    }

    //user disable location service inside of map screen
    _getServiceSubscription=Geolocator.getServiceStatusStream().listen((ServiceStatus status)async{
      if(status == ServiceStatus.disabled){
        whenDisabled();
      }else{
        //when turn on
        await MapHelper.getInstance().getCurrentLocation();
        whenEnabled();
      }
      debugPrint(status.toString());
    });
  }

  void dispose(){
    _getServiceSubscription?.cancel();
  }

  List<LatLng> decodePointsLatLng(String pointsEncode) {
    List<LatLng> points = [];

    List<List<num>> coordinates = PolylineCodec.decode(pointsEncode);
    for (List<num> point in coordinates) {
      points.add(LatLng(point.elementAt(0).toDouble(), point.elementAt(1).toDouble()));
    }
    return points;
  }

  double calculateDistance(LatLng p0, LatLng p1) {
    /// tinh khoang cach giua 2 toa doa tren google map, tinh ra (m)
    var p = 0.017453292519943295;
    var a = 0.5 - cos((p1.latitude - p0.latitude) * p) / 2 + cos(p0.latitude * p) * cos(p1.latitude * p) * (1 - cos((p1.longitude - p0.longitude) * p)) / 2;
    return double.parse((12742 * asin(sqrt(a)) * 1000).toStringAsFixed(1));
  }

  Polyline drawPolyLine({required List<LatLng> polylineCoordinates, String? polylineId, Color? color, int? width}) {
    PolylineId id = PolylineId(polylineId ?? "poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: color ?? (Colors.blue.shade600),
      points: polylineCoordinates,
      width: width ?? 4,
    );
    return polyline;
  }

  Future<Polyline> getPolylines({required LatLng current,required LatLng destination}) async {
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
    Polyline polyline = Polyline(points: coordinates, polylineId: PolylineId('polyline_id'.hashCode.toString()),);
    return polyline;
  }

  Future<Marker> getMarker({
    String? markerId,
    required LatLng latLng,
    String? image,
    Size? size,
    String? name,
    Color? statusColor,
    Function(String markerId)? onTap,
  }) async {
    // if (assetIcon != null) {
    //   if (assetIcon.contains(".svg")) {
    //     customIcon = await getSVGPictureAssetWithCenterText(
    //         assetPath: ImagesNameConst.getSvgImage(assetIcon),
    //         text: "",
    //         size: ui.Size(size != null ? size.width : Dimens.size80, size != null ? size.height : Dimens.size80) * getSizeRatioForMarker(),
    //         backgroundColor: statusColor ?? ColorConst.mainColor,
    //         degree: 0);
    //   } else {
    //     customIcon = await getPngPictureAssetWithCenterText(
    //         assetPath: ImagesNameConst.getPngImage(assetIcon),
    //         text: "",
    //         size: ui.Size(size != null ? size.width : Dimens.size80, size != null ? size.height : Dimens.size80) * getSizeRatioForMarker(),
    //         backgroundColor: statusColor ?? ColorConst.mainColor,
    //         degree: 0);
    //   }
    // } else {
    //   customIcon = await getPngPictureAssetWithCenterText(
    //       assetPath: ImagesNameConst.getPngImage(ImagesNameConst.ic_charge_location_png),
    //       text: "",
    //       size: ui.Size(size != null ? size.width : Dimens.size80, size != null ? size.height : Dimens.size80) * getSizeRatioForMarker(),
    //       backgroundColor: statusColor ?? ColorConst.mainColor,
    //       degree: 0);
    // }
    final Uint8List markerIcon =
    await getBytesFromImage((image ?? "") != '' ? image! : "assets/cycling.png", 120);

    final marker = Marker(
      markerId: MarkerId(markerId ?? latLng.latitude.toString()),
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
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<Uint8List> getBytesFromImage(String imagePath, int width) async {
    final bytes = await rootBundle.load(imagePath);
    final bytesImage = bytes.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytesImage, targetWidth: width);
    final fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}