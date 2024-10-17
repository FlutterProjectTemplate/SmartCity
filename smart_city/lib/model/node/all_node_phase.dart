class AllNodePhase {
  List<NodePhaseModel>? listNodePhase;

  AllNodePhase({this.listNodePhase});

  AllNodePhase.fromJson(dynamic json) {
    dynamic data = <NodePhaseModel>[];
    json.forEach((v) {
      data.add(NodePhaseModel.fromJson(v));
    });
    listNodePhase = data;
  }
}

class NodePhaseModel {
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

  NodePhaseModel(
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

  NodePhaseModel.fromJson(Map<String, dynamic> json) {
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
