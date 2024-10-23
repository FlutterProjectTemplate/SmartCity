// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:smart_city/base/firebase_manager/model/firebase_notification_data_object.dart';
// import 'package:smart_city/base/firebase_manager/notifications/main_notifications.dart';
// import 'package:smart_city/base/utlis/file_utlis.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:smart_city/base/firebase_manager/firebase_manager.dart';
// import 'package:smart_city/base/firebase_manager/notifications/navigation_constant.dart';
// // import 'package:smart_city/base/routes/main_navigation.dart';
//
// class LocalNotification {
//   static final LocalNotification _singletonLocalNotification = LocalNotification._internal();
//   static LocalNotification get getInstance => _singletonLocalNotification;
//   factory LocalNotification() {
//     return _singletonLocalNotification;
//   }
//   LocalNotification._internal();
//
//
//   static late AndroidNotificationChannel channel;
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
//
//   static final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();
//   String? selectedNotificationPayload;
//
//   /// A notification action which triggers a url launch event
//   String urlLaunchActionId = 'id_1';
//
//   /// A notification action which triggers a App navigation event
//   String navigationActionId = 'id_3';
//
//   /// Defines a iOS/MacOS notification category for text input actions.
//   String darwinNotificationCategoryText = 'textCategory';
//
//   /// Defines a iOS/MacOS notification category for plain actions.
//   String darwinNotificationCategoryPlain = 'plainCategory';
//   final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
//   Future<void> initialLocalNotification() async{
//     WidgetsFlutterBinding.ensureInitialized();
//     _isAndroidPermissionGranted();
//     _requestPermissions();
//     /// Note: permissions aren't requested here just to demonstrate that can be
//     /// done later
//     flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
//     channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description:
//       'This channel is used for important notifications.', // description
//       importance: Importance.high,
//     );
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('app_icon');
//
//     final List<DarwinNotificationCategory> darwinNotificationCategories =
//     <DarwinNotificationCategory>[
//       DarwinNotificationCategory(
//         darwinNotificationCategoryText,
//         actions: <DarwinNotificationAction>[
//           DarwinNotificationAction.text(
//             'text_1',
//             'Action 1',
//             buttonTitle: 'Send',
//             placeholder: 'Placeholder',
//           ),
//         ],
//       ),
//       DarwinNotificationCategory(
//         darwinNotificationCategoryPlain,
//         actions: <DarwinNotificationAction>[
//           DarwinNotificationAction.plain('id_1', 'Action 1'),
//           DarwinNotificationAction.plain(
//             'id_2',
//             'Action 2 (destructive)',
//             options: <DarwinNotificationActionOption>{
//               DarwinNotificationActionOption.destructive,
//             },
//           ),
//           DarwinNotificationAction.plain(
//             navigationActionId,
//             'Action 3 (foreground)',
//             options: <DarwinNotificationActionOption>{
//               DarwinNotificationActionOption.foreground,
//             },
//           ),
//           DarwinNotificationAction.plain(
//             'id_4',
//             'Action 4 (auth required)',
//             options: <DarwinNotificationActionOption>{
//               DarwinNotificationActionOption.authenticationRequired,
//             },
//           ),
//         ],
//         options: <DarwinNotificationCategoryOption>{
//           DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
//         },
//       )
//     ];
//
//     final DarwinInitializationSettings initializationSettingsDarwin =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification:
//           (int id, String? title, String? body, String? payload) async {
//         didReceiveLocalNotificationStream.add(ReceivedNotification(
//           id: id,
//           title: title,
//           body: body,
//           payload: payload,
//         ),
//         );
//       },
//       notificationCategories: darwinNotificationCategories,
//     );
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//       macOS: initializationSettingsDarwin,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
//         await LocalNotification.onSelectNotificationCallback(notificationResponse.payload);
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );
//     //showSystemNotify(null);
//   }
//   @pragma('vm:entry-point')
//   static void notificationTapBackground(NotificationResponse notificationResponse) {
//     // ignore: avoid_print
//     FileUtils.printLog('notification(${notificationResponse.id}) action tapped: '
//         '${notificationResponse.actionId} with'
//         ' payload: ${notificationResponse.payload}');
//     if (notificationResponse.input?.isNotEmpty ?? false) {
//       // ignore: avoid_print
//       FileUtils.printLog(
//           'notification action tapped with input: ${notificationResponse.input}');
//     }
//   }
//   Future<void> _isAndroidPermissionGranted() async {
//     if (Platform.isAndroid) {
//       // final bool granted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//       //     AndroidFlutterLocalNotificationsPlugin>()
//       //     ?.areNotificationsEnabled() ??
//       //     false;
//     }
//   }
//
//   Future<void> _requestPermissions() async {
//     if (Platform.isIOS || Platform.isMacOS) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//           IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//           MacOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     } else if (Platform.isAndroid) {
//       // final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//       // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//       //     AndroidFlutterLocalNotificationsPlugin>();
//
//       // final bool? granted = await androidImplementation?.requestPermission();
//     }
//   }
//   static Future<void> onSelectNotificationCallback(String? payload) async {
//     // Hàm này thực hiện xử lý điều hướng notify cho android trường hợp app đang mở
//     if (payload != null && jsonDecode(payload)["data"] != null)
//     {
//       dynamic data = jsonDecode(payload)["data"];
//       FirebaseMessageData? firebaseRemoteMessageData = FirebaseMessageData.fromJson(jsonDecode(data));
//       NaviConstant.getInstance.isNotify = true;
//       StatusAppRunning statusAppRunning = StatusAppRunning.background;
//       //if(IdentifierConst.accessToken.isNotEmpty){
//       statusAppRunning = StatusAppRunning.foreground;
//       //}
//       handlerNavigateNotification(firebaseRemoteMessageData, statusAppRunning);
//     }
//   }
//
//   static void handlerNavigateNotification(FirebaseMessageData firebaseRemoteMessageData, StatusAppRunning? status, {BuildContext? context} ) {
//     if (status!= null) {
//       NaviConstant.getInstance.firebaseRemoteMessageData = firebaseRemoteMessageData;
//       if( status == StatusAppRunning.background) {
//         //go back login
//         // MainNavigator.getInstance.goBackLogin();
//       }
//       else{
//         NaviConstant.getInstance.handleEventTabBlock();
//       }
//     }
//   }
//
//   Future<void> showLocalNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: 'ic_launcher',
//             ),
//           ),
//           payload: message.data.isNotEmpty ? jsonEncode(message.data) : null
//       );
//     }
//   }
//   Future<void> showSystemNotify(RemoteMessage? remoteMessage) async {
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     if(remoteMessage!=null)
//     {
//       RemoteNotification? notification = remoteMessage.notification;
//       AndroidNotification? android = remoteMessage.notification?.android;
//       AppleNotification? appleNotification = remoteMessage.notification?.apple;
//       if (android != null) {
//
//         const AndroidNotificationChannel channel = AndroidNotificationChannel(
//           'high_importance_channel', // id
//           'High Importance Notifications', // title
//           description:
//           'This channel is used for important notifications.', // description
//           importance: Importance.max,
//         );
//         await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification?.title,
//             notification?.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription: channel.description,
//                 icon: android.smallIcon,
//               ),
//             ));
//       }
//       else if(appleNotification!=null)
//       {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification?.title,
//             notification?.body,
//             NotificationDetails(
//               iOS: DarwinNotificationDetails(
//                 subtitle: notification?.body,
//               ),
//             ));
//       }
//     }
//   }
//
// }