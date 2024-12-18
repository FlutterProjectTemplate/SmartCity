import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:smart_city/view/map/component/sound_icon.dart';
import 'package:string_similarity/string_similarity.dart';

import '../../background_service.dart';
import '../../base/sqlite_manager/sqlite_manager.dart';
import '../../controller/helper/map_helper.dart';
import '../../model/tracking_event/tracking_event.dart';
import '../../model/user/user_detail.dart';
import '../../mqtt_manager/MQTT_client_manager.dart';
import '../voice/stt_manager.dart';
import '../voice/tts_manager.dart';

class CommandBox extends StatefulWidget {
  final bool iShowEvent;
  final TrackingEventInfo? trackingEvent;
  Function(Options)? onSendServiceControl;
  Function(Options)? onCancel;

  CommandBox(
      {super.key,
      required this.iShowEvent,
      required this.trackingEvent,
      this.onSendServiceControl,
      this.onCancel});

  @override
  State<CommandBox> createState() => _CommandBoxState();
}

class _CommandBoxState extends State<CommandBox> {
  Timer? timer;
  String voiceText = '';
  bool isSpeaking = false;
  String inputText = '';
  Color? color;
  late bool isShowEvent;
  List<String> talkOptionStr = [];
  List<Widget> talkOptionWidget = [];
  int selectIndex = 0;
  final ValueNotifier<String> _inputText = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    isShowEvent = widget.iShowEvent;
    if (widget.trackingEvent?.virtualDetectorState ==
        VirtualDetectorState.Service) {
      for (Options option in widget.trackingEvent?.options ?? []) {
        talkOptionStr.add("option ${option.index??0 + 1}: ${option.channelName}");
        talkOptionWidget.add(_buildOptionTile(
            index: talkOptionStr.length - 1,
            channelName: option.channelName ?? '',
            isLast: talkOptionStr.length ==
                ((widget.trackingEvent?.options?.length ?? 0)),
            onTap: () async {
              if(option.channelId == (widget.trackingEvent?.options??[]).last.channelId)
              {
                if(widget.onCancel!=null)
                {
                  widget.onCancel!(option);
                }
              }
              else
              {
                await  EventLogManager().senMQTTMessage(trackingEvent: widget.trackingEvent!, option: option);
                if(widget.onSendServiceControl!=null)
                {
                  widget.onSendServiceControl!(option);
                }
              }
              setState(() {
                isShowEvent = false;
              });
            }));
      }
      EventLogManager().handlerVoiceCommandEvent(
        trackingEvent: widget.trackingEvent,
        onChangeIndex: (p0) {
          if (p0.runtimeType == int) {
            selectIndex = p0;
          }
        },
        onSetState: (p0) {
          if (p0.runtimeType == int) {
            selectIndex = p0 as int;
          }
          setState(() {

          });
        },
        onGetString: (p0) {
          if (mounted) {
            setState(() {
              _inputText.value = p0;
            });
          }
        },
        onSendServiceControl: (p0) {
          if (widget.onSendServiceControl != null) {
            widget.onSendServiceControl!(p0);
          }
        },
        onCancel: (p0) {
          if (widget.onCancel != null) {
            widget.onCancel!(p0);
          }
          if (mounted) {
            setState(() {});
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    VoiceInputManager().stopListening();
    VoiceManager().stop();
  }

  @override
  Widget build(BuildContext context) {
    if (MapHelper().logEventService == null || !isShowEvent) {
      return const SizedBox();
    }

    return ValueListenableBuilder(
        valueListenable: _inputText,
        builder: (BuildContext context, value, Widget? child) {
          return Draggable(
            onDragEnd: (draggableDetails) {
              if (draggableDetails.offset.dy <= -75) {
                setState(() {
                  isShowEvent = false;
                });
              }
              if (draggableDetails.offset.dx <= -100) {
                setState(() {
                  isShowEvent = false;
                });
              }
              if (draggableDetails.offset.dx >=
                  MediaQuery.of(context).size.width) {
                setState(() {
                  isShowEvent = false;
                });
              }
            },
            feedback: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: infoWidget(context),
              ),
            ),
            childWhenDragging: Container(),
            child: infoWidget(context),
          );
        });
  }

  Widget infoWidget(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade700,
              Colors.blueGrey.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location and State Header
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MapHelper().logEventService?.nodeName ??
                              'Unknown Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SoundIcon(
                    listeningIcon: Icons.mic_off,
                    speakingIcon: Icons.mic_none,
                    isListening: VoiceInputManager().isListening(),
                    onTap: () {},
                  )
                ],
              ),
            ),

            // Options List
            if (MapHelper().logEventService != null)
              Column(
                children: talkOptionWidget,
              ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
      {required int index,
      required String channelName,
      Function()? onTap,
      required bool isLast}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !isLast
                      ? Colors.white.withOpacity(0.2)
                      : Colors.redAccent,
                ),
                child: Center(
                  child: !isLast
                      ? Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Icon(Icons.close),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  channelName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.directions,
                color: Colors.white54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventLogManager {
  static final EventLogManager _singletonEventLogManager =
      EventLogManager._internal();

  factory EventLogManager() {
    return _singletonEventLogManager;
  }

  EventLogManager._internal();

  int selectIndex = 0;
  String inputText = '';

  void handlerVoiceCommandEvent({
    TrackingEventInfo? trackingEvent,
    Function(int)? onChangeIndex,
    Function(dynamic)? onSetState,
    dynamic Function(String)? onGetString,
    Function(Options)? onSendServiceControl,
    Function(Options)? onCancel,
  }) {
    if (trackingEvent == null) {
      return;
    }
    MapHelper().allowListening = true;
    Future.delayed(
      Duration(
        milliseconds: 100,
      ),
      () async {
        List<String> optionStrs = [];
        String optionStrstr = "You are approaching an intersection select   ";
        try {
          await VoiceInputManager().stopListening();
          for (Options option in trackingEvent.options ?? []) {
            String optionStr = "option ${option.index??0 + 1} to ${option.channelName}";
            optionStrstr += optionStr+ "    ";
            optionStrs.add(optionStr);
          }
          await initTextToSpeech(voiceText: optionStrstr, trackingEvent: trackingEvent);
          Future.delayed(Duration(seconds: 3 + 1 * (trackingEvent.options ?? []).length), () {
            Timer.periodic(Duration(milliseconds: 500), (timer) async {
              if(VoiceManager().isStopped)
              {
                timer.cancel();
                await listenSpeech(
                    onGetString: onGetString,
                    trackingEvent: trackingEvent,
                    onSetState: onSetState,
                    onSendServiceControl: onSendServiceControl,
                    onCancel: onCancel);
              }
            },);
          },);


        } catch (e) {
          print(e.toString());
        }
      },
    );
  }

  Future<void> listenSpeech({
    TrackingEventInfo? trackingEvent,
    Function(dynamic)? onSetState,
    dynamic Function(String)? onGetString,
    Function(Options)? onSendServiceControl,
    Function(Options)? onCancel,
  }) async {
    Future.delayed(
        Duration(
          milliseconds: 100,
        ), () async {
      await initSpeechToText(
        onSetState: onSetState,
        onGetString: (p0) async {
          bool suceess = false;
          print(p0);
          if (onGetString != null) {
            onGetString(p0);
          }
          for (Options option in trackingEvent?.options ?? []) {
            String optionStr = "option ${option.index} to ${option.channelName}";
            if (option.channelName!.similarityTo(p0) >= 0.9 ||
                optionStr.similarityTo(p0) >= 0.9 ||
                "option ${option.index}".similarityTo(p0) >= 0.9) {
              suceess = true;

/*            if(option.isDummy==true) {
              return;
            }*/
              if (option.channelName ==
                  (trackingEvent?.options ?? []).last.channelName) {
                if (onCancel != null) {
                  print("cancal command");
                  onCancel(option);
                }
              } else {
                await senMQTTMessage(
                    trackingEvent: trackingEvent!, option: option);
                if (onSendServiceControl != null) {
                  onSendServiceControl(option);
                }
              }
            } else {}
          }
/*        if(suceess == false && MapHelper().allowListening)
        {
          await VoiceInputManager().stopListening();
          await listenSpeech(
            onGetString: onGetString,
            trackingEvent: trackingEvent,
            onSetState: onSetState,
          );
        }*/
        },
      );
    });
  }

  Future<void> initSpeechToText(
      {Function(dynamic)? onSetState, Function(String)? onGetString}) async {
    if (MapHelper().allowListening == false) {
      return;
      /// neu đa tắt mic, sẽ không bật lại listening nữa
    }
    await VoiceInputManager().startListening(
      onResult: (resultText) async {
        inputText = resultText.toLowerCase();
        if (onGetString != null) {
          onGetString(inputText);
        }
        //VoiceInputManager().stopListening();
        if (onSetState != null) {
          onSetState('');
        }
      },
    );
    if (onSetState != null) {
      onSetState('');
    }
  }

  Future<void> initTextToSpeech({
    required String voiceText,
    TrackingEventInfo? trackingEvent,
  }) async {
    if (trackingEvent != null && trackingEvent.virtualDetectorState == VirtualDetectorState.Service) {
      await VoiceManager().setVoiceText(voiceText);

      await VoiceManager().speak();
    }
  }

  Future<void> stopTextToSpeech() async {
    await VoiceManager().stop();
  }

  Future<void> invokeSenMQTTMessage(
      {required TrackingEventInfo trackingEvent,
      required Options option}) async {
    FlutterBackgroundService().invoke(
      ServiceKey.updateInfoKeyToBackGround,
      {"trackingEvent": trackingEvent.toJson(), "option": option.toJson()},
    );
  }

  Future<void> senMQTTMessage(
      {required TrackingEventInfo trackingEvent,
      required Options option}) async {
    if (option.isDummy != false) {
      return;
    }

    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    String topicNameReceived =
        "device/${userDetail?.customerId ?? 1}/${userDetail?.id}/control";
    Map<String, dynamic> message = {
      "NodeId": trackingEvent.nodeId,
      "VectorId": trackingEvent.vectorId,
      "Index": option.index,
      "ChannelId": option.channelId,
      "ChannelName": option.channelName
    };
    await MQTTManager().sendMessageToATopic(
        newMqttServerClientObject: MQTTManager().mqttServerClientObject,
        specialTopic: topicNameReceived,
        message: jsonEncode(message));
  }
}
