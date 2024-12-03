import 'dart:ui';

import 'package:flutter/material.dart';

enum VectorStatus{
  Normal,
  Processing,
  Service
}
class VectorStatusInfo {
  int? vectorId;
  int? customerId;
  int? totalUser;
  int? processUser;
  int? serviceUser;
  int? vectorStatus;
  String? updatedAt;
  VectorStatus? vectorStatusType;
  VectorStatusInfo(
      {this.vectorId,
      this.customerId,
      this.totalUser,
      this.processUser,
      this.serviceUser,
      this.vectorStatus,
      this.updatedAt,
      this.vectorStatusType});

  VectorStatusInfo.fromJson(Map<String, dynamic> json) {
    vectorId = json['VectorId'];
    customerId = json['CustomerId'];
    totalUser = json['TotalUser'];
    processUser = json['ProcessUser'];
    serviceUser = json['ServiceUser'];
    vectorStatus = json['VectorStatus'];
    updatedAt = json['UpdatedAt'];
    List<VectorStatus> vectorStatusTypes = [...VectorStatus.values.where((element) => element.index == (vectorStatus??0))];
    if(vectorStatusTypes.isNotEmpty) {
      vectorStatusType = vectorStatusTypes.first;
    }
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
  Color getStatusColor(){

    Color status = Color(0xff0000ff);
    switch(vectorStatusType){
      case null:
        // TODO: Handle this case.
      case VectorStatus.Normal:
        // TODO: Handle this case.
        status = Color(0xff0000ff);
        break;
      case VectorStatus.Processing:
        // TODO: Handle this case.
        status = Colors.orangeAccent;
        break;
      case VectorStatus.Service:
        // TODO: Handle this case.
        status = Colors.green;
        break;
    }
    return status;
  }
}
