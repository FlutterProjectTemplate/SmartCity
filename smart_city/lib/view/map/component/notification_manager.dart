import 'package:flutter/cupertino.dart';
import '../../../model/notification/notification.dart';

class NotificationManager {
  NotificationManager._privateConstructor();

  static final NotificationManager _instance = NotificationManager._privateConstructor();

  static NotificationManager get instance => _instance;

  List<NotificationModel>? _notifications;

  void init(List<NotificationModel> list) {
    _notifications = list;
  }

  void addNotification(NotificationModel notification) {
    _notifications?.add(notification);
  }

  void removeNotification(NotificationModel notification) {
    _notifications?.remove(notification);
  }

  void clearNotifications() {
    _notifications = [];
  }

  List<NotificationModel>? get notifications => _notifications;
}