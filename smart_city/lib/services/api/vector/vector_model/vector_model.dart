class VectorModel {
  List<VecterDetail>? list;

  VectorModel(this.list) {
    list??=[];
  }

  VectorModel.fromJson(dynamic json) {
    if (json != null) {
      list = <VecterDetail>[];
      json.forEach((v) {
        list?.add(VecterDetail.fromJson(v));
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

class VecterDetail {
  int? id;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  int? typeID;
  int? nodeID;
  int? phase;
  int? isEnabled;
  String? nameID;
  String? areaJson;
  String? positionJson;
  double? bearing;
  int? deviceChannel;
  double? inner;
  double? middle;
  double? outer;
  double? outer4;

  VecterDetail(
      {this.id,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy,
        this.typeID,
        this.nodeID,
        this.phase,
        this.isEnabled,
        this.nameID,
        this.areaJson,
        this.positionJson,
        this.bearing,
        this.deviceChannel,
        this.inner,
        this.middle,
        this.outer,
        this.outer4});

  VecterDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    typeID = json['typeID'];
    nodeID = json['nodeID'];
    phase = json['phase'];
    isEnabled = json['isEnabled'];
    nameID = json['nameID'];
    areaJson = json['area_json'];
    positionJson = json['position_json'];
    bearing = json['bearing'];
    deviceChannel = json['deviceChannel'];
    inner = json['inner'];
    middle = json['middle'];
    outer = json['outer'];
    outer4 = json['outer4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['updatedAt'] = updatedAt;
    data['updatedBy'] = updatedBy;
    data['typeID'] = typeID;
    data['nodeID'] = nodeID;
    data['phase'] = phase;
    data['isEnabled'] = isEnabled;
    data['nameID'] = nameID;
    data['area_json'] = areaJson;
    data['position_json'] = positionJson;
    data['bearing'] = bearing;
    data['deviceChannel'] = deviceChannel;
    data['inner'] = inner;
    data['middle'] = middle;
    data['outer'] = outer;
    data['outer4'] = outer4;
    return data;
  }
}
