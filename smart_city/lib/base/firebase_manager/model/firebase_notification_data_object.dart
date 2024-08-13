
enum MessageType{
  BOOKING, CANCEL_BOOKING, TOP_UP, NONE
}
Map<String, MessageType> stringToMessageType={
  "BOOKING":MessageType.BOOKING,
  "CANCEL_BOOKING":MessageType.CANCEL_BOOKING,
  "TOP_UP":MessageType.TOP_UP,
};
class FirebaseMessageData {
  String? type;
  MessageData? data;

  FirebaseMessageData({this.type, this.data});

  FirebaseMessageData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? MessageData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (this.data != null) {
      data['data'] =data;
    }
    return data;
  }
  MessageType getMessageType(){
    return stringToMessageType[type]??MessageType.NONE;
  }

}

class MessageData {
  int? bookingId;
  String? transactionId;
  String?uid;
  MessageData({this.bookingId, this.transactionId, this.uid});

  MessageData.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    transactionId = json['payTransactionId'].toString();
    uid = json['uid'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingId'] = bookingId;
    data['payTransactionId'] = transactionId;
    data['uid'] = uid;
    return data;
  }
}


class DeviceAlarmObjectData {
  String? trkTime;
  int? timeStampUtc;
  int? deviceId;
  int? userId;
  String? userName;
  String? imei;
  int? code;
  double? value;
  String? message;
  double? latitude;
  double? longitude;
  String? address;

  DeviceAlarmObjectData(
      {this.trkTime,
        this.timeStampUtc,
        this.deviceId,
        this.userId,
        this.userName,
        this.imei,
        this.code,
        this.value,
        this.message,
        this.latitude,
        this.longitude,
        this.address});

  DeviceAlarmObjectData.fromJson(Map<String, dynamic> json) {
    trkTime = json['TrkTime']??"";
    timeStampUtc = json['TimeStampUtc']??0;
    deviceId = json['DeviceId']??0;
    userId = json['UserId']??"";
    userName = json['UserName']??"";
    imei = json['Imei']??"";
    code = json['Code']??0;
    value = double.tryParse((json['Value']??0).toString());
    message = json['Message']??"";
    latitude = double.tryParse((json['Latitude']??0).toString());
    longitude = double.tryParse((json['Longitude']??0).toString());
    address = json['Address']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TrkTime'] =trkTime;
    data['TimeStampUtc'] =timeStampUtc;
    data['DeviceId'] =deviceId;
    data['UserId'] =userId;
    data['UserName'] =userName;
    data['Imei'] =imei;
    data['Code'] =code;
    data['Value'] =value;
    data['Message'] =message;
    data['Latitude'] =latitude;
    data['Longitude'] =longitude;
    data['Address'] =address;
    return data;
  }
} /// canh bao thong tin thiet bi
/// canh bao ra vao vung
class GeofenceAlert {
  String? time;
  String? updateTime;
  int? deviceId;
  int? userId;
  int? ruleId;
  double? latitude;
  double? longitude;
  String? address;
  double? speed;
  int? geofenceType;
  int? geofenceId;
  String? geofenceName;

  GeofenceAlert(
      {this.time,
        this.updateTime,
        this.deviceId,
        this.userId,
        this.ruleId,
        this.latitude,
        this.longitude,
        this.address,
        this.speed,
        this.geofenceType,
        this.geofenceId,
        this.geofenceName});

  GeofenceAlert.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    updateTime = json['UpdateTime'];
    deviceId = json['DeviceId'];
    userId = json['UserId'];
    ruleId = json['RuleId'];
    latitude = double.tryParse((json['Latitude']??0).toString());
    longitude = double.tryParse((json['Longitude']??0).toString());
    address = json['Address']??"";
    speed = double.tryParse((json['Speed']??0).toString());
    geofenceType = json['GeofenceType'];
    geofenceId = json['GeofenceId']??0;
    geofenceName = json['GeofenceName']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Time'] =time;
    data['UpdateTime'] =updateTime;
    data['DeviceId'] =deviceId;
    data['UserId'] =userId;
    data['RuleId'] =ruleId;
    data['Latitude'] =latitude;
    data['Longitude'] =longitude;
    data['Address'] =address;
    data['Speed'] =speed;
    data['GeofenceType'] =geofenceType;
    data['GeofenceId'] =geofenceId;
    data['GeofenceName'] =geofenceName;
    return data;
  }
}

class TemperatureAlert{} /// canh bao nhiet do