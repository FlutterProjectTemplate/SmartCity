import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/tracking_event/tracking_event.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/model/user/user_info.dart';
import 'package:typed_data/typed_buffers.dart';

import '../base/instance_manager/instance_manager.dart';
import '../base/utlis/file_utlis.dart';
import '../model/vector_status/vector_status.dart';

enum DeviceCommandTemplate {
  onKeepAliveSubTopic,
  offKeepAliveSubTopic,
}

enum MqttPackageType {
  none,
  realTime,
  /// realtime = 2
}

Map<DeviceCommandTemplate, String> keepAliveCommand = {
  DeviceCommandTemplate.onKeepAliveSubTopic: "#R14 realtime_on.*",
  DeviceCommandTemplate.offKeepAliveSubTopic: "#R14 realtime_off.*",
};

class MqttServerClientObject {
  MqttServerClient? mqttServerClient;
  List<String?>? subTopicName;
  List<String?>? pubTopicNames;
  String clientId = "";
  String? username;
  String? password;
  bool? needKeepAlive = false;
  MqttQos? mqttQos;
  void Function(String)? onConnected;
  void Function(String topic)? onSubscribed;
  void Function()? onDisconnected;
  void Function(String topic)? onSubscribeFail;

  void Function()? pongCallback;
  void Function(dynamic)? onRecivedData;
  bool? isReceivedRawData;


  /// call back ve raw data string
  MqttServerClientObject(
      {this.mqttServerClient,
      required this.subTopicName,
      this.username,
      this.password,
      this.onConnected,
      this.onSubscribed,
      this.onSubscribeFail,
      this.onDisconnected,
      this.pongCallback,
      this.onRecivedData,
      this.isReceivedRawData,
      this.pubTopicNames,
      this.needKeepAlive,
      required this.clientId,
      this.mqttQos}) {
    username = 'mqtt';
    password = '123456a@';
    needKeepAlive ??= true;
    isReceivedRawData ??= false;
    mqttQos ??= MqttQos.atMostOnce;
  }
}

class MQTTManager {
  static final MQTTManager _singletonMQTTManager = MQTTManager._internal();
  static MQTTManager get getInstance => _singletonMQTTManager;
  final String parentTopic = "hrm.location";

  factory MQTTManager() {
    return _singletonMQTTManager;
  }
  MQTTManager._internal();

  Timer? dummyDataTimer;
  bool reciveServiceEvent = false;
  String? server =  "broker.smartcitysignals.com";//"broker.stouch.vn";;"broker.mqtt.cool";//;
  final int? mqttPort = 1883;
  final String clientIdentifierPreChar = "smct.location_mobile_";
  int? port = 1883;
  final Map<String, MqttServerClientObject> _mqttServerClientInTopicList = <String, MqttServerClientObject>{};
  MqttServerClientObject? mqttServerClientObject;
  bool _receiveFirstData = false;

  void initialMQTT({String? server, int? port}) {
    if (port == null || port == 0) {
      this.port = mqttPort;
    }
    if (server == null || server.isEmpty) {
      this.server = "broker.smartcitysignals.com";//"broker.smartcitysignals.com"; //"broker.stouch.vn"; "broker.mqtt.cool";//"navitrack.camdvr.org";
    }
  }

  Future<String> initClientId() async {
    UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();
    var rng = Random();
    String clientIdentifier = "$clientIdentifierPreChar${userInfo!.userId!}_${rng.nextInt(10000)}";
    return clientIdentifier;
  }

  Future<MqttServerClientObject?> initialMQTTTrackingTopicByUser(
      {
        void Function(dynamic)? onRecivedData,
        void Function(String)? onConnected,
        bool? receivedRawData,
      }) async {
    MQTTManager.getInstance.disconnectAndRemoveAllTopic();
    TimerManager.getInstance.stopTimer(timerKey: TimerManager().keepAliveTrackingTimerKey);


    // UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    // CustomerModel? customerModel = SqliteManager().getCurrentCustomerDetail();
    String topicNameSendLocation = "device/${userDetail?.customerId??1}/${userDetail?.id}/location";
    List<String> topicNameReceived = [
    "device/${userDetail?.customerId??1}/${userDetail?.id}/event",
     "device/${userDetail?.customerId??1}/+/vector_status"
    ];

    List<String> pubTopics = [topicNameSendLocation, ];
    String clientId = await initClientId();
    MqttServerClientObject newMqttServerClientObject = MqttServerClientObject(
        subTopicName: topicNameReceived,
        pubTopicNames: pubTopics,
        clientId: clientId,
        isReceivedRawData: receivedRawData ?? false,
        onSubscribeFail: (msg) {
          FileUtils.printLog(msg);
        },
        onConnected: (connectInfo) {
          FileUtils.printLog("mqtt connected");
          if (onConnected != null) {
            onConnected(connectInfo);
          }
        },
        onSubscribed: (msg) {
          FileUtils.printLog(msg);
        },
        onDisconnected: () {
          FileUtils.printLog("mqtt disconnected");
        },
        onRecivedData: onRecivedData);
    try {
      return await MQTTManager.getInstance.connectToNewTopic(newMqttServerClientObject);
    } catch (e) {
      return null;
      //throw Exception(e.toString());
    }
  }

  Future<String> getDeviceCommandTrackingSubTopic() async {
    UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();
    String topicName = "$parentTopic.${(userInfo?.userId ?? '').toString()}.${(userInfo?.userId ?? '').toString()}";
    return topicName;
  }

  void replaceConnectedTopic(String? oldTopic, MqttServerClientObject newMqttServerClientObject) {
    try {
      removeConnectTopic(oldTopic);
      connectToNewTopic(newMqttServerClientObject);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void removeConnectTopicWithMqttServerClientObject(MqttServerClientObject newMqttServerClientObject) {
    try {
      if (_mqttServerClientInTopicList.keys.contains(newMqttServerClientObject.clientId)) {
        for (String? subTopic in newMqttServerClientObject.subTopicName!) {
          _mqttServerClientInTopicList[newMqttServerClientObject.clientId]!.mqttServerClient!.unsubscribe(subTopic!);
        }

        _mqttServerClientInTopicList[newMqttServerClientObject.clientId]!.mqttServerClient!.disconnect();
        _mqttServerClientInTopicList.remove(_mqttServerClientInTopicList[newMqttServerClientObject.clientId]);
        if (_mqttServerClientInTopicList.isEmpty) {
          return;
        }
      }
    } catch (e) {
      throw Exception('removeConnectTopic: ${e.toString()}');
    }
  }

  void removeConnectTopic(String? removeTopic) {
    try {
      if (_mqttServerClientInTopicList.keys.contains(removeTopic)) {
        _mqttServerClientInTopicList[removeTopic]!.mqttServerClient!.unsubscribe(removeTopic!);
        _mqttServerClientInTopicList[removeTopic]!.mqttServerClient!.disconnect();
        _mqttServerClientInTopicList.remove(_mqttServerClientInTopicList[removeTopic]);
        if (_mqttServerClientInTopicList.isEmpty) {
          return;
        }
      }
    } catch (e) {
      throw Exception('removeConnectTopic: ${e.toString()}');
    }
  }

  Future<MqttServerClientObject> connectToNewTopic(MqttServerClientObject newMqttServerClientObject) async {
    if (_mqttServerClientInTopicList.keys.contains(newMqttServerClientObject.clientId)) {
      try {
        for (String? subTopicName in _mqttServerClientInTopicList[newMqttServerClientObject.clientId]!.subTopicName!) {
          unsubscribeTopic(newMqttServerClientObject, subTopicName!);
        }
      } catch (e) {
        FileUtils.printLog(e.toString());
      }
    }
    newMqttServerClientObject.mqttServerClient = await connectOneTopic(newMqttServerClientObject);
    _mqttServerClientInTopicList[newMqttServerClientObject.clientId] = newMqttServerClientObject;
    return newMqttServerClientObject;
  }

  MqttServerClientObject? getMqttServerClientByClientId(String clientId) {
    return _mqttServerClientInTopicList[clientId];
  }

  void unsubscribeTopic(MqttServerClientObject newMqttServerClientObject, String topicName) {
    _mqttServerClientInTopicList[newMqttServerClientObject.clientId]!.mqttServerClient!.unsubscribe(topicName);
    _mqttServerClientInTopicList[newMqttServerClientObject.clientId]!.mqttServerClient!.disconnect();
  }

  void unsubscribeAllTopic() {
    for (String clientId in _mqttServerClientInTopicList.keys) {
      for (String? subTopicName in _mqttServerClientInTopicList[clientId]!.subTopicName!) {
        _mqttServerClientInTopicList[clientId]!.mqttServerClient!.unsubscribe(subTopicName!);
      }
      _mqttServerClientInTopicList[clientId]!.mqttServerClient!.disconnect();
    }
  }

  void disconnectAllTopic() {
    dummyDataTimer?.cancel();
    if (_mqttServerClientInTopicList.isEmpty) {
      return;
    }
    for (String clientId in _mqttServerClientInTopicList.keys) {
      try {
        if (_mqttServerClientInTopicList[clientId] != null) {
          keepAliveTrackingTopic(_mqttServerClientInTopicList[clientId]!, false);
        }
        _mqttServerClientInTopicList[clientId]!.mqttServerClient!.unsubscribe(clientId);
        _mqttServerClientInTopicList[clientId]!.mqttServerClient!.disconnect();
        if (_mqttServerClientInTopicList.isEmpty) {
          return;
        }
      } catch (e) {
        FileUtils.printLog(e.toString());
      }
    }
    _mqttServerClientInTopicList.clear();
    TimerManager.getInstance.stopTimer(
      timerKey: TimerManager.getInstance.keepAliveTrackingTimerKey,
    );
  }

  Future<void> connectAllExitsTopic() async {
    for (String clientId in _mqttServerClientInTopicList.keys) {
      MqttServerClientObject mqttServerClientObject = _mqttServerClientInTopicList[clientId]!;
      _mqttServerClientInTopicList[clientId]!.mqttServerClient = (await connectOneTopic(mqttServerClientObject))!;
    }
  }

  void disconnectAndRemoveAllTopic() {
    dummyDataTimer?.cancel();
    dummyDataTimer = null;
    try{
    for (String clientId in _mqttServerClientInTopicList.keys) {

      for (String? subTopic in _mqttServerClientInTopicList[clientId]?.subTopicName??[]) {
        print("subTopic:${subTopic}");

          _mqttServerClientInTopicList[clientId]?.mqttServerClient?.unsubscribe(subTopic??"");
      }
      _mqttServerClientInTopicList[clientId]?.mqttServerClient?.disconnect();
    }
    mqttServerClientObject?.mqttServerClient?.disconnect();
    }
    catch(e)
    {
      print(e);
    }
    _mqttServerClientInTopicList.clear();

  }

  /// keepAlive:
  void keepAliveTrackingTopic(MqttServerClientObject newMqttServerClientObject, bool keepAlive) {
    if (newMqttServerClientObject.needKeepAlive??false) {
      return;
    }
    if (newMqttServerClientObject.pubTopicNames != null && (newMqttServerClientObject.pubTopicNames??[]).isEmpty) {
      return;
    }
    for (String? pubTopicName in newMqttServerClientObject.pubTopicNames??[]) {
      String command = keepAlive ? keepAliveCommand[DeviceCommandTemplate.onKeepAliveSubTopic]! : keepAliveCommand[DeviceCommandTemplate.offKeepAliveSubTopic]!;
      List<int> bytes = utf8.encode(command);
      Uint8List uint8List = Uint8List.fromList(bytes);
      Uint8Buffer dataBuffer = Uint8Buffer();
      dataBuffer.addAll(uint8List);
      newMqttServerClientObject.mqttServerClient!.publishMessage(pubTopicName!, MqttQos.atMostOnce, dataBuffer);
    }

    TimerManager.getInstance.startTimer(
      timerKey: TimerManager.getInstance.keepAliveTrackingTimerKey,
      duration: const Duration(seconds: 30),
      callback: (p0) {
        for (String? pubTopicName in newMqttServerClientObject.pubTopicNames??[]) {
          String command = keepAlive ? keepAliveCommand[DeviceCommandTemplate.onKeepAliveSubTopic]! : keepAliveCommand[DeviceCommandTemplate.offKeepAliveSubTopic]!;
          List<int> bytes = utf8.encode(command);
          Uint8List uint8List = Uint8List.fromList(bytes);
          Uint8Buffer dataBuffer = Uint8Buffer();
          dataBuffer.addAll(uint8List);
          newMqttServerClientObject.mqttServerClient!.publishMessage(pubTopicName!, MqttQos.atMostOnce, dataBuffer);
        }
      },
    );
  }

  Future<void> sendMessageToATopic(
      {
        required MqttServerClientObject? newMqttServerClientObject,
        String? specialTopic,/// gui message toi topic cu the
        required String message,
        void Function(String)? onCallbackInfo,
        void Function()? onError
      }) async {
    List<int> bytes = utf8.encode(message);
    Uint8List uint8List = Uint8List.fromList(bytes);
    Uint8Buffer dataBuffer = Uint8Buffer();
    dataBuffer.addAll(uint8List);
    if(specialTopic!=null){
      int? msgId = newMqttServerClientObject?.mqttServerClient?.publishMessage(specialTopic, newMqttServerClientObject.mqttQos ?? MqttQos.atMostOnce, dataBuffer);
      String logInfo = "server: $server, port: $port, \n pubTopicName: $specialTopic, \n  msgId: $msgId ";
      if (onCallbackInfo != null) {
        onCallbackInfo(logInfo);
      }
    }
    else /// neu khong pub vao topic cu the, thif gui toi tat ca pub topic da dang ky
    {
      for (String? pubTopicName in newMqttServerClientObject?.pubTopicNames??[]) {
        if(newMqttServerClientObject?.mqttServerClient?.connectionStatus?.state == MqttConnectionState.connected)
        {
          int? msgId = newMqttServerClientObject?.mqttServerClient?.publishMessage(pubTopicName!, newMqttServerClientObject.mqttQos ?? MqttQos.atMostOnce, dataBuffer);
          String logInfo = "server: $server, port: $port, \n pubTopicName: $pubTopicName, \n  msgId: $msgId ";
          if (onCallbackInfo != null) {
            onCallbackInfo(logInfo);
          }
        }

      }
    }

  }

  Future<MqttServerClient?> connectOneTopic(MqttServerClientObject newMqttServerClientObject) async {
    if (server == null || port == null) {
      FileUtils.printLog('you need initial MQTT with server, clientIdentifier, port');
      return null;
    }
    MqttServerClient client = MqttServerClient.withPort(server!, newMqttServerClientObject.clientId, port!);
    client.logging(on: true);
    client.onConnected = () {
      keepAliveTrackingTopic(newMqttServerClientObject, true);
      String connectInfo = "Server: $server \n Port: $port \n ClientId: ${newMqttServerClientObject.clientId} ";
      newMqttServerClientObject.onConnected!(connectInfo);
    };
    client.onDisconnected = newMqttServerClientObject.onDisconnected;
    client.onSubscribed = newMqttServerClientObject.onSubscribed;
    client.onSubscribeFail = newMqttServerClientObject.onSubscribeFail;
    client.pongCallback = newMqttServerClientObject.pongCallback;
    client.setProtocolV311();
    client.keepAlivePeriod = 60;
    final connMessage = MqttConnectMessage()
        .authenticateAs(newMqttServerClientObject.username, newMqttServerClientObject.password)
        .withClientIdentifier(newMqttServerClientObject.clientId)
        .startClean()
        .withWillQos(newMqttServerClientObject.mqttQos ?? MqttQos.atMostOnce);
    client.connectionMessage = connMessage;
    newMqttServerClientObject.mqttServerClient = client;
    try {
      _receiveFirstData = false;
      await client.connect();
      /// Check we are connected
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        FileUtils.printLog('EXAMPLE::Mosquitto client connected');
      } else {
        FileUtils.printLog('EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
        client.disconnect();
      }
      if (newMqttServerClientObject.isReceivedRawData!) {
        for (String? subTopic in newMqttServerClientObject.subTopicName!) {
          client.subscribe(subTopic!, newMqttServerClientObject.mqttQos ?? MqttQos.atMostOnce);
          String subscribeInfo = "Subscribe to Topic: $subTopic";
          newMqttServerClientObject.onConnected!(subscribeInfo);
        }
        client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          // Handle incoming messages here
          if (c.isEmpty || c.elementAt(0).topic.isEmpty) {
            return;
          }
          c.elementAt(0).topic.split('/').elementAt(3);
          final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
          String payloadString = utf8.decode(message.payload.message);
          if(_receiveFirstData)
          {
            newMqttServerClientObject.onRecivedData!(payloadString);
          }
          else
          {
            _receiveFirstData = true;
          }
          FileUtils.printLog('topic is <${c[0].topic}>, payload is <-- $payloadString -->');
        });
      } else {
        for (String? subTopic in newMqttServerClientObject.subTopicName!) {
          client.subscribe(subTopic!, newMqttServerClientObject.mqttQos ?? MqttQos.atMostOnce);
          String subscribeInfo = "Subscribe to Topic: $subTopic";
          newMqttServerClientObject.onConnected!(subscribeInfo);
          // Create the topic filter
          final topicFilter = MqttClientTopicFilter(subTopic, client.updates);
          // Now listen on the filtered updates, not the client updates

          dummyDataTimer = Timer.periodic(Duration(seconds: 20,), (timer) {
            if (dummyDataTimer == null) {
              timer.cancel();
              return;
            }
            TrackingEventInfo trackingEventInfo = TrackingEventInfo(
                options: [
                  Options(
                      index: 0,
                      channelName: "Option1",
                      isDummy: false,
                      channelId: 1
                  )
                ],
                state: 1,
                currentCircle: 5,
                vectorId: 91,
                vectorEvent: 2,
                nodeName: "Văn phòng FFT Solution, 178 Thái hà",
                nodeId: 765,
                userId: 124,
                virtualDetectorState: VirtualDetectorState.Processing,
                geofenceEventType: GeofenceEventType.StillInside
            );
            TrackingEventInfo trackingServceEventInfo = TrackingEventInfo(
                options: [
                  Options(index: 1, channelName: "Turn right"),
                  Options(index: 2, channelName: "Turn left"),
                  Options(index: 3, channelName: "Go straight"),
                ],
                state: 2,
                currentCircle: 5,
                vectorId: 91,
                vectorEvent: 2,
                nodeName: "Văn phòng FFT Solution, 178 Thái hà",
                nodeId: 765,
                userId: 124,
                virtualDetectorState: VirtualDetectorState.Processing,
                geofenceEventType: GeofenceEventType.StillInside
            );

            if (reciveServiceEvent)
              {
                newMqttServerClientObject.onRecivedData!(jsonEncode(trackingServceEventInfo.toJson()));
              }
            else
              {
                newMqttServerClientObject.onRecivedData!(jsonEncode(trackingEventInfo.toJson()));

              }
             reciveServiceEvent = !reciveServiceEvent;

            ///dummy vector status

            // count++;
            //
            // if (count == 1) {
            //   VectorStatusInfo vectorStatus = VectorStatusInfo(
            //       vectorId: 70,
            //       customerId: 0,
            //       totalUser: 2,
            //       processUser: 2,
            //       serviceUser: 0,
            //       vectorStatus: 1,
            //       updatedAt: '2024-11-19T17:05:40.00955+07:00');
            //   newMqttServerClientObject.onRecivedData!(jsonEncode(vectorStatus.toJson()));
            // }
            //
            // if (count == 5) {
            //   VectorStatusInfo vectorStatus1 = VectorStatusInfo(
            //       vectorId: 70,
            //       customerId: 0,
            //       totalUser: 2,
            //       processUser: 2,
            //       serviceUser: 0,
            //       vectorStatus: 2,
            //       updatedAt: '2024-11-19T17:05:40.00955+07:00');
            //   newMqttServerClientObject.onRecivedData!(jsonEncode(vectorStatus1.toJson()));
            // }
          },);
          topicFilter.updates.listen((List<MqttReceivedMessage<MqttMessage?>> c) {
            if (c.isEmpty || c.elementAt(0).topic.isEmpty) {
              return;
            }
            final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
            String payloadString = utf8.decode(message.payload.message);
            FileUtils.printLog('topic is <${c[0].topic}>, payload is <-- $payloadString -->');
            if(_receiveFirstData)
              {
                newMqttServerClientObject.onRecivedData!(payloadString);
              }
            else
              {
                _receiveFirstData = true;
              }
            //List<dynamic> payloadStringList = payloadString.split("|");
/*            if (payloadStringList.elementAt(0).toString().length > 4)

            /// do dai >4 thi khong phai loai du lieu da define
            {
              return;
            }
            int packageIntValue = int.parse(payloadStringList.elementAt(0));
            if (packageIntValue < MqttPackageType.values.length) {
              c.elementAt(0).topic.split('/').elementAt(2);
              // MQTTPackandler.GetInstance().decodePackByType( payloadString, imei, mqtt_packtype, newMqttServerClientObject.onRecivedData);
              //MQTTPackageHandler().decodePackByType(payloadStringList, imei, mqtt_packtype, newMqttServerClientObject.onRecivedData);
            }*/
          });
        }
      }
    } catch (e) {
      FileUtils.printLog('Exception: $e');
      client.disconnect();
      throw Exception('Failed to connect MQTTT topic: ${e.toString()}');
    }

    return client;
  }
}
