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


class TrackingEvent {
  int? nodeId;
  int? userId;
  String? nodeName;
  int? vectorId;
  int? vectorEvent;
  int? state;
  int? currentCircle;
  GeofenceEventType? geofenceEventType;
  VirtualDetectorState? virtualDetectorState;
  TrackingEvent(
      {this.nodeId,
        this.userId,
        this.nodeName,
        this.vectorId,
        this.vectorEvent,
        this.state,
        this.currentCircle,
        this.geofenceEventType,
        this.virtualDetectorState
      });

  TrackingEvent.fromJson(Map<String, dynamic> json) {
    nodeId = json['NodeId'];
    userId = json['UserId'];
    nodeName = json['NodeName'];
    vectorId = json['VectorId'];
    vectorEvent = json['VectorEvent'];
    state = json['State'];
    currentCircle = json['CurrentCircle'];
    geofenceEventType =(vectorEvent??0)< GeofenceEventType.values.length? GeofenceEventType.values.elementAt(vectorEvent??0):GeofenceEventType.StillOutside;
    virtualDetectorState =(state??0)< VirtualDetectorState.values.length? VirtualDetectorState.values.elementAt(state??0):VirtualDetectorState.InValid;
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
    return data;
  }
}
