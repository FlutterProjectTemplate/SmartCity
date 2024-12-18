enum UnitType{
  meter,
  feet
}
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
  UnitType? unit;

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
    areaJson = standardizeString(json['areaJson']);
    positionJson = standardizeString(json['positionJson']);
    bearing = json['bearing'];
    deviceChannel = json['deviceChannel'];
    if(json['unit'] == 'feet')
      {
        unit = UnitType.feet;
      }
      else
      {
        unit = UnitType.meter;
      }
    inner = json['inner'] * getRadiusRatio();
    middle = json['middle']* getRadiusRatio();
    outer = json['outer']* getRadiusRatio();
    outer4 = json['outer4']* getRadiusRatio();
  }

  double getRadiusRatio(){
    if(unit == UnitType.meter) {
      return 1;
    } else {
      return 0.3048;
    }
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
    data['areaJson'] = areaJson;
    data['positionJson'] = positionJson;
    data['bearing'] = bearing;
    data['deviceChannel'] = deviceChannel;
    data['inner'] = inner;
    data['middle'] = middle;
    data['outer'] = outer;
    data['outer4'] = outer4;
    return data;
  }

  String standardizeString(String s) {
    return s
        .replaceAll('POLYGON', '')
        .replaceAll('POINT', '')
        .replaceAll(')', '')
        .replaceAll('(', '')
        .replaceAll(',', ' ')
        .replaceAll('  ', ' ')
        .trim();
  }
}
