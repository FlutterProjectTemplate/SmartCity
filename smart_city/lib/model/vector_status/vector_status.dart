class VectorStatus {
  int? vectorId;
  int? customerId;
  int? totalUser;
  int? processUser;
  int? serviceUser;
  int? vectorStatus;
  DateTime? updatedAt;

  VectorStatus(
      {this.vectorId,
      this.customerId,
      this.totalUser,
      this.processUser,
      this.serviceUser,
      this.vectorStatus,
      this.updatedAt});

  VectorStatus.fromJson(Map<String, dynamic> json) {
    vectorId = json['VectorId'];
    customerId = json['CustomerId'];
    totalUser = json['TotalUser'];
    processUser = json['ProcessUser'];
    serviceUser = json['ServiceUser'];
    vectorStatus = json['VectorStatus'];
    String time = json['UpdatedAt'];
    updatedAt = DateTime.tryParse(time);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VectorId'] = vectorId;
    data['CustomerId'] = customerId;
    data['TotalUser'] = totalUser;
    data['ProcessUser'] = processUser;
    data['ServiceUser'] = serviceUser;
    data['VectorStatus'] = vectorStatus;
    data['UpdatedAt'] = updatedAt;
    return data;
  }
}
