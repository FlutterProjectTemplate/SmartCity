import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
import 'package:smart_city/services/api/get_vehicle/get_vehicle_model/get_vehicle_model.dart';

class UserDetail {
  int? id;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  int? parentId;
  String? path;
  String? username;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? description;
  String? timezone;
  String? language;
  String? permission;
  int? roleId;
  bool? hasChild;
  String? roleName;
  String? roleKey;
  bool? pinCode;
  String? avatar;
  int? customerId;
  int? isEnabled;
  int? isAdmin;
  int? vehicleTypeNum;
  VehicleType? vehicleType;

  UserDetail(
      {this.id,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.parentId,
      this.path,
      this.username,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.description,
      this.timezone,
      this.language,
      this.permission,
      this.roleId,
      this.hasChild,
      this.roleName,
      this.roleKey,
      this.pinCode,
      this.avatar,
      this.customerId,
      this.isEnabled,
      this.isAdmin,
      this.vehicleTypeNum,
      this.vehicleType});

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    parentId = json['parentId'];
    path = json['path'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    description = json['description'];
    timezone = json['timezone'];
    language = json['language'];
    permission = json['permission'];
    roleId = json['roleId'];
    hasChild = json['hasChild'];
    roleName = json['roleName'];
    roleKey = json['roleKey'];
    pinCode = json['pinCode'];
    avatar = json['avatar'];
    customerId = json['customerId'];
    isEnabled = json['isEnabled'];
    isAdmin = json['isAdmin'];
    vehicleTypeNum = json['vehicleType'];
    GetVehicleModel? vehicleModel = SqliteManager().getVehicleModel();
    switch (vehicleTypeNum) {
      case 1:
        vehicleType = VehicleType.car;
        break;
      default:
        vehicleType = VehicleType.car;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['updatedAt'] = updatedAt;
    data['updatedBy'] = updatedBy;
    data['parentId'] = parentId;
    data['path'] = path;
    data['username'] = username;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['description'] = description;
    data['timezone'] = timezone;
    data['language'] = language;
    data['permission'] = permission;
    data['roleId'] = roleId;
    data['hasChild'] = hasChild;
    data['roleName'] = roleName;
    data['roleKey'] = roleKey;
    data['pinCode'] = pinCode;
    data['avatar'] = avatar;
    data['customerId'] = customerId;
    data['isEnabled'] = isEnabled;
    data['isAdmin'] = isAdmin;
    data['vehicleType'] = vehicleTypeNum;
    return data;
  }

  UserDetail.initial() {
    id = 0;
    createdAt = "";
    createdBy = "";
    updatedAt = "";
    updatedBy = "";
    parentId = 0;
    path = "";
    username = "";
    name = "";
    email = "";
    phone = "";
    address = "";
    description = "";
    timezone = "";
    language = "";
    permission = "";
    roleId = 0;
    hasChild = false;
    roleName = "";
    roleKey = "";
    pinCode = false;
    avatar = "";
    customerId = 0;
    isEnabled = 0;
    isAdmin = 0;
    vehicleTypeNum = 1;
    vehicleType = VehicleType.pedestrian;
  }

  UserDetail copyWith(
      {int? id,
      String? createdAt,
      String? createdBy,
      String? updatedAt,
      String? updatedBy,
      int? parentId,
      String? path,
      String? username,
      String? name,
      String? email,
      String? phone,
      String? address,
      String? description,
      String? timezone,
      String? language,
      String? permission,
      int? roleId,
      bool? hasChild,
      String? roleName,
      String? roleKey,
      bool? pinCode,
      String? avatar,
      int? customerId,
      int? isEnabled,
      int? isAdmin,
      int? vehicleTypeNum,
      VehicleType? vehicleType}) {
    return UserDetail(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        parentId: parentId ?? this.parentId,
        path: path ?? this.path,
        username: username ?? this.username,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        description: description ?? this.description,
        timezone: timezone ?? this.timezone,
        language: language ?? this.language,
        permission: permission ?? this.permission,
        roleId: roleId ?? this.roleId,
        hasChild: hasChild ?? this.hasChild,
        roleName: roleName ?? this.roleName,
        roleKey: roleKey ?? this.roleKey,
        pinCode: pinCode ?? this.pinCode,
        avatar: avatar ?? this.avatar,
        customerId: customerId ?? this.customerId,
        isEnabled: isEnabled ?? this.isEnabled,
        isAdmin: isAdmin ?? this.isAdmin,
        vehicleTypeNum: vehicleTypeNum ?? this.vehicleTypeNum,
        vehicleType: vehicleType ?? this.vehicleType);
  }

  UserDetail.copyWithUserInfo({required UserDetail userDetail}) {
    id = userDetail.id;
    createdAt = userDetail.createdAt;
    createdBy = userDetail.createdBy;
    updatedAt = userDetail.updatedAt;
    updatedBy = userDetail.updatedBy;
    parentId = userDetail.parentId;
    path = userDetail.path;
    username = userDetail.username;
    name = userDetail.name;
    email = userDetail.email;
    phone = userDetail.phone;
    address = userDetail.address;
    description = userDetail.description;
    timezone = userDetail.timezone;
    language = userDetail.language;
    permission = userDetail.permission;
    roleId = userDetail.roleId;
    hasChild = userDetail.hasChild;
    roleName = userDetail.roleName;
    roleKey = userDetail.roleKey;
    pinCode = userDetail.pinCode;
    avatar = userDetail.avatar;
    customerId = userDetail.customerId;
    isEnabled = userDetail.isEnabled;
    isAdmin = userDetail.isAdmin;
    vehicleType = userDetail.vehicleType;
    vehicleTypeNum = userDetail.vehicleTypeNum;
  }
}
