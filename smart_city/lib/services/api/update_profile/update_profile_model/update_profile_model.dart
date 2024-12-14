import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/user/user_detail.dart';

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
    data['timezone'] = timezone??userDetail?.timezone;
    data['language'] = language??userDetail?.language;
    data['name'] = name??userDetail?.name;
    data['email'] = email??userDetail?.email;
    data['phone'] = phone??userDetail?.phone;
    data['description'] = description??userDetail?.description;
    data['address'] = address??userDetail?.address;
    data['vehicleType'] = vehicleType??userDetail?.vehicleTypeNum;
    return data;
  }
}
