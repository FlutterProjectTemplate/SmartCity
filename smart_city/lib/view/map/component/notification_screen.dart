
/*@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  static const String notificationCommand = 'haveNotification';

  int _count = 0;

  void _checkNotification() {
    _count++;

    FlutterForegroundTask.updateService(
      notificationTitle: 'You have notifications',
      notificationText: 'Notification content',
    );
    FlutterForegroundTask.sendDataToMain(_count);
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    if (kDebugMode) {
      print('onStart(starter: ${starter.name})');
    }
    _checkNotification();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // _checkNotification();
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    if (kDebugMode) {
      print('onDestroy');
    }
  }

  @override
  void onReceiveData(Object data) {
    if (kDebugMode) {
      print('onReceiveData: $data');
    }
    if (data == notificationCommand) {
      _checkNotification();
    }
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (kDebugMode) {
      print('onNotificationButtonPressed: $id');
    }
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
    if (kDebugMode) {
      print('onNotificationPressed');
    }
  }

  @override
  void onNotificationDismissed() {
    if (kDebugMode) {
      print('onNotificationDismissed');
    }
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ValueNotifier<Object?> _receivedTaskData = ValueNotifier(null);
  late List<NotificationModel> notifications;
  double opacityLevel = 1;
  final Duration _animationDuration = const Duration(milliseconds: 500);

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
      if (kDebugMode) {
        print("Service is already running.");
      }
      return FlutterForegroundTask.restartService();
    } else {
      if (kDebugMode) {
        print("Starting the service...");
      }
      return FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        notificationIcon: null,
        callback: startCallback,
      );
    }
  }

  Future<ServiceRequestResult> _stopService() async {
    return FlutterForegroundTask.stopService();
  }

  void _onReceiveTaskData(Object data) {
    _receivedTaskData.value = data;
    if (kDebugMode) {
      print('onReceiveTaskData: $data');
    }
  }

  void _incrementCount() {
    FlutterForegroundTask.sendDataToTask(MyTaskHandler.notificationCommand);
    if (kDebugMode) {
      print("Incrementing count...");
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initService();
    });

    notifications = NotificationManager.instance.notifications ?? [];
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    _receivedTaskData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _clearNotifications();
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: NoNotification(
              title: 'No notifcations',
            ))
          : AnimatedOpacity(
              opacity: opacityLevel,
              duration: _animationDuration,
              onEnd: () {
                setState(() {
                  notifications.clear();
                });
              },
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Stack(children: [
                    Positioned(
                      right: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 100,
                        color: Colors.transparent,
                        child: DragTarget(
                          onWillAcceptWithDetails: (data) => true,
                          onAcceptWithDetails: (data) {
                            setState(() {
                              notifications.removeAt(index);
                            });
                          },
                          builder: (context, candidateData, rejectedData) {
                            return SizedBox();
                          },
                        ),
                      ),
                    ),
                    Draggable(
                        data: index,
                        axis: Axis.horizontal,
                        childWhenDragging: const SizedBox(
                          height: 100,
                        ),
                        feedback: Material(child: dragItem(index)),
                        child: dragItem(index)),
                  ]);
                },
              ),
            ),
    );
  }

  Widget dragItem(int index) {
    return Card(
      elevation: 2,
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                notifications[index].msg!,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${notifications[index].dateTime}',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearNotifications() {
    setState(() {
      // opacityLevel = List.filled(notifications.length, 0);
      opacityLevel = 0;
    });
    Future.delayed(_animationDuration, () {
      NotificationManager.instance.clearNotifications();
      // notifications.clear();
    });
  }
}*/
