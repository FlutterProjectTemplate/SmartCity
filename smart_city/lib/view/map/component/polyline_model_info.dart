
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city/controller/helper/map_helper.dart';

class PolylineModelInfo{
  List<LatLng>? points=[];
  List<Marker> polyLineMarkers=[];
  List<Position?> positions=[];
  PolylineModelInfo({this.points}){
    points??=[];
    polyLineMarkers=[];
  }
  PolylineModelInfo.fromJson(Map<String, dynamic> json) {
    if (json['points'] != null) {
      points = <LatLng>[];
      json['points'].forEach((v) {
        points?.add(LatLng.fromJson(v)??LatLng(0, 0));
      });
    }
  }

  void addPolylinePoints({required LatLng point, required Position position}){
    (points??[]).add(point);
    addMarkersOnPolyLine(position);
  }
  Future<void> addMarkersOnPolyLine(Position position) async {
    if(polyLineMarkers.isEmpty) {
      Marker current = await MapHelper().getMarkerFromBytes(
          markerId: position.toString(),
          latLng:LatLng(position.latitude, position.longitude),
          image:await MapHelper().getBytesFromImage("assets/arrow.png", 40),
          rotation: (MapHelper().location?.heading??0));
      polyLineMarkers.add(current);
    }
    else if(MapHelper().calculateDistance((polyLineMarkers).last.position, LatLng(position.latitude, position.longitude),)>2)
      {
        double heading = MapHelper().calculateBearing((polyLineMarkers).last.position, LatLng(position.latitude, position.longitude));
        //double bearing = Geolocator.bearingBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);

        Marker current = await MapHelper().getMarkerFromBytes(
            markerId: position.toString(),
            latLng: LatLng(position.latitude, position.longitude),
            image:await MapHelper().getBytesFromImage("assets/arrow.png", 40),
            rotation: heading);
        polyLineMarkers.add(current);
      }
  }
  List<Marker> getPolyLineMarker(){
    return polyLineMarkers;
  }

  List<LatLng>?getPointsPolyLine(){
    return points;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (points != null) {
      data['points'] =
          points!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
