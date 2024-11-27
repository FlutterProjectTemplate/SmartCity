class GetVehicleModel {
  List<VehicleModel>? list;

  GetVehicleModel(this.list);

  GetVehicleModel.fromJson(dynamic json) {
    if (json != null) {
      list = <VehicleModel>[];
      json.forEach((v) {
        list?.add(VehicleModel.fromJson(v));
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

class VehicleModel {
  int? id;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  String? shortName;
  String? text;
  int? maxSpeed;
  int? displayOrder;
  String? client;
  int? isEnabled;

  VehicleModel(
      {this.id,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy,
        this.shortName,
        this.text,
        this.maxSpeed,
        this.displayOrder,
        this.client,
        this.isEnabled});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    shortName = json['shortName'];
    text = json['text'];
    maxSpeed = json['maxSpeed'];
    displayOrder = json['displayOrder'];
    client = json['client'];
    isEnabled = json['isEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    data['updatedAt'] = this.updatedAt;
    data['updatedBy'] = this.updatedBy;
    data['shortName'] = this.shortName;
    data['text'] = this.text;
    data['maxSpeed'] = this.maxSpeed;
    data['displayOrder'] = this.displayOrder;
    data['client'] = this.client;
    data['isEnabled'] = this.isEnabled;
    return data;
  }
}

