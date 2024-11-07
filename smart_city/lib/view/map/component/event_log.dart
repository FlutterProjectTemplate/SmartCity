import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/model/tracking_event/tracking_event.dart';

import '../../../constant_value/const_size.dart';
import '../../../controller/helper/map_helper.dart';
import '../../voice/stt_manager.dart';
import '../../voice/tts_manager.dart';

class EventLog extends StatefulWidget {
  const EventLog({super.key, required this.iShowEvent, required this.trackingEvent});

  final bool iShowEvent;
  final TrackingEventInfo? trackingEvent;

  @override
  State<EventLog> createState() => _EventLogState();
}

class _EventLogState extends State<EventLog> {
  VoiceManager voiceManager = VoiceManager();
  String voiceText = '';
  VoiceInputManager voiceInputManager = VoiceInputManager();
  String inputText = '';
  Color? color;
  late bool isShowEvent;

  @override
  void initState() {
    super.initState();
    isShowEvent = widget.iShowEvent;
    try {
      initTextToSpeech();
      initSpeechToText();
    } catch (e) {
      print(e.toString());
    }
  }

  void initSpeechToText() async {
    await voiceInputManager.initSpeech();
    voiceInputManager.startListening(
          (resultText) {
        inputText = resultText.toLowerCase();
      },
    );

    Future.delayed(
      Duration(seconds: 20),
          () {
        voiceInputManager.stopListening();
      },
    );
  }

  void initTextToSpeech() {
    if (widget.trackingEvent != null && widget.trackingEvent?.virtualDetectorState == VirtualDetectorState.Service) {
    voiceManager.setVoiceText(voiceText);
    voiceManager.speak();
    }
  }

  void handleInputSpeech() {
    _inputText.value = inputText;
    if (inputText.contains('hi')) {
      setState(() {
        color = Colors.blue;
      });
    }

    if (inputText.contains('hello')) {
      setState(() {
        color = Colors.yellow;
      });
    }

    if (inputText.contains('goodbye')) {
      setState(() {
        color = Colors.purple;
      });
    }
  }

  @override
  void didUpdateWidget(EventLog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trackingEvent?.geofenceEventType != widget.trackingEvent?.geofenceEventType && widget.trackingEvent != null) {
      initTextToSpeech();
      initSpeechToText();
    }
  }

  final ValueNotifier<String> _inputText = ValueNotifier<String>('');
  @override
  Widget build(BuildContext context) {
    TextStyle textStyleTitle = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
    TextStyle textStyleContent = TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);
    return (isShowEvent && MapHelper().trackingEvent != null)
    // return (!widget.iShowEvent && MapHelper().trackingEvent == null)
        ? ValueListenableBuilder(
          valueListenable: _inputText,
          builder: (BuildContext context, value, Widget? child) {
            return Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Dimens.size10Vertical),
                  padding: EdgeInsets.all(Dimens.size10Vertical),
                  decoration: BoxDecoration(
                      color: color ?? Color(0xFF3d7d40),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(
                                MapHelper().trackingEvent?.nodeName ?? "",
                                overflow: TextOverflow.visible,
                                style: textStyleTitle,
                              )),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  isShowEvent = !isShowEvent;
                                });
                              },
                              child: SizedBox(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: Dimens.size25Horizontal,
                                ),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Circle:",
                                    overflow: TextOverflow.visible,
                                    style: textStyleTitle),
                                Text(
                                  MapHelper()
                                      .trackingEvent
                                      ?.currentCircle
                                      .toString() ??
                                      "",
                                  overflow: TextOverflow.visible,
                                  style: textStyleContent,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("VecId:",
                                    overflow: TextOverflow.visible,
                                    style: textStyleTitle),
                                Text(
                                  (MapHelper().trackingEvent?.vectorId ?? 0)
                                      .toString(),
                                  overflow: TextOverflow.visible,
                                  style: textStyleContent,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Event:",
                                    overflow: TextOverflow.visible,
                                    style: textStyleTitle),
                                Text(
                                  MapHelper()
                                      .trackingEvent
                                      ?.geofenceEventType
                                      ?.name ??
                                      "",
                                  overflow: TextOverflow.visible,
                                  style: textStyleContent,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("State:",
                                    overflow: TextOverflow.visible,
                                    style: textStyleTitle),
                                Text(
                                    MapHelper()
                                        .trackingEvent
                                        ?.virtualDetectorState
                                        ?.name ??
                                        "",
                                    overflow: TextOverflow.visible,
                                    style: textStyleContent)
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_inputText.value == "") Row(
                        children: [
                          Text(
                              voiceInputManager.isListening ? 'true' : 'false'
                          )
                        ],
                      ) else Text(
                          _inputText.value,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
        : SizedBox.shrink();
  }
}
