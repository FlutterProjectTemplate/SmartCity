class ResponseCommon {
  String? datetime;
  String? errorCode;
  String? message;
  dynamic data;
  bool? success;
  String ?traceId;

  ResponseCommon(
      {this.datetime, this.errorCode, this.message, this.data, this.success, this.traceId});

  ResponseCommon.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    errorCode = json['errorCode']??json['status'].toString();
    message = json['message']??json['title']??"";
    data = json['data'];
    success = json['success'];
    traceId = json['traceId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['datetime'] = datetime;
    data['errorCode'] = errorCode;
    data['message'] = message;
    data['data'] =data;
    data['success'] = success;
    data['traceId'] = traceId;
    return data;
  }
}

class OCPPErrorCommonInfo {
  String? type;
  String? title;
  int? status;
  String? traceId;
  OCPPErrorRequestInfo? errors;

  OCPPErrorCommonInfo(
      {this.type, this.title, this.status, this.traceId, this.errors});

  OCPPErrorCommonInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    status = json['status'];
    traceId = json['traceId'];
    errors =
    json['errors'] != null ? OCPPErrorRequestInfo.fromJson(json['errors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] =type;
    data['title'] =title;
    data['status'] =status;
    data['traceId'] =traceId;
    if (errors != null) {
      data['errors'] =errors!.toJson();
    }
    return data;
  }
}

class OCPPErrorRequestInfo {
  List<String>? request;
  List<String>? bookingId;

  OCPPErrorRequestInfo({this.request, this.bookingId});

  OCPPErrorRequestInfo.fromJson(Map<String, dynamic> json) {
    request =[];
    bookingId=[];
    if(json.containsKey('request')) {
      request = json['request'].cast<String>();
    }
    if(json.containsKey('bookingId')) {
      bookingId = json['bookingId'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request'] =request;
    data['bookingId'] =bookingId;
    return data;
  }
}
