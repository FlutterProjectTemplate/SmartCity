enum VehicleClient{
  ALL,
  WEB,
  MOBILE,
  TABLET
}

class VehicleTypeResponseModel {
  List<VehicleTypeInfo>? list;

  VehicleTypeResponseModel({this.list});

  VehicleTypeResponseModel.fromJson(dynamic json) {
    if (json != null) {
      list = <VehicleTypeInfo>[];
      json.forEach((v) {
        list?.add(VehicleTypeInfo.fromJson(v));
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
        this.icon
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
    icon = (json['icon']!=null && (json['icon'] as String).isNotEmpty)?json['icon']
        :
    'https://wallpapers.com/images/high/mountain-bike-top-view-png-w94dk9glv8lr7jh9-w94dk9glv8lr7jh9.png';
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

