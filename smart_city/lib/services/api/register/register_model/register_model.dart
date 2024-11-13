class RegisterModel {
  int? parentId;
  String? username;
  String? password;
  String? name;
  String? phone;
  String? description;
  String? timezone;
  String? language;
  int? roleId;
  String? email;
  String? alertPeriod;
  int? id;
  int? vehicleType;

  RegisterModel(
      {this.parentId,
        this.username,
        this.password,
        this.name,
        this.phone,
        this.description,
        this.timezone,
        this.language,
        this.roleId,
        this.email,
        this.alertPeriod,
        this.id,
        this.vehicleType});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    parentId = json['parentId'];
    username = json['username'];
    password = json['password'];
    name = json['name'];
    phone = json['phone'];
    description = json['description'];
    timezone = json['timezone'];
    language = json['language'];
    roleId = json['roleId'];
    email = json['email'];
    alertPeriod = json['alertPeriod'];
    id = json['id'];
    vehicleType = json['vehicleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parentId'] = parentId??1;
    data['username'] = username;
    data['password'] = password;
    data['name'] = name;
    data['phone'] = phone;
    data['description'] = description;
    data['timezone'] = timezone;
    data['language'] = language??'en';
    data['roleId'] = roleId??1;
    data['email'] = email;
    data['alertPeriod'] = alertPeriod;
    data['id'] = id;
    data['vehicleType'] = vehicleType??1;
    return data;
  }
}
