import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_city/base/firebase_manager/firebase_manager.dart';
import 'package:smart_city/base/utlis/file_utlis.dart';



class LocalNotification {
  static final LocalNotification _singletonLocalNotification = LocalNotification._internal();
  static LocalNotification get getInstance => _singletonLocalNotification;
  factory LocalNotification() {
    return _singletonLocalNotification;
  }
  LocalNotification._internal();

  static late AndroidNotificationChannel channel;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
  static int foregroundServiceNotificationId= 888;

  static final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();
  String? selectedNotificationPayload;

  /// A notification action which triggers a url launch event
  String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  String darwinNotificationCategoryPlain = 'plainCategory';
  final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
  Future<void> initialLocalNotification() async{
    WidgetsFlutterBinding.ensureInitialized();
    _isAndroidPermissionGranted();
    _requestPermissions();
    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
    <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: darwinNotificationCategories,
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    //showSystemNotify(null);
  }
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    FileUtils.printLog('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      FileUtils.printLog(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }
  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      // final bool? granted = await androidImplementation?.requestPermission();
    }
  }

  Future<void> showLocalNotification() async {
      flutterLocalNotificationsPlugin.show(
          foregroundServiceNotificationId,
          "SmartCity will continue to receive your location even when you aren't using it",
          "SmartCity in Background",
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
            ),
          ),
      );
    }
  Future<void> showSystemNotify() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          description:
          'This channel is used for important notifications.', // description
          importance: Importance.max,
        );
        await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
        flutterLocalNotificationsPlugin.show(
            foregroundServiceNotificationId,
            "SmartCity will continue to receive your location even when you aren't using it",
            "SmartCity in Background",
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: "SmartCity will continue to receive your location even when you aren't using it",
              ),
            ));
    }
}
