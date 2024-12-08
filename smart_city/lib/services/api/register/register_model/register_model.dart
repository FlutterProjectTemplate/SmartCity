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
  String? pinCode;
  int? customerId;

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
        this.vehicleType,
        this.pinCode,
        this.customerId
      });

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
    pinCode = json['pinCode'];
    customerId = json['customerId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(parentId!=null){
      data['parentId'] = parentId;
    }
    if(username!=null){
      data['username'] = username;
    }
    if(password!=null){
      data['password'] = password;
    }
    if(name!=null){
      data['name'] = name;
    }
    if(phone!=null){
      data['phone'] = phone;
    }
    if(description!=null){
      data['description'] = description;
    }
    if(timezone!=null){
      data['timezone'] = timezone;
    }
    if(language!=null){
      data['language'] = language;
    }
    if(roleId!=null){
      data['roleId'] = roleId;
    }
    if(email!=null){
      data['email'] = email;
    }
    if(alertPeriod!=null){
      data['alertPeriod'] = alertPeriod;
    }
    if(id!=null){
      data['id'] = id;
    }
    if(vehicleType!=null){
      data['vehicleType'] = vehicleType;
    }
    if(pinCode!=null){
      data['pinCode'] = pinCode;
    }
    if(customerId!=null){
      data['customerId'] = customerId;
    }
    return data;
  }
}
