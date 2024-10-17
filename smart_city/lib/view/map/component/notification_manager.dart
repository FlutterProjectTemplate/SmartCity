import 'package:flutter/cupertino.dart';
import '../../../model/notification/notification.dart';

class NotificationManager {
  // Private constructor
  NotificationManager._privateConstructor();

  // Singleton instance
  static final NotificationManager _instance = NotificationManager._privateConstructor();

  // Getter for the singleton instance
  static NotificationManager get instance => _instance;

  List<NotificationModel>? _notifications;

  // Initialize notifications
  void init(List<NotificationModel> list) {
    _notifications = list;
  }

  // Add a notification
  void addNotification(NotificationModel notification) {
    _notifications?.add(notification);
  }

  // Remove a notification
  void removeNotification(NotificationModel notification) {
    _notifications?.remove(notification);
  }

  // Clear all notifications
  void clearNotifications() {
    _notifications = [];
  }

  // Get the list of notifications
  List<NotificationModel>? get notifications => _notifications;
}