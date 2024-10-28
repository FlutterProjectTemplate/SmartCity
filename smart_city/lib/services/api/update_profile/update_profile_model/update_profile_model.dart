class UpdateProfileModel {
  String? timezone;
  String? language;
  String? name;
  String? email;
  String? phone;
  String? description;
  String? address;
  int? vehicleType;

  UpdateProfileModel(
      {this.timezone,
        this.language,
        this.name,
        this.email,
        this.phone,
        this.description,
        this.address,
        this.vehicleType});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    timezone = json['timezone'];
    language = json['language'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    description = json['description'];
    address = json['address'];
    vehicleType = json['vehicleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (timezone != null) data['timezone'] = timezone;
    if (language != null) data['language'] = language;
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (description != null) data['description'] = description;
    if (address != null) data['address'] = address;
    if (vehicleType != null) data['vehicleType'] = vehicleType;
    return data;
  }
}
