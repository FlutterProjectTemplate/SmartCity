import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart' as geocodingLib;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:polyline_codec/polyline_codec.dart';

import '../base/common/responsive_info.dart';
import 'lat_lng_point.dart';

class MapHelper {
  static MapHelper? _instance = MapHelper();

  static MapHelper getInstance() {
    _instance ??= MapHelper();
    return _instance!;
  }

  Future<BitmapDescriptor> getPngPictureAssetWithCenterText(
      {required String assetPath, required String text, required Size size, double fontSize = 30, Color? fontColor, Color? backgroundColor, FontWeight? fontWeight, double degree = 0}) async {
    // fontWeight ??= fontWeight500;
    // fontColor ??= ColorConst.whiteColor;
    // backgroundColor ??= ColorConst.backGroundColor;
    ByteData imageFile = await rootBundle.load(assetPath); // load icon tu asset folder

    double radians = degree / 180 * pi;
    // truoc tien can rotate icon xoay theo degree input
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas1 = Canvas(pictureRecorder);
    final Uint8List imageUint8List = imageFile.buffer.asUint8List();
    final ui.Codec codec1 = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec1.getNextFrame();

    final double r = sqrt(imageFI.image.width * imageFI.image.width + imageFI.image.height * imageFI.image.height) / 2;
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
      style: baseStyle.copyWithCustom(backgroundColor: backgroundColor.withOpacity(0.6), fontSize: fontSize, color: fontColor, fontWeight: fontWeight),
    );

    paintImage(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        canvas: canvas2,
        filterQuality: FilterQuality.high,
        rect: Rect.fromLTWH(size.width * 0.2, size.height * 0.4, size.width.toDouble() * 0.6, size.height.toDouble() * 0.6),
        image: imageFIEnd.image);
    painter.layout();
    painter.paint(canvas2, Offset((size.width * Dimens.size0_5) - painter.width * 0.5, (size.height * 0.4) - painter.height));
    final image = await pictureRecorder2.endRecording().toImage(size.width.toInt(), (size.height).toInt());

    // sau khi ve xon text. can chinh lai anchor cho icon, de hien thi tren map cho dung
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.bytes(data!.buffer.asUint8List(), width: size.width, height: size.height);
    return bitmapDescriptor;
  }

  Future<BitmapDescriptor> getSVGPictureAssetWithCenterText(
      {required String assetPath, required String text, required Size size, double fontSize = 30, Color? fontColor, Color? backgroundColor, FontWeight? fontWeight, double degree = 0}) async {
    fontWeight ??= fontWeight500;
    fontColor ??= ColorConst.whiteColor;
    // Read SVG file as String
    backgroundColor ??= ColorConst.backGroundColor;
    PictureInfo pictureInfo = await vg.loadPicture(
        SvgAssetLoader(
          assetPath,
          theme: const SvgTheme(currentColor: Colors.red),
          colorMapper: MyColorMapper(
            baseColor: backgroundColor,
          ),
        ),
        InstanceManager().navigatorKey.currentContext);
    ui.Image image = await pictureInfo.picture.toImage((size.width).toInt(), (size.height).toInt());
    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ByteData? imageFile = await image.toByteData(format: ui.ImageByteFormat.png);
    BitmapDescriptor bitmapDescriptorfirst = BitmapDescriptor.bytes(imageFile!.buffer.asUint8List(), width: size.width, height: size.height);
    return bitmapDescriptorfirst;
  }

  double getDefaultZoomValue() {
    double zoomValue = LocalStorage().getDouble(ConstantDefine.KEY_ZOOM_VALUE_GOOGLE_MAP);
    if (zoomValue <= 0) {
      zoomValue = ConstantDefine.ZOOM_DEFAULT_VALUE;
      LocalStorage().saveDouble(ConstantDefine.KEY_ZOOM_VALUE_GOOGLE_MAP, zoomValue);
    }
    return zoomValue;
  }

  void setDefaultZoomValue(double zoomValue) {
    LocalStorage().saveDouble(ConstantDefine.KEY_ZOOM_VALUE_GOOGLE_MAP, zoomValue);
  }

  Future<Position?> getMyLocation({bool? streamLocation, Function(Position?)? onChangePosition}) async {
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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    InstanceManager().location = await Geolocator.getCurrentPosition();
    if (streamLocation ?? false) {
      await listenLocation(
        onChangePosition: (p0) {
          if (onChangePosition != null) {
            onChangePosition(p0);
          }
        },
      );
    }
    return InstanceManager().location;
  }

  Future<void> listenLocation({Function(Position?)? onChangePosition}) async {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      //distanceFilter: 0,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      InstanceManager().location = position;
      if (onChangePosition != null) {
        onChangePosition(InstanceManager().location);
      }
      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  Future<Uint8List> getBytesFromUrl(String url, int width) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
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
        await getBytesFromUrl((image ?? "") != '' ? image! : "https://i.pinimg.com/736x/0d/64/98/0d64989794b1a4c9d89bff571d3d5842.jpg", 100); // Kích thước hình ảnh bên trong là 80

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    final double markerSize = ResponsiveInfo.isTablet() ? Dimens.size80 : Dimens.size120; // Kích thước tổng thể marker (bao gồm cả viền)
    final double borderRadius = Dimens.size20; // Bo góc viền và hình ảnh

    // Vẽ hình chữ nhật bo góc làm nền
    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, markerSize, markerSize), // Tạo hình chữ nhật kích thước 120x120
      Radius.circular(borderRadius), // Bo góc viền với radius là 20
    );
    canvas.drawRRect(
      roundedRect,
      Paint()..color = statusColor ?? whiteColor, // Màu nền (trắng)
    );

    // Vẽ hình ảnh bên trong với bo góc
    final ui.Codec codec = await ui.instantiateImageCodec(markerIcon);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final double imageSize = markerSize - 16; // Kích thước hình ảnh (để lại khoảng trống cho viền)
    final RRect imageRect = RRect.fromRectAndRadius(
      Rect.fromLTWH((markerSize - imageSize) / 2, (markerSize - imageSize) / 2, imageSize, imageSize),
      Radius.circular(borderRadius), // Bo góc hình ảnh với radius là 20
    );

    // Cắt hình ảnh theo đường viền của hình chữ nhật bo góc
    canvas.clipRRect(imageRect);
    canvas.drawImageRect(
      fi.image,
      Rect.fromLTWH(0, 0, fi.image.width.toDouble(), fi.image.height.toDouble()),
      Rect.fromLTWH((markerSize - imageSize) / 2, (markerSize - imageSize) / 2, imageSize, imageSize),
      Paint(),
    );

    // Vẽ viền vuông bo góc ngoài cùng
    canvas.drawRRect(
      roundedRect.deflate(4), // Giảm kích thước viền để không bị cắt
      borderPaint,
    );

    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
          markerSize.toInt(),
          markerSize.toInt(),
        );
    final ByteData? byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    final marker = Marker(
      markerId: MarkerId(markerId ?? latLng.latitude.toString()),
      position: latLng,
      icon: BitmapDescriptor.fromBytes(uint8List),
      infoWindow: InfoWindow(title: name ?? ''),
      onTap: () {
        if (onTap != null && markerId != null) {
          onTap(markerId);
        }
      },
    );
    return marker;
  }

  Future<Uint8List> getImages(int width, String assetIcon) async {
    ByteData data = await rootBundle.load(assetIcon);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  String encodePointsLatLng(List<LatLng> points) {
    List<List<num>> coordinates = [];
    for (LatLng latLng in points) {
      coordinates.add([latLng.latitude, latLng.longitude]);
    }
    final polyline = PolylineCodec.encode(coordinates);
    return polyline;
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
    return 12742 * asin(sqrt(a)) * 1000;
  }

  double calculateDistance1(LatLngPoint p0, LatLngPoint p1) {
    /// tinh khoang cach giua 2 toa doa tren google map, tinh ra (m)
    var p = 0.017453292519943295;
    var a = 0.5 - cos((p1.lat! - p0.lat!) * p) / 2 + cos(p0.lat! * p) * cos(p1.lat! * p) * (1 - cos((p1.lng! - p0.lng!) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  double getSizeRatioForMarker() {
    bool isTable = ResponsiveInfo.isTablet();
    double height = ScreenUtil().screenHeight;
    double width = ScreenUtil().screenWidth;
    double minSize = height > width ? width : height;
    double raito = minSize / 1000;
    if (!isTable) {
      raito = 1;
    }
    return raito;
  }

  Future<LatLng> getLatLngAtCenterScreen(BuildContext context, GoogleMapController googleMapController) async {
    double screenWidth = MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio;
    double screenHeight = MediaQuery.of(context).size.height * MediaQuery.of(context).devicePixelRatio;

    double middleX = screenWidth / 2;
    double middleY = screenHeight / 2;

    ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());

    LatLng middlePoint = await googleMapController.getLatLng(screenCoordinate);
    return middlePoint;
  }

  Future<List<LatLng>> getDirections({
    required PointLatLng origin,
    required PointLatLng destination,
  }) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyDExO3b67M3YCnnStH1QAJtzzAvK5PA5hY",
        request: PolylineRequest(
          origin: origin,
          destination: destination,
          mode: TravelMode.driving,
          //wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
        ),
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        FileUtils.PrintLog(result.errorMessage);
      }
      return polylineCoordinates;
    } catch (e) {
      return [];
    }
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

  Future<String> getAddressByLocation(LatLng latLng) async {
    try {
      List<geocodingLib.Placemark> placemarks = await geocodingLib.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        String address = "${(placemarks.first.subLocality != null && placemarks.first.subLocality!.isNotEmpty) ? "${placemarks.first.subLocality!}, " : ""}"
            "${(placemarks.first.locality != null && placemarks.first.locality!.isNotEmpty) ? '${placemarks.first.locality!}, ' : ''}"
            "${(placemarks.first.subAdministrativeArea != null && placemarks.first.subAdministrativeArea!.isNotEmpty) ? '${placemarks.first.subAdministrativeArea!}, ' : ''}"
            "${(placemarks.first.administrativeArea != null && placemarks.first.administrativeArea!.isNotEmpty) ? '${placemarks.first.administrativeArea!}, ' : ''}"
            "${(placemarks.first.country != null && placemarks.first.country!.isNotEmpty) ? placemarks.first.country! : ''}";
        return address;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  double getDistanceInKm({required LatLng oldCenter, required LatLng newCenter}) {
    double distanceBetweenInMeter = Geolocator.distanceBetween(oldCenter.latitude, oldCenter.longitude, newCenter.latitude, newCenter.longitude);
    return distanceBetweenInMeter / 1000;
  }
}

class MyColorMapper implements ColorMapper {
  const MyColorMapper({
    required this.baseColor,
  });

  final Color baseColor;

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    if ((id == "1" || id == "2") && attributeName == "fill") {
      return baseColor;
    }
    return color;
  }
}
