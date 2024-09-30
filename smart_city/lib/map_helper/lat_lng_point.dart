class LatLngPoint {
  double? lat;
  double? lng;

  LatLngPoint({this.lat, this.lng});

  LatLngPoint.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}