import 'package:string_similarity/string_similarity.dart';

/// <summary>
/// Các sự kiện của vector geofence
/// </summary>
 enum GeofenceEventType
{
  Entered,
  Exited,
  StillInside,
  StillOutside
}

/// <summary>
/// các trạng thái của virtual detector
/// </summary>
enum VirtualDetectorState
{
  Undefined,
  Processing,
  Service,
  InValid
}


class TrackingEventInfo {
  int? nodeId;
  int? userId;
  String? nodeName;
  int? vectorId;
  int? vectorEvent;
  int? state;
  int? currentCircle;
  GeofenceEventType? geofenceEventType;
  VirtualDetectorState? virtualDetectorState;
  List<Options>? options;
  String? time;

  TrackingEventInfo(
      {
        this.nodeId,
        this.userId,
        this.nodeName,
        this.vectorId,
        this.vectorEvent,
        this.state,
        this.currentCircle,
        this.geofenceEventType,
        this.virtualDetectorState,
        this.options,
        this.time
      });

  TrackingEventInfo.fromJson(Map<String, dynamic> json) {

    nodeId = json['NodeId'];
    userId = json['UserId'];
    nodeName = json['NodeName'];
    vectorId = json['VectorId'];
    vectorEvent = json['VectorEvent'];
    state = json['State'];
    currentCircle = json['CurrentCircle'];
    geofenceEventType =(vectorEvent??0)< GeofenceEventType.values.length? GeofenceEventType.values.elementAt(vectorEvent??0):GeofenceEventType.StillOutside;
    virtualDetectorState =(state??0)< VirtualDetectorState.values.length? VirtualDetectorState.values.elementAt(state??0):VirtualDetectorState.InValid;
    if (json['Options'] != null ) {
      options = <Options>[];
      try{
        json['Options'].forEach((v) {
          (options??[]).add(Options.fromJson(v));
        });
        if((options??[]).length>1)
          {
            options!.add(Options(channelId: (options?.last.channelId??1)+1, channelName: "Cancel",   index:  (options?.last.index??0)+1, isDummy: true),);
          }
      }
      catch(e)
    {

    }

    }
    time = DateTime.now().millisecondsSinceEpoch.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NodeId'] = nodeId;
    data['UserId'] = userId;
    data['NodeName'] = nodeName;
    data['VectorId'] = vectorId;
    data['VectorEvent'] = vectorEvent;
    data['State'] = state;
    data['CurrentCircle'] = currentCircle;
    if (options != null) {
      data['Options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Options {
  int? index;
  int? channelId;
  String? channelName;
  bool? isDummy;

  Options({this.index, this.channelId, this.channelName, this.isDummy});

  Options.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    channelId = json['ChannelId'];
    channelName = json['ChannelName'];
    isDummy= false;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Index'] = index;
    data['ChannelId'] = channelId;
    data['ChannelName'] = channelName;
    return data;
  }

  String getSpeechText(){
    String optionStr = "option $index to cross $channelName";
    if(channelName =="Cancel")
    {
      optionStr = "option $index for $channelName";
      /// option huy bo se doi to thanh for
    }
    return optionStr;
  }
  bool isCancelOption(){
    return channelName =="Cancel";
  }
  bool checkSimilarityToText({required String compareText}){
    String optionStr = getSpeechText();
    if ((channelName??"").toLowerCase().similarityTo(compareText.toLowerCase()) >= 0.7 ||
        optionStr.toLowerCase().similarityTo(compareText.toLowerCase()) >= 0.7 ||
        "${index}".toLowerCase().similarityTo(compareText.toLowerCase()) >= 0.8||
        "option ${index}".toLowerCase().similarityTo(compareText.toLowerCase()) >= 0.7) {
      return true;
    } else {
      return false;
    }
  }
}