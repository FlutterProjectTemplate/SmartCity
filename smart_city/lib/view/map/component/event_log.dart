import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/model/tracking_event/tracking_event.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/mqtt_manager/MQTT_client_manager.dart';

import '../../../constant_value/const_size.dart';
import '../../../controller/helper/map_helper.dart';
import '../../voice/stt_manager.dart';
import '../../voice/tts_manager.dart';
import  'package:string_similarity/string_similarity.dart';

class EventLogNormal extends StatefulWidget {
  const EventLogNormal(
      {
        super.key,
        required this.iShowEvent,
        required this.trackingEvent,
        required this.onClose
      });

  final bool iShowEvent;
  final TrackingEventInfo? trackingEvent;
  final Function()onClose;

  @override
  State<EventLogNormal> createState() => _EventLogNormalState();
}

class _EventLogNormalState extends State<EventLogNormal> {
  String voiceText = '';
  String inputText = '';
  Color? color;
  late bool isShowEvent;
  int selectIndex=0;
  @override
  void initState() {
    super.initState();
    isShowEvent = widget.iShowEvent;
  }

  @override
  void didUpdateWidget(EventLogNormal oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
  bool enableListening = false;
  @override
  Widget build(BuildContext context) {
    TextStyle textStyleTitle = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
    TextStyle textStyleContent = TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);
    return (isShowEvent && MapHelper().logEventNormal != null)
        ? Container(
          margin: EdgeInsets.symmetric(horizontal: Dimens.size10Vertical),
          padding: EdgeInsets.all(Dimens.size10Vertical),
          decoration: BoxDecoration(
              color: color ?? Color(0xFF3d7d40),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12), bottom: Radius.circular(MapHelper().logEventNormal?.virtualDetectorState== VirtualDetectorState.Service?0: 12))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: Text(
                        widget.trackingEvent?.nodeName ?? "",
                        overflow: TextOverflow.visible,
                        style: textStyleTitle,
                      )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isShowEvent = !isShowEvent;
                          widget.onClose();
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
                              .logEventNormal
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
                          (widget.trackingEvent?.vectorId ?? 0)
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
                          MapHelper().logEventNormal?.geofenceEventType?.name ?? "",
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
                            MapHelper().logEventNormal?.virtualDetectorState?.name ?? "",
                            overflow: TextOverflow.visible,
                            style: textStyleContent)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        : SizedBox.shrink();
  }
}
class EventLogService extends StatefulWidget {
  const EventLogService({super.key, required this.iShowEvent, required this.trackingEvent});

  final bool iShowEvent;
  final TrackingEventInfo? trackingEvent;

  @override
  State<EventLogService> createState() => _EventLogServiceState();
}

class _EventLogServiceState extends State<EventLogService> {
  String voiceText = '';
  String inputText = '';
  Color? color;
  late bool isShowEvent;
  List<String> talkOptionStr = [];
  List<Widget> talkOptionWidget = [];
  int selectIndex=0;
  @override
  void initState() {
    super.initState();
    isShowEvent = widget.iShowEvent;
    if(widget.trackingEvent?.virtualDetectorState == VirtualDetectorState.Service)
    {
      for(Options option in widget.trackingEvent?.options??[])
      {
        talkOptionStr.add("option ${option.index}: ${option.channelName}");
        talkOptionWidget.add(InkWell(
          onTap: () async {
            if(!VoiceInputManager().isListening){
              await  EventLogManager().senMQTTMessage(trackingEvent: widget.trackingEvent!, option: option);
            }
          },
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: Dimens.size80Vertical),
            child: Container(
              width: Dimens.size40Vertical,
              height: Dimens.size40Vertical,
              decoration: BoxDecoration(
                  color: selectIndex == option.index?Colors.blue:Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.size20Vertical)
              ),
              child: Center(
                child: Text("${option.index}", style: TextStyle(
                  fontSize: Dimens.size15Horizontal,
                ),),
              ),
            ),
          ),
        ));

      }
      EventLogManager().handlerVoiceCommandEvent(
        trackingEvent: widget.trackingEvent,
        onChangeIndex: (p0) {
          if(p0.runtimeType == int) {
            selectIndex = p0;
          }
        },
        onSetState: (p0) {
          if(p0.runtimeType == int) {
            selectIndex = p0 as int;
          }
        },
        onGetString: (p0) {
          print("object");
          setState(() {
            _inputText.value =p0;
          });
        },
      );
    }
  }

  @override
  void didUpdateWidget(EventLogService oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  final ValueNotifier<String> _inputText = ValueNotifier<String>('');
  bool enableListening = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _inputText,
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: Dimens.size10Vertical),
          padding: EdgeInsets.all(Dimens.size10Vertical),
          decoration: BoxDecoration(
              color: color ?? Color(0xFF3d7d40),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible: widget.trackingEvent?.virtualDetectorState ==  VirtualDetectorState.Service, // hien thi tùy chọn âm thanh
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: talkOptionWidget,
                              ),
                            ),
                            SizedBox(height: Dimens.size10Vertical,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: VoiceInputManager().isListening?
                                  Icon(Icons.mic_none, color: Colors.red, size: Dimens.size30Vertical,):
                                  Icon(Icons.mic_off, color: Colors.grey,size: Dimens.size25Horizontal,),
                                  onTap: () async {
                                    enableListening= !enableListening;
                                    if(enableListening && !VoiceInputManager().isListening) {
                                      MapHelper().allowListening= true;
                                       EventLogManager().listenSpeech(
                                      onGetString: (p0) async {
                                        setState(() {
                                          _inputText.value = p0;
                                        });
                                        for(Options option in MapHelper().logEventService?.options??[])
                                        {
                                          String optionStr = "option ${option.index} ${option.channelName}";

                                          if(option.channelName.similarityTo(p0)>=0.8 || optionStr.similarityTo(p0)>=0.8 || "option ${option.index}".similarityTo(p0)>=0.8)
                                          {
                                            await VoiceInputManager().stopListening();
                                            await EventLogManager().senMQTTMessage(trackingEvent: MapHelper().logEventService!, option: option);

                                          }
                                        }
                                        print("object");
                                      },
                                      trackingEvent: MapHelper().logEventService,
                                        onSetState: (p0) {
                                        },
                                      );
                                    }
                                    else
                                    {
                                      await VoiceInputManager().stopListening();
                                      setState(() {
                                        MapHelper().allowListening= false;
                                      });
                                    }

                                  },
                                ),
                                Expanded(child: Text(
                                  VoiceInputManager().isListening ?(_inputText.value.isNotEmpty?" ${_inputText.value}...": "...."): "",
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ))
                              ],
                            )

                          ],
                        ),
                      );
                    },
                  )
              ),
            ],
          ),
        );
      },
    );
        //: SizedBox.shrink();
  }
}
class EventLogManager{
  static final EventLogManager _singletonEventLogManager = EventLogManager._internal();
  factory EventLogManager() {
    return _singletonEventLogManager;
  }

  EventLogManager._internal();
  int selectIndex= 0;
  String inputText='';
  void handlerVoiceCommandEvent(
      {
        TrackingEventInfo? trackingEvent,
        Function(int)?onChangeIndex,
        Function(dynamic)?onSetState,
        dynamic Function(String)? onGetString
      }){
    if(trackingEvent==null) {
      return;
    }
    MapHelper().allowListening = true;
    Future.delayed(Duration(milliseconds: 100,), () async {
      List<String>optionStrs =[];
      try {
        await initTextToSpeech(voiceText: "You can control the command, please select", trackingEvent: trackingEvent);
        for(Options option in trackingEvent.options??[])
        {
          String optionStr = "option ${option.index} ${option.channelName}";
          optionStrs.add(optionStr);
          if(onSetState!=null)
          {
            onSetState(option.index);
          }
          await initTextToSpeech(voiceText: optionStr, trackingEvent: trackingEvent);

        }
        await listenSpeech(
          onGetString: onGetString,
          trackingEvent: trackingEvent,
          onSetState: onSetState,
        );
      } catch (e) {
        print(e.toString());
      }
    },);
  }
  Future<void> listenSpeech({
    TrackingEventInfo? trackingEvent,
    Function(dynamic)?onSetState,
    dynamic Function(String)? onGetString
  })async {
    Future.delayed(Duration(milliseconds: 100,), () async {
      await initSpeechToText(onSetState: onSetState, onGetString: (p0) async {
        bool suceess = false;
        if(onGetString!=null)
          {
            onGetString(p0);
          }
        for(Options option in trackingEvent?.options??[])
        {
          String optionStr = "option ${option.index} ${option.channelName}";

          if(option.channelName.similarityTo(p0)>=0.8 || optionStr.similarityTo(p0)>=0.8 || "option ${option.index}".similarityTo(p0)>=0.8)
          {
            suceess = true;
            await VoiceInputManager().stopListening();
            await senMQTTMessage(trackingEvent: trackingEvent!, option: option);
          }
          else
          {

          }
        }
        if(suceess == false && MapHelper().allowListening)
        {
          await VoiceInputManager().stopListening();
          await listenSpeech(
            onGetString: onGetString,
            trackingEvent: trackingEvent,
            onSetState: onSetState,
          );
        }
      },);
    });
  }

  Future<void> initSpeechToText({Function(dynamic)?onSetState, Function(String)?onGetString}) async {
    if(MapHelper().allowListening == false) {
      return;/// neu đa tắt mic, sẽ không bật lại listening nữa
    }
    await VoiceInputManager().startListening(
         onResult: (resultText) async {
            inputText = resultText.toLowerCase();
            if(onGetString!=null)
        {
          onGetString(inputText);
        }
      //VoiceInputManager().stopListening();
      if(onSetState!=null)
        {
          onSetState('');
        }
    },
    );
    if(onSetState!=null)
    {
      onSetState('');
    }
  }

  Future<void> initTextToSpeech({required String voiceText, TrackingEventInfo? trackingEvent,}) async{
    if (trackingEvent != null && trackingEvent.virtualDetectorState == VirtualDetectorState.Service) {
      await VoiceManager().setVoiceText(voiceText);
      await VoiceManager().speak();
    }
  }
  Future<void> senMQTTMessage({required TrackingEventInfo trackingEvent,required Options option}) async {
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    String topicNameReceived = "device/${userDetail?.customerId??1}/${userDetail?.id}/control";
    Map<String, dynamic> message = {
      "NodeId":trackingEvent.nodeId,
      "VectorId":trackingEvent.vectorId,
      "Index":option.index,
      "ChannelId":option.channelId,
      "ChannelName":option.channelName};
   await MQTTManager().sendMessageToATopic(
        newMqttServerClientObject: MQTTManager().mqttServerClientObject,
        specialTopic: topicNameReceived,
        message: jsonEncode(message)
    );
  }
}
