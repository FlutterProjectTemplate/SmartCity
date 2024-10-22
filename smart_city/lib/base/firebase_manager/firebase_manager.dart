import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_city/base/utlis/file_utlis.dart';
import 'package:smart_city/model/user/user_info.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'firebase_options.dart';
import 'package:smart_city/base/firebase_manager/notifications/local_notifications.dart';
import 'package:smart_city/base/firebase_manager/notifications/main_notifications.dart';

enum SystemsTopic{
  navitrackNews,
  navitrackSystem,
}
class FirebaseManager {
  static final FirebaseManager _singletonFirebaseManager = FirebaseManager._internal();
  static FirebaseManager get getInstance => _singletonFirebaseManager;
  factory FirebaseManager() {
    return _singletonFirebaseManager;
  }
  final String navitrackTopicPre = "evCharger-";
  List<String> fcmSubscribeTopicNameList = List.empty(growable: true);
  final Map<SystemsTopic, String> systemsTopicName = {
    SystemsTopic.navitrackNews: "evCharger-news",
    SystemsTopic.navitrackSystem: "evCharger-system"
  };

  String? fcmToken = "";

  FirebaseManager._internal();


  Future<NotificationSettings> requestFireBasePermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    return settings;
  }

  Future<void> initialFirebase() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await MainNotification.getInstance.startFirebase(DefaultFirebaseOptions.currentPlatform);
    await startFirebaseCrashlytics();
    await LocalNotification().initialLocalNotification();
  }

  Future<void> startFirebaseCrashlytics() async {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  Future<void> startFirebaseMessaging() async {
    if(fcmToken!=null && fcmToken!.isNotEmpty) {
      return;
    }
    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await requestFireBasePermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // TODO: handle the received notifications
      FileUtils.printLog('User granted permission');
      fcmToken = await FirebaseMessaging.instance.getToken();
    } else {
      FileUtils.printLog('User declined or has not accepted permission');
    }

    /// khi inintal firebase, luon bat subscribe cho cacs system topic
    List<String> fcmSubscribeTopicNameListTemp = [...fcmSubscribeTopicNameList];
    fcmSubscribeTopicNameListTemp.addAll(systemsTopicName.values);
    fcmSubscribeTopicNameList =  Set.of(fcmSubscribeTopicNameListTemp).toList();
    await _fcmSubscribeMultiTopic(fcmSubscribeTopicNameList);
  }
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);

    FileUtils.printLog("Handling a background message: ${message.messageId}");
  }

  Future<void> _fcmSubscribeTopic(String topicName) async {
    if(fcmToken==null) /// chua initial firebase
    {
      await startFirebaseMessaging();
    }
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topicName);
    }
    catch(e){
      FileUtils.printLog("firebase sub error ${e.toString()}");
    }
  }
  Future<void> _fcmUnSubscribeTopic(String topicName) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topicName);
    }
    catch(e){
      FileUtils.printLog("firebase unsub error ${e.toString()}");
    }
  }

  Future<void> _fcmSubscribeMultiTopic(List<String> topicNames) async {
    try{
      if(topicNames.isEmpty) {
        return;
      }
      for(String topicName in topicNames)
      {
        await _fcmSubscribeTopic(topicName);
      }
    }
    catch(e)
    {
      FileUtils.printLog(e.toString());
    }

  }

  Future<void> _fcmUnSubscribeMultiTopic(List<String> topicNames) async {
    if(topicNames.isEmpty) {
      return;
    }
    try {
      for (String topicName in topicNames) {
        await _fcmUnSubscribeTopic(topicName);
      }
    }
    catch(e)
    {
      debugPrint(e.toString());
    }
  }

  Future<void> fcmListenerFromFirebaseTopics(Function(RemoteMessage)? onReceivedData) async {
    // lisstener firebase message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(onReceivedData!=null) {
        onReceivedData(message);
      }
    });
  }

  /// moi khi replace/ add/ remove 1 topic, thi can unsubscribe tat ca topic va subscribe lai
  Future<void> replaceSubscribeTopic(String oldTopic, String newTopic) async {
    await _fcmUnSubscribeMultiTopic(fcmSubscribeTopicNameList);
    List<String> fcmSubscribeTopicNameListTemp = [...fcmSubscribeTopicNameList];
    if(fcmSubscribeTopicNameListTemp.contains(oldTopic)) {}
    {
      fcmSubscribeTopicNameListTemp.remove(oldTopic);
    }

    if(!fcmSubscribeTopicNameListTemp.contains(newTopic))
    {

      fcmSubscribeTopicNameListTemp.add(newTopic);
    }
    fcmSubscribeTopicNameListTemp =  Set.of(fcmSubscribeTopicNameListTemp).toList();
    fcmSubscribeTopicNameList = fcmSubscribeTopicNameListTemp;
    await _fcmSubscribeMultiTopic(fcmSubscribeTopicNameList);
    await fcmListenerFromFirebaseTopics(LocalNotification().showSystemNotify);

  }

  Future<void> addNewSubscribeTopic(String newTopic) async {
    newTopic = navitrackTopicPre + newTopic;
    if(!fcmSubscribeTopicNameList.contains(newTopic))
    {
      fcmSubscribeTopicNameList.add(newTopic);
      await _fcmSubscribeTopic(newTopic);
      await fcmListenerFromFirebaseTopics(LocalNotification().showSystemNotify);
    }
  }
  Future<void> addNewSubscribeUserTopic() async {
    removeAllSubscribeTopicButKeepSystemTopic();
    UserInfo? userInfo = SqliteManager.getInstance.getCurrentSelectUserInfo();
    FirebaseManager.getInstance.addNewSubscribeTopic(userInfo!.userId!);

  }
  Future<void> removeSubscribeTopic(String topic) async {
    topic = navitrackTopicPre +  topic;
    if(fcmSubscribeTopicNameList.contains(topic)) {}
    {
      await _fcmUnSubscribeTopic(topic);
      fcmSubscribeTopicNameList.remove(topic);
    }
  }
  Future<void> removeAllSubscribeTopicButKeepSystemTopic() async {
    await _fcmUnSubscribeMultiTopic(fcmSubscribeTopicNameList);
    List<String> fcmSubscribeTopicNameListTemp = [...systemsTopicName.values];
    fcmSubscribeTopicNameListTemp =  Set.of(fcmSubscribeTopicNameListTemp).toList();
    fcmSubscribeTopicNameList =  fcmSubscribeTopicNameListTemp;
    await _fcmSubscribeMultiTopic([...fcmSubscribeTopicNameListTemp]);
    await fcmListenerFromFirebaseTopics(LocalNotification().showSystemNotify);
  }

  Future<void> resetWithNewTopic(String newTopic) async {
    newTopic = navitrackTopicPre+ newTopic;

    await removeAllSubscribeTopicButKeepSystemTopic();
    List<String> fcmSubscribeTopicNameListTemp = [...fcmSubscribeTopicNameList];
    fcmSubscribeTopicNameListTemp.add(newTopic);
    fcmSubscribeTopicNameList =  Set.of(fcmSubscribeTopicNameListTemp).toList();
    await _fcmSubscribeMultiTopic([...fcmSubscribeTopicNameList]);
  }


}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
