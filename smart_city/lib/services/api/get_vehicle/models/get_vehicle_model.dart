import 'package:flutter/services.dart';
import 'package:smart_city/controller/helper/map_helper.dart';

enum VehicleClient{
  ALL,
  WEB,
  MOBILE,
  TABLET
}
Map<String, VehicleClient> strToVehicleClient={
  "MOBILE":VehicleClient.MOBILE,
  "TABLET":VehicleClient.TABLET,
  "WEB":VehicleClient.WEB,
  "ALL":VehicleClient.ALL,
};

class VehicleTypeResponseModel {
  List<VehicleTypeInfo>? list;

  VehicleTypeResponseModel({this.list});

  VehicleTypeResponseModel.fromJson(dynamic json, VehicleClient vehicleClient) {
    if (json != null) {
      list = <VehicleTypeInfo>[];
      json.forEach((v) {
        VehicleTypeInfo vehicleTypeInfo = VehicleTypeInfo.fromJson(v);
        if(vehicleTypeInfo.getVehicleClient() == vehicleClient) {
          list?.add(VehicleTypeInfo.fromJson(v));
        }
      });
    }
  }

  dynamic toJson() {
    dynamic data = {};
    if (list != null) {
       data = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleTypeInfo {
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  int? id;
  String? shortName;
  String? text;
  int? maxSpeed;
  int? displayOrder;
  String? client;
  int? isEnabled;
  String? icon;
  Uint8List? bytesIcon;
  final String pedestrianShotName = "PED";
  VehicleTypeInfo(
      {this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy,
        this.id,
        this.shortName,
        this.text,
        this.maxSpeed,
        this.displayOrder,
        this.client,
        this.isEnabled,
        this.icon,
        this.bytesIcon
      });

  VehicleTypeInfo.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    id = json['id'];
    shortName = json['shortName'];
    text = json['text'];
    maxSpeed = json['maxSpeed'];
    displayOrder = json['displayOrder'];
    client = json['client'];
    isEnabled = json['isEnabled'];
    icon = (json['icon']!=null && ((json['icon'] as String?)??"").contains("http"))?json['icon']
        :
    'https://wallpapers.com/images/high/mountain-bike-top-view-png-w94dk9glv8lr7jh9-w94dk9glv8lr7jh9.png';
    MapHelper().getBytesFromUrl(icon??"" , 120).then((value) {
      bytesIcon = value as Uint8List?;
    },);
  }

  Future<Uint8List?> getBytesIcon() async {
    bytesIcon ??= (await MapHelper().getBytesFromUrl(icon??"" , 120)) as Uint8List?;
    return bytesIcon;
  }
  VehicleClient getVehicleClient(){
    return strToVehicleClient[client]??VehicleClient.WEB;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['updatedAt'] = updatedAt;
    data['updatedBy'] = updatedBy;
    data['id'] = id;
    data['shortName'] = shortName;
    data['text'] = text;
    data['maxSpeed'] = maxSpeed;
    data['displayOrder'] = displayOrder;
    data['client'] = client;
    data['isEnabled'] = isEnabled;
    data['icon'] = icon;
    return data;
  }
  bool isPedestrian(){
    return shortName?.toLowerCase() == pedestrianShotName.toLowerCase();
  }
}

