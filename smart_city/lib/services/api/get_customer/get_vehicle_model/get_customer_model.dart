class GetCustomerModel {
  List<CustomerModel>? list;

  GetCustomerModel(
      {this.list});

  GetCustomerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      list = <CustomerModel>[];
      json['data'].forEach((v) {
        list!.add( CustomerModel.fromJson(v));
      });
    }
  }
  GetCustomerModel.fromJsonList(List<dynamic> json) {
      list = <CustomerModel>[];
      for (var v in json) {
        list!.add( CustomerModel.fromJson(v));
      }

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['data'] = list?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerModel {
  int? id;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  String? shortName;
  String? longName;
  String? modified;
  List<Features>? features;
  int? featureId;
  int? isEnabled;

  CustomerModel(
      {this.id,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy,
        this.shortName,
        this.longName,
        this.modified,
        this.features,
        this.featureId,
        this.isEnabled});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    shortName = json['shortName'];
    longName = json['longName'];
    modified = json['modified'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add( Features.fromJson(v));
      });
    }
    featureId = json['featureId'];
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
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    data['featureId'] = featureId;
    data['isEnabled'] = isEnabled;
    return data;
  }
}

class Features {
  int? featureID;
  int? customerID;
  String? featureName;
  String? featureIcon;

  Features(
      {this.featureID, this.customerID, this.featureName, this.featureIcon});

  Features.fromJson(Map<String, dynamic> json) {
    featureID = json['featureID'];
    customerID = json['customerID'];
    featureName = json['featureName'];
    featureIcon = json['featureIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['featureID'] = featureID;
    data['customerID'] = customerID;
    data['featureName'] = featureName;
    data['featureIcon'] = featureIcon;
    return data;
  }
}
