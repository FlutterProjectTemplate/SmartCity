class LocationInfo {
  double? latitude;
  double? longitude;
  double? altitude;
  int? heading;
  int? speed;
  String? address;
  String? createdAt;

  LocationInfo(
      {this.latitude,
      this.longitude,
      this.altitude,
      this.heading,
      this.speed,
      this.address,
      this.createdAt});

  LocationInfo.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    altitude = json['altitude'];
    heading = json['heading'];
    speed = json['speed'];
    address = json['address'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (altitude != null) data['altitude'] = altitude;
    if (heading != null) data['heading'] = heading;
    if (speed != null) data['speed'] = speed;
    if (address != null) data['address'] = address;
    if (createdAt != null) data['created_at'] = createdAt;
    return data;
  }
}
