import 'package:flutter/material.dart';

import '../../controller/mqtt/mqtt_service.dart';

class MqttScreen extends StatefulWidget {
  @override
  _MqttScreenState createState() => _MqttScreenState();
}

class _MqttScreenState extends State<MqttScreen> {
  final MqttService mqttService = MqttService();
  bool isConnected = false;
  String statusText = "Disconnected";
  List<String> messages = [];
  TextEditingController topicController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mqttService.messageStream.listen((message) {
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    mqttService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MQTT Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Status: $statusText'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnected ? disconnect : connect,
              child: Text(isConnected ? 'Disconnect' : 'Connect'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: topicController,
              decoration: InputDecoration(labelText: 'Topic'),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isConnected ? publishMessage : null,
              child: Text('Publish'),
            ),
            SizedBox(height: 20),
            Text('Received Messages:'),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> connect() async {
    setState(() {
      statusText = "Connecting...";
    });

    bool connected = await mqttService.connect();

    setState(() {
      isConnected = connected;
      statusText = connected ? "Connected" : "Connection failed";
    });
  }

  void disconnect() {
    mqttService.disconnect();
    setState(() {
      isConnected = false;
      statusText = "Disconnected";
    });
  }

  void publishMessage() {
    if (isConnected) {
      final topic = topicController.text;
      final message = messageController.text;

      mqttService.publishMessage(topic, message);

      setState(() {
        messages.add('Published: $topic - $message');
      });

      // Clear the message input field after publishing
      messageController.clear();

      // Show a snackbar to confirm the message was published
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message published to $topic')),
      );
    } else {
      // Show an error message if not connected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Not connected to MQTT broker')),
      );
    }
  }
}