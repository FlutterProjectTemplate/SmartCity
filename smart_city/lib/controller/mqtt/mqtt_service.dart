import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? _client;
  final String _broker = 'broker.emqx.io';
  final String _clientIdentifier = 'flutter_client';
  final int _port = 1883;

  final StreamController<String> _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  Future<bool> connect() async {
    _client = MqttServerClient.withPort(_broker, _clientIdentifier, _port);
    _client!.logging(on: true);
    _client!.keepAlivePeriod = 60;
    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onSubscribed = _onSubscribed;
    _client!.onSubscribeFail = _onSubscribeFail;
    _client!.pongCallback = _pong;

    final connMessage = MqttConnectMessage()
        .authenticateAs("username", "password")
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
    } catch (e) {
      print('Exception: $e');
      _client!.disconnect();
      return false;
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected');
      _client!.subscribe("#", MqttQos.atLeastOnce);
    } else {
      print('MQTT client connection failed - disconnecting, status is ${_client!.connectionStatus}');
      _client!.disconnect();
      return false;
    }

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMessage = c![0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
      _messageController.add('${c[0].topic}: $payload');
    });

    return true;
  }

  void disconnect() {
    _client?.disconnect();
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void _onConnected() {
    print('Connected');
  }

  void _onDisconnected() {
    print('Disconnected');
  }

  void _onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

  void _onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

  void _pong() {
    print('Ping response client callback invoked');
  }

  void dispose() {
    _messageController.close();
  }
}