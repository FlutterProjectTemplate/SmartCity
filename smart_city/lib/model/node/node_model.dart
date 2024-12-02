class NodeModel {
  int? id;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  int? customerId;
  int? countyId;
  int? type;
  String? deviceId;
  String? nodeNum;
  String? name;
  String? locality;
  double? deviceLat;
  double? deviceLng;
  double? uiLat;
  double? uiLng;
  int? uiHeading;
  String? guid;
  String? remoteKey;
  int? streamId;
  String? modified;
  List<ListNodePhases>? listNodePhases;
  List<Null>? nodeItems;
  List<Null>? nodeItemCustoms;
  List<Null>? nodeCameraCustoms;
  int? isNtcipEnabled;
  int? isNtcipLocked;
  int? isCommandsEnabled;
  int? isNtcipStatusEnabled;

  NodeModel(
      {this.id,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.customerId,
      this.countyId,
      this.type,
      this.deviceId,
      this.nodeNum,
      this.name,
      this.locality,
      this.deviceLat,
      this.deviceLng,
      this.uiLat,
      this.uiLng,
      this.uiHeading,
      this.guid,
      this.remoteKey,
      this.streamId,
      this.modified,
      this.listNodePhases,
      this.nodeItems,
      this.nodeItemCustoms,
      this.nodeCameraCustoms,
      this.isNtcipEnabled,
      this.isNtcipLocked,
      this.isCommandsEnabled,
      this.isNtcipStatusEnabled});

  NodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    customerId = json['customerId'];
    countyId = json['countyId'];
    type = json['type'];
    deviceId = json['deviceId'];
    nodeNum = json['nodeNum'];
    name = json['name'];
    locality = json['locality'];
    deviceLat = json['deviceLat'];
    deviceLng = json['deviceLng'];
    uiLat = json['uiLat'];
    uiLng = json['uiLng'];
    uiHeading = json['uiHeading'];
    guid = json['guid'];
    remoteKey = json['remoteKey'];
    streamId = json['streamId'];
    modified = json['modified'];
    if (json['listNodePhases'] != null) {
      listNodePhases = <ListNodePhases>[];
      json['listNodePhases'].forEach((v) {
        listNodePhases!.add(ListNodePhases.fromJson(v));
      });
    }
    // if (json['nodeItems'] != null) {
    //   nodeItems = <Null>[];
    //   json['nodeItems'].forEach((v) {
    //     nodeItems!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['nodeItemCustoms'] != null) {
    //   nodeItemCustoms = <Null>[];
    //   json['nodeItemCustoms'].forEach((v) {
    //     nodeItemCustoms!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['nodeCameraCustoms'] != null) {
    //   nodeCameraCustoms = <Null>[];
    //   json['nodeCameraCustoms'].forEach((v) {
    //     nodeCameraCustoms!.add(new Null.fromJson(v));
    //   });
    // }
    isNtcipEnabled = json['isNtcipEnabled'];
    isNtcipLocked = json['isNtcipLocked'];
    isCommandsEnabled = json['isCommandsEnabled'];
    isNtcipStatusEnabled = json['isNtcipStatusEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['updatedAt'] = updatedAt;
    data['updatedBy'] = updatedBy;
    data['customerId'] = customerId;
    data['countyId'] = countyId;
    data['type'] = type;
    data['deviceId'] = deviceId;
    data['nodeNum'] = nodeNum;
    data['name'] = name;
    data['locality'] = locality;
    data['deviceLat'] = deviceLat;
    data['deviceLng'] = deviceLng;
    data['uiLat'] = uiLat;
    data['uiLng'] = uiLng;
    data['uiHeading'] = uiHeading;
    data['guid'] = guid;
    data['remoteKey'] = remoteKey;
    data['streamId'] = streamId;
    data['modified'] = modified;
    if (listNodePhases != null) {
      data['listNodePhases'] =
          listNodePhases!.map((v) => v.toJson()).toList();
    }
    // if (this.nodeItems != null) {
    //   data['nodeItems'] = this.nodeItems!.map((v) => v.toJson()).toList();
    // }
    // if (this.nodeItemCustoms != null) {
    //   data['nodeItemCustoms'] =
    //       this.nodeItemCustoms!.map((v) => v.toJson()).toList();
    // }
    // if (this.nodeCameraCustoms != null) {
    //   data['nodeCameraCustoms'] =
    //       this.nodeCameraCustoms!.map((v) => v.toJson()).toList();
    // }
    data['isNtcipEnabled'] = isNtcipEnabled;
    data['isNtcipLocked'] = isNtcipLocked;
    data['isCommandsEnabled'] = isCommandsEnabled;
    data['isNtcipStatusEnabled'] = isNtcipStatusEnabled;
    return data;
  }
}

class ListNodePhases {
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  int? id;
  int? nodeID;
  int? phaseNum;
  String? flowID;
  String? overlayID;
  String? modified;

  ListNodePhases(
      {this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.id,
      this.nodeID,
      this.phaseNum,
      this.flowID,
      this.overlayID,
      this.modified});

  ListNodePhases.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    id = json['id'];
    nodeID = json['nodeID'];
    phaseNum = json['phaseNum'];
    flowID = json['flowID'];
    overlayID = json['overlayID'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['updatedAt'] = updatedAt;
    data['updatedBy'] = updatedBy;
    data['id'] = id;
    data['nodeID'] = nodeID;
    data['phaseNum'] = phaseNum;
    data['flowID'] = flowID;
    data['overlayID'] = overlayID;
    data['modified'] = modified;
    return data;
  }
}
