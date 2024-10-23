class NotificationModel {
  String? msg;
  DateTime? dateTime;
  bool? seen;

  NotificationModel({
    this.msg,
    this.dateTime,
    this.seen = false,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    data['dateTime'] = dateTime?.toIso8601String();
    data['seen'] = seen;
    return data;
  }
}
