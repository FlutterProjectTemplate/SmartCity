import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/model/user/user_info.dart';

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
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    final Map<String, dynamic> data = <String, dynamic>{};
    if (timezone != null) data['timezone'] = userDetail?.timezone;
    if (language != null) data['language'] = userDetail?.language;
    if (name != null) data['name'] = userDetail?.name;
    if (email != null) data['email'] = userDetail?.email;
    if (phone != null) data['phone'] = userDetail?.phone;
    if (description != null) data['description'] = userDetail?.description;
    if (address != null) data['address'] = userDetail?.address;
    if (vehicleType != null) data['vehicleType'] = userDetail?.vehicleType;
    return data;
  }
}
