import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smart_city/base/firebase_manager/model/firebase_notification_data_object.dart';
import 'package:smart_city/base/firebase_manager/notifications/subcribe_main_notification.dart';
import 'package:smart_city/base/firebase_manager/notifications/local_notifications.dart';
import 'navigation_constant.dart';

enum StatusAppRunning {background, foreground}

class MainNotification extends SubscribeMainNotification {
  static final MainNotification _singletonMainNotification = MainNotification._internal();
  static MainNotification get getInstance => _singletonMainNotification;
  factory MainNotification() {
    return _singletonMainNotification;
  }
  MainNotification._internal();
  RemoteMessage? lastRemoteMessage;
  bool disableLocalNotification = false;
  List<ListenMainNotification> listSubscription = [];
  StatusAppRunning? status;

  Future<void> startFirebase(FirebaseOptions options) async {
    await initFirebase(options);
    setupInteractedMessage();
    // LocalNotification.initLocalNotification();
  }

  Future<FirebaseApp> initFirebase(FirebaseOptions options) async {
    return await Firebase.initializeApp(options: options);
  }

  void setupInteractedMessage() {
    getInitialMessage();
    onMessage();
    onMessageOpenApp();
  }

  //foreground message
  void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logNotification(message);
      if (!disableLocalNotification) {
        LocalNotification().showLocalNotification(message);
      }
      status = null;
      handleRemoteMessage(message);
    });
  }

  // Khi app đang ở chế độ background và app chưa bị kill sẽ chạy vào đây
  void onMessageOpenApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logNotification(message);
      // status = StatusAppRunning.background;
      //if(IdentifierConst.accessToken.isNotEmpty){
      status = StatusAppRunning.foreground;
      //}
      handleRemoteMessage(message);
    });
  }

  // app bị kill và bấm noti để mở app
  void getInitialMessage() async {
    Future.delayed(const Duration(seconds: 2),() async {
      await FirebaseMessaging.instance.getInitialMessage().then((message){
        if (message /**/!= null) {
          logNotification(message);
          status = StatusAppRunning.background;
          handleRemoteMessage(message);
        }
        else {
        }
      });
    });


  }

  void handleRemoteMessage(RemoteMessage message) {
    // Hàm này thực hiện xử lý điều hướng cho IOS
    if (message.data["data"] != null) {
      dynamic data = jsonDecode(message.data["data"]);
      NaviConstant.getInstance.isNotify = true;
      FirebaseMessageData? firebaseRemoteMessageData = FirebaseMessageData.fromJson(data);
      LocalNotification.handlerNavigateNotification(firebaseRemoteMessageData, status);
    }
    lastRemoteMessage = message;
    for (var element in listSubscription) {
      element.receiveMessage(message);
    }
  }

  // log
  void logNotification(RemoteMessage message) {
    if (message.notification != null) {
    }
  }

  @override
  void subscribe(ListenMainNotification subscription) {
    listSubscription.add(subscription);
    super.subscribe(subscription);
  }

  @override
  void unsubscribe(ListenMainNotification subscription) {
    listSubscription.remove(subscription);
    super.unsubscribe(subscription);
  }
}
