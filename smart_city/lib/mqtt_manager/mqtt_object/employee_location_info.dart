
class EmployeeLocationInfo {
  int? employeeId;
  int? companyId;
  double? latitude;
  double? longitude;
  double? altitude;
  int? heading;
  int? speed;
  String? address;
  int? geofenceId;
  String? createdAt;

  EmployeeLocationInfo(
      {this.employeeId,
        this.companyId,
        this.latitude,
        this.longitude,
        this.altitude,
        this.heading,
        this.speed,
        this.address,
        this.geofenceId,
        this.createdAt});

  EmployeeLocationInfo.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    companyId = json['company_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    altitude = json['altitude'];
    heading = json['heading'];
    speed = json['speed'];
    address = json['address'];
    geofenceId = json['geofence_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['company_id'] = companyId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['altitude'] = altitude;
    data['heading'] = heading;
    data['speed'] = speed;
    data['address'] = address;
    data['geofence_id'] = geofenceId;
    data['created_at'] = createdAt;
    return data;
  }
}
