import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smart_city/background_service.dart';
import 'package:smart_city/base/app_settings/app_setting.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/update_app/app_version_checker.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_container.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/constant_value/const_size.dart';
import 'package:smart_city/controller/helper/map_helper.dart';
import 'package:smart_city/controller/stopwatch_bloc/stopwatch_bloc.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
import 'package:smart_city/helpers/localizations/bloc/main.exports.dart';
import 'package:smart_city/model/tracking_event/tracking_event.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/services/api/vector/get_vector_api.dart';
import 'package:smart_city/services/api/vector/vector_model/vector_model.dart';
import 'package:smart_city/view/setting/setting_ui.dart';
import 'package:smart_city/view/voice/stt_manager.dart';
import 'package:smart_city/view/voice/tts_manager.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../base/sqlite_manager/sqlite_manager.dart';
import '../../helpers/services/location_service.dart';
import '../../l10n/l10n_extention.dart';
import '../../model/node/node_model.dart';
import '../../model/user/user_info.dart';
import '../../model/vector_status/vector_status.dart';
import '../../mqtt_manager/MQTT_client_manager.dart';
import '../../services/api/get_vehicle/models/get_vehicle_model.dart';
import 'command_box.dart';
import 'component/custom_drop_down_map.dart';
import 'component/polyline_model_info.dart';
import 'map_bloc/map_bloc.dart';

class MapUi extends StatefulWidget {
  const MapUi({super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}

class _MapUiState extends State<MapUi>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
// UI Variables
  bool hidden = true;
  bool showInfoBox = false;
  bool onCameraIdleRunning = false;
  bool onStart = false;
  bool onService = false;
  bool iShowEvent = false;
  bool iShowingEvent = false;
  bool? enabledDarkMode;
  bool focusOnMyLocation = true;
  double itemSize = 40;
  double startButtonSize = ResponsiveInfo.isTablet() ? 105 : 80;
  double controlPanelHeight = ResponsiveInfo.isTablet() ? 105 : 80;
  double bottomPaddingHeight = 12;

  double appBarHeight = 0;

// Map and Location Variables
  String _mapStyleString = '';
  LatLng destination = const LatLng(0, 0);
  double distance = 0.0;
  double _bearing = 0;
  bool _isAnimatingCamera = false;
  Position? previousPosition;
  LatLng? previousCenterCameraPosition;
  double? previousZoomLevel;
  List<Marker> markers = [];
  List<Marker> selectedMarker = [];
  List<Marker> nodeMarker = [];
  List<Polygon> polygon = [];
  List<Polyline> polyline = [];
  List<Circle> circle = [];
  List<NodeModel> listNode = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _rotateMapTimer;
  LatLng? centerCameraPosition;
  bool? isSimulation = false;
// Animation Variables
  late AnimationController controller;
  late Animation<double> animation;

// User and Context Variables
  UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();
  late UserDetail? userDetail;
  late BuildContext buildContext;
  late BuildContext stopwatchBlocContext;
  late BuildContext _context;
  int count = 0;

// Vector and Event Variables
  late VectorModel vectorModel;
  int? vectorId;
  int currentVectorId = -1;

// Other
  late String? currentTimeZone;
  dynamic message;
  AppLifecycleState appLifecycleState = AppLifecycleState.resumed;
  @override
  void initState() {
    appBarHeight = 100;
    userDetail = SqliteManager().getCurrentLoginUserDetail();
    WidgetsBinding.instance.addObserver(this);
    if (userDetail == null) {
      context.go('login');
    }
    super.initState();
    try{
      VoiceInputManager().initSpeech();
    }
    catch(e){

    }
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      AppVersionCheckerManager().checkAppNewVersion(context);
    },);
    tz.initializeTimeZones();
    //_initLocationService();
    // mapHelper.listenLocationUpdate();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );
    animation = controller
      ..addListener(() {
        setState(() {});
      });
    DefaultAssetBundle.of(context)
        .loadString('assets/dark_mode_style.json')
        .then((string) {
      _mapStyleString = string;
    });
    listNode = [];
    _getLocal().then((value) {
    },);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      MapHelper().requestLocationPermission(onResult: (p0) async {
        await MapHelper().getCurrentLocationData();
       MapHelper().getCurrentPosition().then((value) {
         _focusOnMyLocation();
          polyline.add(Polyline(
              polylineId: PolylineId("Mypolyline"),
              points: [],
              color: Colors.red,
              width: 3));
          markers = [];
          selectedMarker = [];
          nodeMarker = [];

          _addMarkers(null, userDetail!.vehicleTypeNum!).then((value) {
            _getVector().then((value) {
              // _getNode().then((value) {
              setState(() {

              });
              // },);
            },);
          },);
        },);
      }, context: context);

    },);
  }

  Future<void> _connectMQTT({required BuildContext context,  bool ?isSimulation}) async {
    try {
      MQTTManager().disconnectAndRemoveAllTopic();
      MQTTManager().mqttServerClientObject =
          await MQTTManager().initialMQTTTrackingTopicByUser(
              onConnected: (p0) async {
                print('connected');
              },
              onRecivedData: (p0) {
                try {
                  final Map<String, dynamic> jsonData = jsonDecode(p0);
                  if (jsonData.containsKey('Options')) {   /// iShowEvent = true: chỉ khi không có popup nào show thi mới hiển thị lại
                    print("onReceivedData");
                    MapHelper().logEventNormal = TrackingEventInfo.fromJson(jsonData);
                    if(iShowEvent==false)
                      {
                        if (MapHelper().logEventNormal?.virtualDetectorState == VirtualDetectorState.Service) {
                          MapHelper().logEventService = MapHelper().logEventNormal;
                        } else {
                          MapHelper().logEventService = null;
                        }
                        MapHelper().timer1?.cancel();
                        if(MapHelper().logEventService != null)
                        {
                          MapHelper().timer1 = Timer(
                            Duration(seconds: (MapHelper().logEventService?.options??[]).length>=2? 30: 10), () {
                              setState(() {
                                iShowEvent = false;
                                MapHelper().timer1?.cancel();
                                MapHelper().timer1=null;
                                stopwatchBlocContext.read<StopwatchBloc>().add(ChangeServicingToResumeStopwatch());
                              });
                            },
                          );
                          setState(() {
                            iShowEvent = true;
                          });
                        }
                        else
                        {

                          setState(() {
                            iShowEvent = false;
                            MapHelper().timer1?.cancel();
                            MapHelper().timer1=null;
                          });
                        }
                        if(!(isSimulation??false)) {
                          stopwatchBlocContext.read<StopwatchBloc>().add(ChangeServicingToResumeStopwatch());
                        }
                        else
                          {
                            stopwatchBlocContext.read<StopwatchBloc>().add(StopStopwatch());
                          }
                      }
                    else if (MapHelper().logEventNormal?.virtualDetectorState != VirtualDetectorState.Service)
                      {
                        setState(() {
                          iShowEvent = false;
                          MapHelper().timer1?.cancel();
                          MapHelper().timer1=null;
                        });
                      }

                  } else if (jsonData.containsKey('VectorStatus')) {
                   // print("onReceivedData2");
                    MapHelper().vectorStatus = VectorStatusInfo.fromJson(jsonData);
                    _onVectorStatusChange(vectorStatus: MapHelper().vectorStatus!);
                  } else {
                    print("Unknown message type: $jsonData");
                  }
                  setState(() {
                    message = p0;
                  });
                } catch (e) {
                  print("Error parsing message: $e");
                }
              });
      await _initLocationService(context: context);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getLocal() async {
    currentTimeZone = await FlutterTimezone.getLocalTimezone();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    {
      switch(state){

        case AppLifecycleState.detached:
          // TODO: Handle this case.
          appLifecycleState = AppLifecycleState.detached;
          break;
        case AppLifecycleState.resumed:
          // TODO: Handle this case.
         // VoiceManager().inital();
          EventLogManager().inProccess=false;
          appLifecycleState = AppLifecycleState.resumed;
      FlutterBackgroundService().on(ServiceKey.updateInfoKeyToForeGround).listen((event) {
          print("get location error");
          if((event??{}).containsKey("location") && (event??{})['location']!=null){
            MapHelper().location =Position.fromMap((event??{})['location']);
          }
          if((event??{}).containsKey("polylineModelInfo") && (event??{})['polylineModelInfo']!=null){

            MapHelper().polylineModelInfo = PolylineModelInfo.fromJson((event??{})['polylineModelInfo']);
          }
          if((event??{}).containsKey("logEventService") ){
            if((event??{})['logEventService']!=null) {
              MapHelper().logEventService =TrackingEventInfo.fromJson ((event??{})['logEventService']);
              iShowEvent = true;
            }
            else
            {
              MapHelper().logEventService = null;
            }
          }
          if((event??{}).containsKey("logEventNormal")){
            if((event??{})['logEventNormal']!=null) {
              MapHelper().logEventNormal =TrackingEventInfo.fromJson ((event??{})['logEventNormal']);
            //  iShowEvent = true;
            }
            else
            {
              MapHelper().logEventNormal = null;
            }
          }
      },);
        stopBackgroundService().then((value) {
          initializeBackGroundService(); // this should use the `Navigator` to push a new route
        },);
        break;
        case AppLifecycleState.inactive:
          // TODO: Handle this case.
          appLifecycleState = AppLifecycleState.inactive;

          break;
        case AppLifecycleState.hidden:
          // TODO: Handle this case.
          appLifecycleState = AppLifecycleState.hidden;

          break;

        case AppLifecycleState.paused:
          // TODO: Handle this case.
          appLifecycleState = AppLifecycleState.paused;
          EventLogManager().inProccess=false;
          VoiceManager().dispose();
          if(MapHelper().isSendingMqtt)
        {
          print("App pause");
          if(Platform.isIOS){
            //stopBackgroundService();
              print("initializeBackGroundService");
              await initializeBackGroundService(autoStart: true); // this should use the `Navigator` to push a new route
              FlutterBackgroundService().invoke(ServiceKey.startInBackGroundKey);
              FlutterBackgroundService().invoke(
                ServiceKey.updateInfoKeyToBackGround,
                {
                  "polylineModelInfo":MapHelper().polylineModelInfo.toJson()
                },
              );
          }
          else{
            FlutterBackgroundService().invoke(ServiceKey.startInBackGroundKey);
            FlutterBackgroundService().invoke(
              ServiceKey.updateInfoKeyToBackGround,
              {
                "polylineModelInfo":MapHelper().polylineModelInfo.toJson()
              },
            );
          }

        }
      break;

      }
      super.didChangeAppLifecycleState(state);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    MapHelper().dispose();
    controller.dispose();
    LocationService().stopService();
    MQTTManager.getInstance.disconnectAndRemoveAllTopic();
  }

  @override
  Widget build(BuildContext context) {
    userDetail = SqliteManager().getCurrentLoginUserDetail();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    markers.clear();
    if (MapHelper().myLocationMarker != null) {
      markers.add(MapHelper().myLocationMarker!);
    }
    markers.addAll(selectedMarker);
    //markers.addAll(MapHelper().polylineModelInfo.getPolyLineMarker());
    // markers.addAll(nodeMarker);
    polyline =[];
    polyline.add(Polyline(
        polylineId: PolylineId("Mypolyline"),
        points: MapHelper().polylineModelInfo.getPointsPolyLine() ?? [],
        color: Colors.red,
        width: 3));

    enabledDarkMode = AppSetting.enableDarkMode;
    // if (enabledDarkMode!) _controller.setMapStyle(_mapStyleString);
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state.mainStatus == MainStatus.onEnableDarkMode) {
          state.mainStatus = MainStatus.unKnown;
          setState(() {});
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<MapBloc, MapState>(
              builder: (context, mapState) {
                buildContext = context;
                return BlocConsumer<VehiclesBloc, VehiclesState>(
                  listener: (context, vehiclesBloc)  async {
                    if (vehiclesBloc.blocStatus == BlocStatus.success) {
                      userDetail = SqliteManager().getCurrentLoginUserDetail();
                      _updateMyLocationMarker();
                      await _getVector(isReload: true, location: centerCameraPosition);
                      setState(()  {
                      });
                    }
                  },
                  builder: (context, vehicleState) {
                    _context = context;
                    //print("Update MapUI:");
                    if(polyline.isNotEmpty)
                    {
                     // print("points length:${polyline[0].points.length}");
                    }
                   // print("myLocation:${MapHelper().location?.toJson().toString()}");
                    return GoogleMap(
                      buildingsEnabled: false,
                      style: (enabledDarkMode ?? false)
                          ? _mapStyleString
                          : '',
                      padding: EdgeInsets.all(50),
                      onTap: (position) {
                        //_openNodeLocation();
                      },
                      // style: _mapStyleString,
                      onCameraMove: onCameraMove,
                      onCameraIdle: onCameraIdle,
                      mapType: mapState.mapType,
                      myLocationEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(MapHelper().location?.latitude??0, MapHelper().location?.longitude??0),
                        zoom: 16,
                      ),
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      trafficEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        MapHelper().controller = controller;
                        context.read<MapBloc>().add(NormalMapEvent());
                      },
                      polylines: polyline.toSet(),
                      polygons: polygon.toSet(),
                      circles: circle.toSet(),
                      markers: markers.toSet(),
                    );
                  },
                );
              },
            ),
/*            if (MapHelper().vectorStatus != null)
              infoBox(),*/

            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ResponsiveInfo.isPhone()
                      ? _controlPanelMobile(width: width, height: height)
                      : _controlPanelTablet(),
                    BlocBuilder<StopwatchBloc, StopwatchState>(
                      builder: (context, state) {
                        stopwatchBlocContext = context;
                        double offset = ResponsiveInfo.isTablet() ? 4: 4;

                        if(state.stateStatus == StopwatchStateStatus.servicing || state.stateStatus == StopwatchStateStatus.runInProgress)
                          {
                            offset = 14;
                          }
                        offset -= bottomPaddingHeight;
                        return Padding(
                            padding: EdgeInsets.only(
                              bottom: controlPanelHeight / 2 - offset),
                            child: GestureDetector(
                                onTap: () async {
                                  isSimulation = false;
                                  if (state.stateStatus == StopwatchStateStatus.runInProgress || state.stateStatus == StopwatchStateStatus.servicing) {
                                    _showDialogConfirmStop(context);
                                  }
                                  // else {
                                  //   controller.reset();
                                  // }
                                  if (!MapHelper().isSendingMqtt) {
                                    MapHelper().polylineModelInfo = PolylineModelInfo();
                                    polyline =[];
                                    context.read<StopwatchBloc>().add(StartStopwatch());
                                    await _startSendMessageMqtt(context, isSimulation: false);
                                    setState(() {
                                      onStart = true;
                                    });
                                    _focusOnMyLocation();
                                  }
                                },
                                child: LayoutBuilder(builder: (context, constraints) {
                                  if(state.stateStatus == StopwatchStateStatus.servicing)
                                  {
                                    return AnimatedGradientBorder(
                                      glowSize: 0,
                                      borderSize: 5,
                                      borderRadius: BorderRadius.circular(999),
                                      gradientColors: [
                                        Color(0xff2abb04),
                                        Color(0xff2abb04),
                                        ConstColors.primaryContainerColor,
                                      ],
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ConstColors.primaryContainerColor,
                                          shape: BoxShape.circle,
                                        ),
                                        width: startButtonSize,
                                        height: startButtonSize,
                                        child: Center(
                                          child: Text(L10nX.getStr.servicing,
                                            style: ConstFonts()
                                                .copyWithHeading(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff01113b)
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  else if(state.stateStatus == StopwatchStateStatus.runInProgress) {
                                    return AnimatedGradientBorder(
                                      glowSize: 0,
                                      borderSize: 5,
                                      borderRadius: BorderRadius.circular(999),
                                      gradientColors: [
                                        Color(0xffCC0000),
                                        Color(0xffCC0000),
                                        ConstColors.errorContainerColor,
                                      ],
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ConstColors.errorColor,
                                          shape: BoxShape.circle,
                                        ),
                                        width: startButtonSize,
                                        height: startButtonSize,
                                        child: Center(
                                          child: Text(
                                            ResponsiveInfo.isTablet()?L10nX.getStr.code_3_deactivate:L10nX.getStr.stop,
                                            style: ConstFonts().copyWithHeading(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  else
                                  {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: ConstColors.tertiaryContainerColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: ConstColors.tertiaryColor , width: 8)
                                      ),
                                      width: startButtonSize + 8,
                                      height: startButtonSize + 8,
                                      child: Center(
                                        child: Text(ResponsiveInfo.isTablet()?L10nX.getStr.code_3_activate:L10nX.getStr.start,
                                          style: ConstFonts()
                                              .copyWithHeading(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                },)
                            ));
                      },
                    ),
                  ]
                ),
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: pedCommandBox(),
            ),

            if (kDebugMode) Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message.toString(),
              ),
            ),



          ],
        ),
      )
    );
  }

  Widget pedCommandBox() {
    return Visibility(
      visible: (iShowEvent && MapHelper().logEventService != null),
      child: CommandBox(
        iShowEvent: iShowEvent && MapHelper().logEventService!=null,
        key: Key("${MapHelper().logEventService?.nodeId}_${MapHelper().logEventService?.state}_${MapHelper().logEventService?.time}_EventLogService"),
        trackingEvent: MapHelper().logEventService,
        onSendServiceControl: (p0) {
          iShowEvent= false;
          stopwatchBlocContext.read<StopwatchBloc>().add(ServicingStopwatch());
          setState((){
            onService = true;
          });
        },
        onCancel: (p0) {
          setState(() {
            iShowEvent= false;
            MapHelper().logEventService=null;
            MapHelper().logEventNormal= null;
          });
        },
        onDispose: () {
          iShowEvent= false;
        },

      ),
    );
  }

  Future<void> _initLocationService({required BuildContext context}) async {
    await MapHelper().checkLocationService(whenDisabled: () {
      QuickAlert.show(
        context: context,
        title: L10nX.getStr.location_service_disabled_title,
        text: L10nX.getStr.location_service_disabled_message,
        type: QuickAlertType.warning,
        confirmBtnColor: ConstColors.primaryColor,
      );
    }, whenEnabled: () {

    });

    print("check location getPermission");
    if (await MapHelper().getPermission()) {
      print("has location getPermission");
      MapHelper().getMyLocation(
        intervalDuration: Duration(seconds: 1),
        streamLocation: true,
        onChangePosition: (p0) {
          //print("onChangePosition:${p0?.toJson().toString()}");
          if (_rotateMapTimer == null || !_rotateMapTimer!.isActive ) {
            _rotateMap();
          }
          MapHelper().location = p0;
          MapHelper().polylineModelInfo.addPolylinePoints(
              point: LatLng(MapHelper().location?.latitude??0, MapHelper().location?.longitude??0),
            position:  MapHelper().location!
          );
          _updateMyLocationMarker();
        },
      );
    }
  }

  void onCameraMove(CameraPosition cameraPosition) {
    _bearing = cameraPosition.bearing;
    _updateMyLocationMarker();
    if (_isAnimatingCamera) {
      return;
    }
    focusOnMyLocation = false;
    _rotateMapTimer?.cancel();
    _rotateMapTimer = Timer(Duration(seconds: (onStart) ? 5: 30), () {
      _rotateMap();
      if(mounted) {
        setState(() {
        _isAnimatingCamera = true;
      });
      }
    });
  }

  void onCameraIdle()  async {
    if (onCameraIdleRunning) return;

    onCameraIdleRunning = true;
    if (previousPosition == null || previousCenterCameraPosition==null) {
      previousPosition = await MapHelper().getCurrentPosition();
      previousZoomLevel = await MapHelper().controller?.getZoomLevel();
      previousCenterCameraPosition = await MapHelper().controller?.getLatLng(ScreenCoordinate(x: 0, y: 0));
      onCameraIdleRunning = false;
    } else {
      Position? currentPos = await MapHelper().getCurrentPosition();
      double? currentZoomLevel = await MapHelper().controller?.getZoomLevel();
      centerCameraPosition = await MapHelper().controller?.getLatLng(ScreenCoordinate(x: 0, y: 0));
      double movingDistance = MapHelper().calculateDistance(
          LatLng(currentPos!.latitude, currentPos.longitude),
          LatLng(previousPosition!.latitude, previousPosition!.longitude));
      double cameraDistance = MapHelper().calculateDistance(
          LatLng(previousCenterCameraPosition?.latitude??0, previousCenterCameraPosition?.longitude??0),
          LatLng(centerCameraPosition?.latitude??0, centerCameraPosition?.longitude??0));
      if (movingDistance > 5) {
        /// call api when user move more than 5 meters
        previousPosition = currentPos;
        await   _getVector(isReload: true, location: centerCameraPosition);
        setState(() {
          onCameraIdleRunning = false;
        });
      } else if (currentZoomLevel != previousZoomLevel) {
        /// call api when zooming
        previousZoomLevel = currentZoomLevel;
        await _getVector(isReload: true, location: centerCameraPosition);
        setState(() {
          onCameraIdleRunning = false;
        });
      } else if (cameraDistance > 2000) {
        /// call api when move camera more than 5000 meters
        await _getVector(location: centerCameraPosition, isReload: true);
        previousCenterCameraPosition = centerCameraPosition;
        setState(() {
          onCameraIdleRunning = false;

        });
      }
      else
        {
          onCameraIdleRunning = false;

        }
    }
  }

  void _focusOnMyLocation() async {
    // await MapHelper().getCurrentLocationData();
    if (!onStart) {
      MapHelper().location = (await MapHelper().getCurrentPosition())! ;
      _isAnimatingCamera = true;
      MapHelper().controller?.animateCamera(
          CameraUpdate.newLatLng(LatLng(MapHelper().location?.latitude??0, MapHelper().location?.longitude??0))).then((_) {
        _isAnimatingCamera = false;});
    } else {
      _rotateMap();
    }
  }

  Future<void> _startSendMessageMqtt(BuildContext context, {bool ?isSimulation}) async {
    if(!(isSimulation??false)){
      MapHelper().isSendingMqtt = true;
    }
    await _connectMQTT(context: context, isSimulation: isSimulation);
    if (await MapHelper().getPermission()) {
      LocationService().setCurrentTimeZone(currentTimeZone);
      LocationService().setMqttServerClientObject(MQTTManager().mqttServerClientObject);
      await LocationService().startService(
        isSimulation: isSimulation??true,
        onRecivedData: (p0) {

        },
        onCallbackInfo: (p0) {
          if (kDebugMode) {
          }
        },
      );
    }
    try{
      await initializeBackGroundService(); // this should use the `Navigator` to push a new route
    }
    catch(e){

    }
  }


  Future<void> _getVector({LatLng? location, bool? isReload}) async {
    double? distance = await calculateDistance();
    GetVectorApi getVectorApi = GetVectorApi(distance, location);
    try {
      vectorModel = await getVectorApi.call();
      if(isReload??false)
        {
          polygon.clear();
          circle.clear();
        }
      vectorModel.list?.forEach((item) {
        String vector = item.areaJson??"";
        String position = item.positionJson??"";
        String id = item.id.toString();
        double inner = item.inner ?? 0;
        double middle = item.middle ?? 0;
        double outer = item.outer ?? 0;
        double outer4 = item.outer4 ?? 0;

        Polyline polyline2 = getPolylineFromVector(vector, position, id);
        Color normalstatus = Color(0xff0000ff);

        // if ((MapHelper().vectorStatus != null) && (MapHelper().vectorStatus!.vectorId == int.parse(id))) {
        //   _addPolygon(polyline2.points, Colors.orangeAccent.withOpacity(0.3), id);
        // } else {
          _addPolygon(polyline2.points, normalstatus.withOpacity(0.1), id);
        // }

        _addCirclePolygon(center:position, radius:inner, id:id, fillColor:normalstatus.withOpacity(0.05), index:7);
        _addCirclePolygon(center:position, radius:middle, id:id, fillColor:normalstatus.withOpacity(0.05), index:5);
        _addCirclePolygon(center:position, radius:outer, id:id, fillColor:normalstatus.withOpacity(0.05), index:3);
        _addCirclePolygon(center:position, radius:outer4, id:id, fillColor:normalstatus.withOpacity(0.05), index:1);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _addCirclePolygon(
      {required String center, required double radius, required String id, required Color fillColor, required int index}) {
    double lat = double.tryParse(center.split(' ').last) ?? 0;
    double lng = double.tryParse(center.split(' ').first) ?? 0;

    bool exists = circle.any((circle) =>
    circle.circleId.value == "${id}_$radius");
    Color normalstatus = Color(0xff0000ff);
    if (!exists) {
      circle.add(Circle(
        circleId: CircleId("${id}_$radius"),
        center: LatLng(lat, lng),
        radius: radius,
        fillColor: fillColor,
        strokeWidth: 1,
        strokeColor: normalstatus.withOpacity(0.5),
        zIndex: index,
      ));
    }
  }

  void _addPolygon(List<LatLng> points, Color fillColor, String id) {
    bool exists = polygon.any((polygon) =>
    polygon.polygonId.value == id);
    Color normalstatus = Color(0xff0000ff);

    if (!exists) {
      polygon.add(Polygon(
        polygonId: PolygonId(id),
        points: points,
        fillColor: fillColor,
        strokeColor:normalstatus.withOpacity(0.5),
        strokeWidth: 1,
      ));
    }
  }


  Future<double?> calculateDistance() async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    const double earthCircumference = 40075016.686;
    const int tileSize = 256;

    double? zoomLevel = await MapHelper().controller?.getZoomLevel();

    if (zoomLevel == null) return null;

    // distancePerPixel(meters)
    double distancePerPixel = earthCircumference / (tileSize * pow(2, zoomLevel));

    double radius = (height > width) ? height / 2 : width / 2;
    return distancePerPixel * radius / 1000;
  }

  Polyline getPolylineFromVector(String vector, String position, String name) {
    List<LatLng> latLngs = [];
    List<String> coordinates = vector.split(' ');
    if(coordinates.length>1)
      {
        for (int i = 0; i < coordinates.length / 2; i++) {
          latLngs.add(LatLng(
            double.parse(coordinates[2 * i + 1]),
            double.parse(coordinates[2 * i]),
          ));
        }
      }
    return Polyline(
      polylineId: PolylineId(name),
      points: latLngs,
      color: Colors.blue,
      width: 2,
    );
  }

  String standardizeString(String s) {
    return s
        .replaceAll('POLYGON', '')
        .replaceAll('POINT', '')
        .replaceAll(')', '')
        .replaceAll('(', '')
        .replaceAll(',', ' ')
        .replaceAll('  ', ' ')
        .trim();
  }

  void _showDialogConfirmStop(BuildContext context) {
    showDialog(
        context: context,
        builder: (newContext) => PopScope(
              onPopInvoked: (value) {
                context.read<StopwatchBloc>().add(ResumeStopwatch());
              },
              child: AlertDialog(
                backgroundColor: ConstColors.tertiaryContainerColor,
                icon: Icon(
                  Icons.location_off_rounded,
                  color: Colors.white,
                  size: itemSize,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      L10nX.getStr.stop_tracking_title,
                      style: ConstFonts().copyWithTitle(fontSize: 19),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(L10nX.getStr.stop_tracking_message,
                        style: ConstFonts().copyWithSubHeading(fontSize: 15)),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Button(
                            width: 80,
                            height: 40,
                            color: ConstColors.errorContainerColor,
                            isCircle: false,
                            child: TextButton(
                              onPressed: () async {
                                context
                                    .read<StopwatchBloc>()
                                    .add(ResumeStopwatch());
                                Navigator.pop(context);
                              },
                              child: Text(L10nX.getStr.no,
                                  style:
                                      ConstFonts().copyWithTitle(fontSize: 16)),
                            )).getButton(),
                        Button(
                            width: 80,
                            height: 40,
                            color: ConstColors.primaryColor,
                            isCircle: false,
                            child: TextButton(
                              onPressed: () async {
                                MapHelper().dispose();
                                Navigator.pop(context);
                                _rotateMapTimer?.cancel();
                                MapHelper()
                                    .timerLimitOnChangeLocation
                                    ?.cancel();
                                MapHelper().timerLimitOnChangeLocation = null;
                                //await LocationService().stopService();

                                MapHelper().isSendingMqtt = false;
                                context.read<StopwatchBloc>().add(ResetStopwatch());
                                await LocationService().stopService();
                                controller.reset();
                                setState(() {
                                  onService = false;
                                  onStart = false;
                                });
                              },
                              child: Text(L10nX.getStr.yes,
                                  style:
                                      ConstFonts().copyWithTitle(fontSize: 16)),
                            )).getButton(),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  Widget _controlPanelMobile({required double width, required double height}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPaddingHeight),
      child: BlocBuilder<StopwatchBloc, StopwatchState>(
        builder: (context, state) {
          return ClipPath(
            clipper: CustomContainerMobile(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ConstColors.tertiaryContainerColor,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: width - 30,
              height: controlPanelHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildVehicleWidget(isTablet: false),
                        IconButton(
                          icon: Icon(Icons.my_location,  color: Colors.white,),
                          onPressed: () {
                            _focusOnMyLocation();
                            focusOnMyLocation = true;
                            // _openNodeLocation();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<StopwatchBloc, StopwatchState>(
                            builder: (context, state) {
                              return _stopwatchText(context, state);
                            },
                          ),
                          // Text('${(MapHelper().getSpeed()).toStringAsFixed(0) ?? 0} ${AppSetting.getSpeedUnit}', style: ConstFonts().subHeading,)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<MapBloc, MapState>(builder: (context, state) {
                          return state.mapType == MapType.normal
                              ? IconButton(
                            icon: Icon(Icons.layers, color: Colors.white,),
                            onPressed: () async {
                              context.read<MapBloc>().add(SatelliteMapEvent());
                            },
                          )
                              : IconButton(
                            icon: Icon(Icons.satellite_alt, color: Colors.white,),
                            onPressed: () {
                              context.read<MapBloc>().add(NormalMapEvent());
                            },
                          );
                        }),
                        IconButton(
                          icon: Icon(Icons.settings, color: Colors.white,),
                          onPressed: () {
                            // context.go('/map/setting', extra: context.read<VehiclesBloc>());
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => SettingUi(vehiclesBloc: context.read<VehiclesBloc>())));
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget buildVehicleWidget({bool? isTablet}){
    return BlocConsumer<VehiclesBloc, VehiclesState>(
      listener: (context, state) {
        switch(state.blocStatus)
        {
          case BlocStatus.success:
          // TODO: Handle this case.
            isSimulation = true;
            _startSendMessageMqtt(context, isSimulation: true);
            break;
          default:
            break;
        }

      },
      builder: (context, vehicleState) {
        return CustomDropdown(
          size: (isTablet??false)? 75:45,
          currentVehicle: vehicleState.vehicleType,
          onSelected: (VehicleTypeInfo? selectedVehicle) async{
            iShowEvent= false;
            if (selectedVehicle != null) {
              context.read<VehiclesBloc>().add(OnChangeVehicleEvent(selectedVehicle));
            }
          },
        );
      },
    );
  }

  Widget _controlPanelTablet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPaddingHeight),
        child: ClipPath(
          clipper: CustomContainerTablet(),
          child: Container(
            color: ConstColors.tertiaryContainerColor,
            height: controlPanelHeight,
            width: MediaQuery.of(context).size.shortestSide * 0.9,
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimens.size50Horizontal,
                  right: Dimens.size50Horizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildVehicleWidget(isTablet: true),
                        IconButton(
                          icon: Icon(Icons.my_location,  color: Colors.white,size: 45,),
                          onPressed: () {
                            _focusOnMyLocation();
                            // _openNodeLocation();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<StopwatchBloc, StopwatchState>(
                            builder: (context, state) {
                              return _stopwatchText(context, state);
                            },
                          ),
                          // Text('${(MapHelper().getSpeed()).toStringAsFixed(0) ?? 0} ${AppSetting.getSpeedUnit}', style: ConstFonts().subHeading,)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<MapBloc, MapState>(builder: (context, state) {
                          return state.mapType == MapType.normal
                              ? IconButton(
                            icon: Icon(Icons.layers, color: Colors.white,size: 45,),
                            onPressed: () async {
                              context.read<MapBloc>().add(SatelliteMapEvent());
                            },
                          )
                              : IconButton(
                            icon: Icon(Icons.satellite_alt, color: Colors.white,),
                            onPressed: () {
                              context.read<MapBloc>().add(NormalMapEvent());
                            },
                          );
                        }),
                        IconButton(
                          icon: Icon(Icons.settings, color: Colors.white, size: 45,),
                          onPressed: () {
                            // context.go('/map/setting', extra: context.read<VehiclesBloc>());
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => SettingUi(vehiclesBloc: context.read<VehiclesBloc>())));
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stopwatchText(BuildContext context, StopwatchState state) {
    final duration = state.duration??0;
    final hoursStr =
        ((duration / 3600) % 60).floor().toString().padLeft(2, '0');
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$hoursStr:$minutesStr:$secondsStr',
      style: ResponsiveInfo.isTablet()
          ? ConstFonts().copyWithInformation(fontSize: 30)
          : ConstFonts().information,
    );
  }

  Future<void> _addMarkers(LatLng? position, int vehicleType) async {
    if (position == null) {
      VehicleTypeInfo? vehicleTypeInfo  =  await InstanceManager().getVehicleTypeInfoById(vehicleType);
      Marker current = await MapHelper().getMarkerFromBytes(
          latLng: LatLng(MapHelper().location?.latitude??0, MapHelper().location?.longitude??0),
          image:await vehicleTypeInfo?.getBytesIcon(),
          rotation: (await MapHelper().getCurrentPosition())?.heading ?? 0);
      MapHelper().myLocationMarker = current;
    }
      if (position != null) {
        if (!showInfoBox) {
          selectedMarker.add(
            Marker(
              markerId: MarkerId(position.toString()),
              position: position,
              infoWindow: InfoWindow(title: 'title', snippet: 'snippet'),
            ),
          );
        }

        showInfoBox = true;
        destination = position;
      }
  }
  Future<void> _updateMyLocationMarker() async {
    Position? position = await MapHelper().getCurrentPosition();
    double? zoomLevel = await MapHelper().controller?.getZoomLevel();
    VehicleTypeInfo? vehicleTypeInfo =await userDetail?.getVehicleTypeInfo();
    Marker current = await MapHelper().getMarkerFromBytes(
        markerId: 'mylocation',
        latLng: LatLng(position!.latitude, position.longitude),
        image:await vehicleTypeInfo?.getBytesIcon(),
        rotation: (onStart) ? 0 : position.heading - _bearing,
      );

    if (focusOnMyLocation) {
      MapHelper().controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            bearing: position.heading,
            zoom: zoomLevel??0
        ),
      ),
    );
    }
    MapHelper().myLocationMarker = current;
    setState(() {});
  }

  Future<void> _rotateMap() async {
    Position? position = await MapHelper().getCurrentPosition();
    if(mounted)
      {
        double? zoomLevel = await MapHelper().controller?.getZoomLevel();
        _isAnimatingCamera = true;
        // _rotateMapTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
        MapHelper().controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position!.latitude, position.longitude),
                bearing: position.heading,
                zoom: zoomLevel??0
            ),
          ),
        ).then((_) {
          _isAnimatingCamera = false;});
      }
  }
  void _removeMarkers() {
    selectedMarker.clear();
  }

  Widget infoBox() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
              color: ConstColors.onPrimaryColor,
              borderRadius: BorderRadius.circular(20)),
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.height / 20,
                        backgroundImage:
                            const AssetImage('assets/images/profile.png'),
                        backgroundColor: ConstColors.secondaryColor,
                      ),
                    ),
                    Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("vectorId: ${MapHelper().vectorStatus!.vectorId}"),
                                  Text("vectorStatus: ${MapHelper().vectorStatus!.vectorStatus}"),
                                  Text("updatedAt: ${MapHelper().vectorStatus!.updatedAt}"),
                                  Text("customerId: ${MapHelper().vectorStatus!.customerId}"),
                                  Text("processUser: ${MapHelper().vectorStatus!.processUser}"),
                                  Text("serviceUser: ${MapHelper().vectorStatus!.serviceUser}"),
                                  Text("totalUser: ${MapHelper().vectorStatus!.totalUser}"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          showInfoBox = false;
                                          distance = 0;
                                          _removeMarkers();
                                        });
                                      },
                                      child: Button(
                                              width: 40,
                                              height: 40,
                                              color: ConstColors.onPrimaryColor,
                                              isCircle: false,
                                              child: Icon(Icons.keyboard_return,
                                                  color:
                                                      ConstColors.primaryColor))
                                          .getButton()),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        // EasyLoading.show(status: '');
                                        // polyline = await MapHelper.getInstance().getPolylines(current: initialPosition, destination: destination);
                                        // EasyLoading.dismiss();
                                        setState(() {
                                          distance = MapHelper()
                                              .calculateDistance(
                                              LatLng(MapHelper().location?.latitude??0, MapHelper().location?.longitude??0), destination);
                                        });
                                      },
                                      child: Button(
                                              width: 40,
                                              height: 40,
                                              color: ConstColors.onPrimaryColor,
                                              isCircle: false,
                                              child: Icon(Icons.directions,
                                                  color:
                                                      ConstColors.primaryColor))
                                          .getButton()),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VecterDetail? getVectorDetailById(String id) {
    return vectorModel.list?.firstWhere(
          (item) => item.id.toString() == id,
      orElse: () => VecterDetail(),
    );
  }

  final Map<String, Timer?> _checkTimeout = {};

  void _onVectorStatusChange({required VectorStatusInfo vectorStatus}) {
    polygon.removeWhere((polygon) {
      return polygon.polygonId == PolygonId(vectorStatus.vectorId.toString());
    });

    VecterDetail? vectorDetail = getVectorDetailById(vectorStatus.vectorId.toString());

    if (vectorDetail == null) {
      return;
    }

    final String position = vectorDetail.positionJson ?? "";
    final String vector = vectorDetail.areaJson ?? "";

    Polyline polyline2 = getPolylineFromVector(vector, position, vectorStatus.vectorId.toString());

    polygon.add(Polygon(
      polygonId: PolygonId(vectorStatus.vectorId.toString()),
      points: polyline2.points,
      fillColor: vectorStatus.getStatusColor().withOpacity(0.1),
      strokeColor: vectorStatus.getStatusColor(),
      strokeWidth: 1,
    ));

    //Check time out
    if (vectorStatus.vectorStatus == 2 || vectorStatus.vectorStatus == 1) {
      _checkTimeout[vectorStatus.vectorId.toString()]?.cancel();
      _checkTimeout[vectorStatus.vectorId.toString()] = Timer(Duration(seconds: 30), () {
        _onVectorStatusChange(vectorStatus: vectorStatus.copyWith(
          vectorStatus: 0,
          vectorStatusType: VectorStatus.Normal,
        ));
      });
    }

    setState(() {});
  }
}