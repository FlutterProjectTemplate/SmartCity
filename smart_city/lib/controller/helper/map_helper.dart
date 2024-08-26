import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;
import 'package:smart_city/constant_value/const_colors.dart';

class MapHelper{
  LatLng _currentLocation = const LatLng(21.018481, 105.802765);// example location
  static MapHelper? _instance;
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
      Location location = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      try {
        serviceEnabled = await location.serviceEnabled();
      } on PlatformException catch (err) {
        debugPrint(err.message);
        serviceEnabled = false;
      }

      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return false;
        }
      }
      listenLocationUpdate();
      return true;
    } else {
      return false;
    }
  }

  void listenLocationUpdate(){
    Location location = Location();
    location.onLocationChanged.listen((LocationData locationData) {
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
    });
  }


}