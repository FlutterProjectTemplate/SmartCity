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
    if (json['Options'] != null) {
      options = <Options>[];
      try{
        json['Options'].forEach((v) {
          options!.add(Options.fromJson(v));
        });
        options!.add(Options(channelId: (options?.last.channelId??0)+1, channelName: "Cancel",   index:  (options?.last.index??0)+1, isDummy: true),);

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
}