import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:smart_city/model/user/user_info.dart';
import 'package:smart_city/services/api/get_vehicle/models/get_vehicle_model.dart';
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
  Function()? onDispose;
  CommandBox(
      {super.key,
      required this.iShowEvent,
      required this.trackingEvent,
      this.onSendServiceControl,
        this.onDispose,
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
                EventLogManager().inProccess = false;
                EventLogManager().stopTextToSpeech();
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
          if(mounted) {
            setState(() {

          });
          }
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
    EventLogManager().inProccess=false;
    if(widget.onDispose!=null)
      {
        widget.onDispose!();
      }
  }

  @override
  Widget build(BuildContext context) {
    if (MapHelper().logEventService == null || !isShowEvent) {
      return const SizedBox();
    }
    UserDetail? userInfo = SqliteManager().getCurrentLoginUserDetail();
    return Visibility(
      visible: (widget.trackingEvent?.options ?? []).length>=2,
      child: FutureBuilder(
        future:  userInfo?.getVehicleTypeInfo(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return SizedBox.shrink();
          }
          VehicleTypeInfo? vehicleTypeInfo = snapshot.data;
          return //(vehicleTypeInfo?.isPedestrian()??false)?
              /// nguoi di bo thi hien thi popup, con lai thi khong hien thi
          ValueListenableBuilder(
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
         // :SizedBox.shrink();
      },),
    );

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
                          "Approaching an intersection, \nSay or Tap",
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
                  SizedBox(
                    width: 8,
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
  bool waitingListen = false;
  bool inProccess = false;/// dùng để kiểm tra xem có ứng dụng có đang trong trạng thái nói và lắng nghe hay kooong. nếu có thì không nhận thêm event để nói và lắng nghe nữa
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
    //MapHelper().allowListening = true;
    Future.delayed(
      Duration(
        milliseconds: 100,
      ),
      () async {
        List<String> optionStrs = [];
        if((trackingEvent.options ?? []).isEmpty) {
          return;
        }
        if((trackingEvent.options ?? []).length<=1)
          {
            /// truong hop chi co 1 option, tuong khong phai nguoi di bo
            if(inProccess==false) {
              inProccess = true;
              initTextToSpeech(
                voiceText: "Approaching an intersection, Detection request sent.",
                trackingEvent: trackingEvent, onFinish: () async {
              },);
            }
          }
        else
          {
            /// truong hop co nhieu option
            optionStrs.add("Approaching an intersection, Say or Tap");
            try {
              await VoiceInputManager().stopListening();
              for (Options option in trackingEvent.options ?? []) {
                optionStrs.add(option.getSpeechText());
              }
              index = 0;
              if(inProccess==false)
                {
                  inProccess = true;
                onSpeech(
                  optionStrList: optionStrs,
                  trackingEvent: trackingEvent,
                  onFinishFinal: () async {
                    waitingListen = true;
                    Timer(Duration(seconds: 10), () {
                      waitingListen = false;
                    },);
                    listenSpeech(
                        onGetString: onGetString,
                        trackingEvent: trackingEvent,
                        onSetState: onSetState,
                        onSendServiceControl: onSendServiceControl,
                        onCancel: onCancel,
                      onEnd: () {
                        inProccess = false;
                      },
                    );
                  },);
                }

            } catch (e) {
              print(e.toString());
            }
          }

      },
    );
  }
  int index =0;
  Future<void> onSpeech(
      {
        required List<String> optionStrList,
        required Function() onFinishFinal,
        TrackingEventInfo? trackingEvent})async {
    if(index <optionStrList.length && inProccess==true)
      {
          initTextToSpeech(
          voiceText: optionStrList.elementAt(index),
          trackingEvent: trackingEvent, onFinish: () async {
          index++;
          onSpeech(optionStrList: optionStrList, trackingEvent: trackingEvent, onFinishFinal: onFinishFinal);
        },);
      }
    else {
      onFinishFinal();
    }
  }
  Future<void> listenSpeech({
    TrackingEventInfo? trackingEvent,
    Function(dynamic)? onSetState,
    dynamic Function(String)? onGetString,
    Function(Options)? onSendServiceControl,
    Function(Options)? onCancel,
    Function()? onEnd,
  }) async {
    Future.delayed(
        Duration(
          milliseconds: 100,
        ), () async {
      await initSpeechToText(
        onSetState: onSetState,
        onListenEnd: () {
          if(onEnd!=null)
          {
            onEnd();
          }
        },
        onGetString: (p0) async {
          bool suceess = false;
          print(p0);
          if (onGetString != null) {
            onGetString(p0);
          }
          for (Options option in trackingEvent?.options ?? []) {
            String optionStr = option.getSpeechText();
            if (option.checkSimilarityToText(compareText: p0)) {
              suceess = true;
              if (option.isCancelOption()) {
                if (onCancel != null) {
                  print("cancal command");
                  onCancel(option);
                }
              } else {
                await senMQTTMessage(
                    trackingEvent: trackingEvent!, option: option);
                if (onSendServiceControl != null) {
                  print("onSendServiceControl");
                  onSendServiceControl(option);

                }
              }
            } else {
              print("command not correct,\n channelName: ${option.channelName}, \n  optionStr: $optionStr, p0: $p0, option index: option ${option.index}: ");
            }
          }
          if(suceess==false)
            {
                Future.delayed(Duration(seconds: 1), () async {
                  if(waitingListen) {
                  await listenSpeech(
                  onSendServiceControl: onSendServiceControl,
                  onCancel: onCancel,
                  onGetString: onGetString,
                  onSetState: onSetState,
                  trackingEvent: trackingEvent,
                      onEnd: onEnd
                  );
                  }
                }
                ,);
            }
          else{
            if(onEnd!=null)
              {
                onEnd();
              }
          }
        },
      );
    });
  }

  Future<void> initSpeechToText(
      {Function(dynamic)? onSetState, Function(String)? onGetString, Function()? onListenEnd}) async {
    await VoiceInputManager().startListening(
      onListenEnd: () {
        if(onListenEnd!=null)
          {
            onListenEnd();
          }
      },
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
    Function()? onFinish
  }) async {
    if (trackingEvent != null && trackingEvent.virtualDetectorState == VirtualDetectorState.Service) {
      await VoiceManager().setVoiceText(voiceText);

      await VoiceManager().speak(onFinish: () {
        if(onFinish!=null)
          {
            onFinish();
          }
      },);
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
