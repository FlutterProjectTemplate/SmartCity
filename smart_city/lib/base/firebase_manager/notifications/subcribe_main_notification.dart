import 'package:firebase_messaging/firebase_messaging.dart';

abstract class SubscribeMainNotification {
  void subscribe(ListenMainNotification subscription) {}
  void unsubscribe(ListenMainNotification subscription) {}
}

abstract class ListenMainNotification {
  void receiveMessage(RemoteMessage message) {}
}