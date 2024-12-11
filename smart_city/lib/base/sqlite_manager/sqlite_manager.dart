import 'package:local_auth/local_auth.dart';
import 'package:smart_city/base/store/cached_storage.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
import 'package:smart_city/model/customer/customer_model.dart';
import 'package:smart_city/model/notification/notification.dart';
import 'package:smart_city/model/user/user_info.dart';
import 'dart:convert';

import '../../model/user/user_detail.dart';
import '../../services/api/get_vehicle/models/get_vehicle_model.dart';

class SqliteManager{
  static final SqliteManager _singleton = SqliteManager._internal();
  static SqliteManager get getInstance => _singleton;

  factory SqliteManager() {
    return _singleton;
  }

  SqliteManager._internal();

  //check biometric
  final _auth = LocalAuthentication();
  Future<bool> hasBiometrics() async {
    final isAvailable = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> authenticate() async {
    final isAuthAvailable = await hasBiometrics();
    if (!isAuthAvailable) return false;
    try {
      return await _auth.authenticate(
          localizedReason: 'Touch your finger on the sensor to login');
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteDataWhenLogout() async {
    await SharedPreferencesStorage().removeAllDynamicData();
    await SharedPreferencesStorage().removeAllDynamicKeys();
  }
  //#region define db for store key values
  /* ----------- begin define db for store key values-------------*/
  // Define a function that inserts dogs into the database
  Future<void> setValueForKey(String key, String value) async {
    // Get a reference to the database.
    await SharedPreferencesStorage().saveString(key, value);
  }

  Future<String> getValueForKey(String key) async {
    return SharedPreferencesStorage().getString(key);
  }

  String boolToString(bool value) {
    return value ? "true" : "false";
  }

  Future<void> setIntegerForKey(String key, int value) async {
    // Get a reference to the database.
    await SharedPreferencesStorage().saveInteger(key, value);
  }

  Future<void> setBoolForKey(String key, bool value) async {
    // Get a reference to the database.
    await SharedPreferencesStorage().saveBoolean(key, value);

  }

  Future<void> setDoubleForKey(String key, double value) async {
    // Get a reference to the database.
    await SharedPreferencesStorage().saveDouble(key, value);

  }

  Future<void> setStringForKey(String key, String value) async {
    await SharedPreferencesStorage().saveString(key, value);

  }

  bool parseBool(String value) {
    return value.toLowerCase() == 'true';
  }

  Future<bool> getBoolForKey(String key) async {
    return SharedPreferencesStorage().getBoolean(key);
  }

  Future<int> getIntegerForKey(String key) async {
    return SharedPreferencesStorage().getInt(key);

  }

  Future<double> getDoubleForKey(String key) async {
    return SharedPreferencesStorage().getDouble(key);
  }

  Future<String> getStringForKey(String key) async {
    return SharedPreferencesStorage().getString(key);
  }

  Future<void> saveNotification(NotificationModel notificationModel) async {
    SharedPreferencesStorage().saveString(Storage.notificationKey, jsonEncode(notificationModel.toJson()));
  }

  Future<void> deleteNotification() async {
    SharedPreferencesStorage().removeByKey(Storage.notificationKey);
  }

  Future<void> insertCurrentLoginUserInfo(UserInfo useInfo) async {
    SharedPreferencesStorage().saveString(Storage.rootUserInfoKey, jsonEncode(useInfo.toJson()));
  }

  Future<void> insertCurrentLoginUserDetail(UserDetail userDetail) async {
    SharedPreferencesStorage().saveString(Storage.rootUserDetailKey, jsonEncode(userDetail.toJson()));
  }

  Future<void> insertCurrentCustomerDetail(CustomerModel customerDetail) async {
    SharedPreferencesStorage().saveString(Storage.rootCustomerDetailKey, jsonEncode(customerDetail.toJson()));
  }

  Future<void> insertVehicleType(VehicleTypeResponseModel getVehicleModel) async {
    SharedPreferencesStorage().saveString(Storage.vehicleTypeKey, jsonEncode(getVehicleModel.toJson()));
  }

  Future<void> deleteCurrentLoginUserInfo() async {
    SharedPreferencesStorage().removeByKey(Storage.rootUserInfoKey);
  }

  Future<void> deleteCurrentLoginUserDetail() async {
    SharedPreferencesStorage().removeByKey(Storage.rootUserDetailKey);
  }

  Future<void> deleteCurrentCustomerDetail() async {
    SharedPreferencesStorage().removeByKey(Storage.rootCustomerDetailKey);
  }

  Future<void> deleteVehicleType(VehicleTypeResponseModel getVehicleModel) async {
    SharedPreferencesStorage().removeByKey(Storage.vehicleTypeKey);
  }


  UserInfo? getCurrentLoginUserInfo() {
    String rootUserStr = SharedPreferencesStorage().getString(Storage.rootUserInfoKey);
    UserInfo? userInfo;
    if(rootUserStr.isNotEmpty)
    {
      userInfo = UserInfo.fromJsonForDB(jsonDecode(rootUserStr));
    }
    return userInfo;
  }

  UserDetail? getCurrentLoginUserDetail() {
    String rootUserStr = SharedPreferencesStorage().getString(Storage.rootUserDetailKey);
    UserDetail? userDetail;
    if(rootUserStr.isNotEmpty)
    {
      userDetail = UserDetail.fromJson(jsonDecode(rootUserStr));
    }
    return userDetail;
  }

  CustomerModel? getCurrentCustomerDetail() {
    String rootUserStr = SharedPreferencesStorage().getString(Storage.rootCustomerDetailKey);
    CustomerModel? customerModel;
    if(rootUserStr.isNotEmpty)
    {
      customerModel = CustomerModel.fromJson(jsonDecode(rootUserStr));
    }
    return customerModel;
  }

  UserInfo? getCurrentSelectUserInfo() {
    String reUserListStr =  SharedPreferencesStorage().getString(Storage.currentUserInfoKey);
    if(reUserListStr.isEmpty)
    {
      return null;
    }
    RecentUserList recentUserList = RecentUserList.fromJson(jsonDecode(reUserListStr));
    return (recentUserList.recentUserContentList!=null && recentUserList.recentUserContentList!.isNotEmpty)?recentUserList.recentUserContentList!.first:null;
  }

  VehicleTypeResponseModel? getVehicleModel() {
    String reUserListStr =  SharedPreferencesStorage().getString(Storage.vehicleTypeKey);
    if(reUserListStr.isEmpty)
    {
      return null;
    }
    dynamic a = jsonDecode(reUserListStr);
    VehicleTypeResponseModel getVehicleModel = VehicleTypeResponseModel.fromJson(a);
    return getVehicleModel;
  }
}