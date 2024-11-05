
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineModelInfo{
  List<LatLng>? points=[];
  PolylineModelInfo({this.points}){
    points??=[];
  }
  PolylineModelInfo.fromJson(Map<String, dynamic> json) {
    if (json['points'] != null) {
      points = <LatLng>[];
      json['points'].forEach((v) {
        points?.add(LatLng.fromJson(v)??LatLng(0, 0));
      });
    }
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
