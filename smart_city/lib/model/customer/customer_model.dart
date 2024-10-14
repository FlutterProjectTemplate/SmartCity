class CustomerModel {
  int? id;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  String? shortName;
  String? longName;
  String? modified;
  dynamic features;
  int? isEnabled;

  CustomerModel({
    this.id,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.shortName,
    this.longName,
    this.modified,
    this.features,
    this.isEnabled,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    shortName = json['shortName'];
    longName = json['longName'];
    modified = json['modified'];
    features = json['features'];
    isEnabled = json['isEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['updatedAt'] = updatedAt;
    data['updatedBy'] = updatedBy;
    data['shortName'] = shortName;
    data['longName'] = longName;
    data['modified'] = modified;
    data['features'] = features;
    data['isEnabled'] = isEnabled;
    return data;
  }
}