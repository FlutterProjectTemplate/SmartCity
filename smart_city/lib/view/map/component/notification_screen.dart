import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/model/notification/notification.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}


class MyTaskHandler extends TaskHandler {
  static const String notificationCommand = 'haveNotification';

  int _count = 0;

  void _checkNotification() {
    _count++;

    // Update notification content.
    FlutterForegroundTask.updateService(
      notificationTitle: 'You have notifications',
      notificationText: 'Notification content',
    );
    // Send data to main isolate.
    FlutterForegroundTask.sendDataToMain(_count);
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('onStart(starter: ${starter.name})');
    _checkNotification();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _checkNotification();
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print('onDestroy');
  }

  // Called when data is sent using [FlutterForegroundTask.sendDataToTask].
  @override
  void onReceiveData(Object data) {
    print('onReceiveData: $data');
    if (data == notificationCommand) {
      _checkNotification();
    }
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed: $id');
  }

  // Called when the notification itself is pressed.
  //
  // AOS: "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted
  // for this function to be called.
  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
    print('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  //
  // AOS: only work Android 14+
  // iOS: only work iOS 10+
  @override
  void onNotificationDismissed() {
    print('onNotificationDismissed');
  }
}
class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key, required this.notifications});

  final List<NotificationModel> notifications;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ValueNotifier<Object?> _receivedTaskData = ValueNotifier(null);

  void _initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      print("Service is already running.");
      return FlutterForegroundTask.restartService();
    } else {
      print("Starting the service...");
      return FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(id: 'btn_hello', text: 'hello'),
        ],
        callback: startCallback,
      );
    }
  }

  Future<ServiceRequestResult> _stopService() async {
    return FlutterForegroundTask.stopService();
  }

  void _onReceiveTaskData(Object data) {
    _receivedTaskData.value = data;
    print('onReceiveTaskData: $data');
  }

  void _incrementCount() {
    FlutterForegroundTask.sendDataToTask(MyTaskHandler.notificationCommand);
    print("Incrementing count...");
  }

  @override
  void initState() {
    super.initState();
    // Add a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request permissions and initialize the service.
      // _requestPermissions();
      _initService();
    });
  }

  @override
  void dispose() {
    // Remove a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    _receivedTaskData.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(widget.notifications[index].msg!)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // FloatingActionButton(
                      //   onPressed: _incrementCount,
                      //   tooltip: 'Send Notification Command',
                      //   child: Icon(Icons.add),
                      // ),
                      // FloatingActionButton(
                      //   onPressed: _startService,
                      //   tooltip: 'Start Service',
                      //   child: Icon(Icons.play_arrow),
                      // ),
                      Text('${widget.notifications[index].dateTime}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, _) {
          return const Divider(
            color: Colors.grey,
            thickness: 2,
          );
        },
        itemCount: widget.notifications.length,
      ),
    );
  }
}
