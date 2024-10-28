class GetVehicleModel {
  List<VehicleCode>? list;

  GetVehicleModel(this.list);

  GetVehicleModel.fromJson(dynamic json) {
    if (json != null) {
      list = <VehicleCode>[];
      json.forEach((v) {
        list?.add(VehicleCode.fromJson(v));
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

class VehicleCode {
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  int? id;
  String? name;
  String? code;

  VehicleCode(
      {this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.id,
      this.name,
      this.code});

  VehicleCode.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['updatedAt'] = updatedAt;
    data['updatedBy'] = updatedBy;
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}
