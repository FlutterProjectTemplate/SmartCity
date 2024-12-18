class LocationInfo {
  String? name;
  double? latitude;
  double? longitude;
  double? altitude;
  int? heading;
  double? speed;
  String? address;
  String? createdAt;
  double? previousLatitude;
  double? previousLongitude;
  double? previousSpeed;
  int? previousHeading;
  int? vehicleType;

  LocationInfo(
      {this.name,
      this.latitude,
      this.longitude,
      this.altitude,
      this.heading,
      this.speed,
      this.address,
      this.createdAt,
      this.previousLatitude,
      this.previousLongitude,
      this.previousSpeed,
      this.previousHeading,
        this.vehicleType
      });

  LocationInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    altitude = json['altitude'];
    heading = json['heading'];
    speed = json['speed'];
    address = json['address'];
    createdAt = json['created_at'];
    previousLatitude = json['previous_latitude'];
    previousLongitude = json['previous_longitude'];
    previousSpeed = json['previous_spreed'];
    vehicleType = json['vehicle_type'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (altitude != null) data['altitude'] = altitude;
    if (heading != null) data['heading'] = heading;
    if (speed != null) data['speed'] = speed;
    if (address != null) data['address'] = address;
    if (createdAt != null) data['created_at'] = createdAt;
    if (previousLatitude != null) data['previous_latitude'] = previousLatitude;
    if (previousLongitude != null) {
      data['previous_longitude'] = previousLongitude;
    }
    if (previousSpeed != null) data['previous_speed'] = previousSpeed;
    if (previousHeading != null) data['previous_heading'] = previousHeading;
    if (vehicleType != null) data['vehicle_type'] = vehicleType;

    return data;
  }

  LocationInfo copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    int? heading,
    double? speed,
    String? address,
    String? createdAt,
    double? previousLatitude,
    double? previousLongitude,
    double? previousSpeed,
    int? previousHeading,
    int? vehicleType
  }) {
    return LocationInfo(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      previousLatitude: previousLatitude ?? this.previousLatitude,
      previousLongitude: previousLongitude ?? this.previousLongitude,
      previousHeading: previousHeading ?? this.previousHeading,
      previousSpeed: previousSpeed ?? this.previousSpeed,
      vehicleType: vehicleType ?? this.vehicleType,

    );
  }
}
