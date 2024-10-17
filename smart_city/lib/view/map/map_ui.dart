import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/resizer/fetch_pixel.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_alert_dialog.dart';
import 'package:smart_city/base/widgets/custom_circular_countdown_timer.dart';
import 'package:smart_city/base/widgets/custom_container.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/constant_value/const_size.dart';
import 'package:smart_city/controller/helper/map_helper.dart';
import 'package:smart_city/controller/node/get_all_node.dart';
import 'package:smart_city/controller/node/get_node_api.dart';
import 'package:smart_city/controller/stopwatch_bloc/stopwatch_bloc.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
import 'package:smart_city/model/notification/notification.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/view/map/component/notification_manager.dart';
import 'package:smart_city/view/map/component/notification_screen.dart';
import '../../base/sqlite_manager/sqlite_manager.dart';
import '../../helpers/services/location_service.dart';
import '../../l10n/l10n_extention.dart';
import '../../model/node/all_node_phase.dart';
import '../../model/node/node_model.dart';
import '../../model/user/user_info.dart';
import '../../mqtt_manager/MQTT_client_manager.dart';
import '../../mqtt_manager/mqtt_object/location_info.dart';
import 'component/custom_drop_down_map.dart';
import 'map_bloc/map_bloc.dart';
import 'dart:async';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz1;
import 'package:flutter_timezone/flutter_timezone.dart';

class MapUi extends StatefulWidget {
  const MapUi({super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}

class _MapUiState extends State<MapUi> with SingleTickerProviderStateMixin {
  late GoogleMapController _controller;
  late String _mapStyleString = '';
  bool hidden = true;
  bool showInfoBox = false;
  bool focusOnMyLocation = true;
  LatLng myLocation = MapHelper.currentLocation ?? const LatLng(0, 0);
  LatLng destination = const LatLng(0, 0);
  double distance = 0.0;
  List<Polyline> polyline = [];
  LocationInfo? locationInfo;
  LocationService locationService = LocationService();
  late Map<VehicleType, String> transport;
  UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
  UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();

  List<NotificationModel> notifications = [
    NotificationModel(msg: 'congratulation', dateTime: DateTime.now()),
    NotificationModel(
        msg: 'welcome', dateTime: DateTime.now().subtract(Duration(days: 1))),
    NotificationModel(
        msg: 'new_message',
        dateTime: DateTime.now().subtract(Duration(hours: 2))),
    NotificationModel(
        msg: 'event_reminder',
        dateTime: DateTime.now().subtract(Duration(days: 3))),
    NotificationModel(
        msg: 'account_update',
        dateTime: DateTime.now().subtract(Duration(days: 5))),
    NotificationModel(
        msg: 'new_friend_request',
        dateTime: DateTime.now().subtract(Duration(hours: 1))),
    NotificationModel(
        msg: 'birthday_greeting',
        dateTime: DateTime.now().subtract(Duration(days: 7))),
    NotificationModel(
        msg: 'special_offer',
        dateTime: DateTime.now().subtract(Duration(days: 10))),
    NotificationModel(
        msg: 'news_update',
        dateTime: DateTime.now().subtract(Duration(hours: 3))),
    NotificationModel(
        msg: 'security_alert',
        dateTime: DateTime.now().subtract(Duration(days: 15))),
  ];

  MqttServerClientObject? mqttServerClientObject;
  StreamSubscription<Position>? _positionStreamSubscription;
  late AnimationController controller;
  late Animation<double> animation;
  late List<Marker> markers;
  late List<Marker> myLocationMarker;
  late List<Marker> selectedMarker;
  late List<Marker> nodeMarker;
  late List<NodeModel> listNode;
  late String? currentTimeZone;

  @override
  void initState() {
    NotificationManager.instance.init(notifications);
    super.initState();
    tz.initializeTimeZones();
    //_initLocationService();
    // mapHelper.listenLocationUpdate();
    DefaultAssetBundle.of(context)
        .loadString('assets/dark_mode_style.json')
        .then((string) {
      _mapStyleString = string;
    });
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
    markers = [];
    selectedMarker = [];
    myLocationMarker = [];
    nodeMarker = [];
    _getVehicle();
    _connectMQTT();
    _getNode();
    _getLocal();
    _initLocationService();
  }

  _connectMQTT() async {
    try {
      mqttServerClientObject ??=
          await MQTTManager().initialMQTTTrackingTopicByUser(
        onConnected: (p0) async {
          // if (mqttServerClientObject != null) {
          //   await MQTTManager().sendMessageToATopic(
          //     newMqttServerClientObject: mqttServerClientObject!,
          //     message: "hrm.location.4.372",
          //     onCallbackInfo: (p0) {},
          //   );
          // }
          print('connected');
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  _getLocal() async {
    currentTimeZone = await FlutterTimezone.getLocalTimezone();
  }

  _getVehicle() {
    if (ResponsiveInfo.isTablet()) {
      transport = {
        VehicleType.truck: 'assets/fire-truck.png',
        VehicleType.car: 'assets/sport-car.png',
      };
      if (userInfo?.typeVehicle == "truck") {
        _addMarkers(null, VehicleType.truck);
      } else {
        _addMarkers(null, VehicleType.car);
      }
    } else {
      transport = {
        VehicleType.cyclists: 'assets/cycling.png',
        VehicleType.pedestrians: 'assets/pedestrians.png',
      };
      if (userInfo?.typeVehicle == "cyclists") {
        _addMarkers(null, VehicleType.cyclists);
      } else {
        _addMarkers(null, VehicleType.pedestrians);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    MapHelper.getInstance().dispose();
    controller.dispose();
    locationService.stopService();
    MQTTManager.getInstance.disconnectAndRemoveAllTopic();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    markers.clear();
    markers.addAll(myLocationMarker);
    markers.addAll(selectedMarker);
    markers.addAll(nodeMarker);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MapBloc()),
          BlocProvider(create: (_) => StopwatchBloc()),
        ],
        child: Scaffold(
          body: Stack(
            children: [
              SizedBox(
                width: width,
                height: height,
              ),
              BlocBuilder<MapBloc, MapState>(
                builder: (context, mapState) {
                  return BlocConsumer<VehiclesBloc, VehiclesState>(
                    listener: (context, vehiclesBloc) {
                      _changeVehicle(vehiclesBloc.vehicleType);
                    },
                    builder: (context, vehicleState) {
                      return GoogleMap(
                        markers: Set.from(markers),
                        onTap: (position) {
                          _addMarkers(position, vehicleState.vehicleType);
                        },
                        // style: _mapStyleString,
                        mapType: mapState.mapType,
                        myLocationEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: myLocation,
                          zoom: 16,
                        ),
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        trafficEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          context.read<MapBloc>().add(NormalMapEvent());
                        },
                        polylines: (distance > 0) ? polyline.toSet() : {},
                      );
                    },
                  );
                },
              ),

              Positioned(
                  top: Dimens.size50Vertical,
                  right: Dimens.size15Horizontal,
                  child: SizedBox(
                    height: 270,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _controlButton(
                            icon: Icons.my_location,
                            onPressed: () {
                              _controller.animateCamera(
                                  CameraUpdate.newLatLng(myLocation));
                              setState(() {
                                focusOnMyLocation = true;
                              });
                            },
                            color: ConstColors.tertiaryColor),
                        _controlButton(
                            icon: Icons.notifications,
                            onPressed: () {
                              _openNotification();
                            },
                            color: ConstColors.tertiaryColor),
                        _controlButton(
                            icon: Icons.location_on,
                            onPressed: () {
                              _openNodeLocation();
                            },
                            color: ConstColors.tertiaryColor),
                        _controlButton(
                            icon: Icons.settings,
                            onPressed: () {
                              context.go('/map/setting');
                            },
                            color: ConstColors.tertiaryColor),
                        BlocBuilder<MapBloc, MapState>(
                            builder: (context, state) {
                          return state.mapType == MapType.normal
                              ? _controlButton(
                                  icon: Icons.layers,
                                  onPressed: () {
                                    // _showModalBottomSheet(context, state);
                                    context
                                        .read<MapBloc>()
                                        .add(SatelliteMapEvent());
                                  },
                                  color: ConstColors.tertiaryColor)
                              : _controlButton(
                                  icon: Icons.satellite_alt,
                                  onPressed: () {
                                    // _showModalBottomSheet(context, state);
                                    context
                                        .read<MapBloc>()
                                        .add(NormalMapEvent());
                                  },
                                  color: ConstColors.tertiaryColor);
                        }),
                      ],
                    ),
                  )),

              //countdown animation
              Builder(builder: (context) {
                return Align(
                  alignment: Alignment.center,
                  child: hidden
                      ? const SizedBox()
                      : CustomCircularCountdownTimer(
                          onCountdownComplete: () {
                            context.read<StopwatchBloc>().add(StartStopwatch());
                          },
                        ),
                );
              }),

              //control panel
              ResponsiveInfo.isPhone()
                  ? _controlPanelMobile(width: width, height: height)
                  : _controlPanelTablet(),

              // stopwatch text mobile
              ResponsiveInfo.isPhone()
                  ? Padding(
                      padding: EdgeInsets.only(
                          bottom: FetchPixel.getPixelHeight(85, false)),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: BlocBuilder<StopwatchBloc, StopwatchState>(
                          builder: (context, state) {
                            return _stopwatchText(context, state);
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),

              // start/stop button tablet
              ResponsiveInfo.isTablet()
                  ? Padding(
                      padding: controller.isCompleted
                          ? const EdgeInsets.only(bottom: 55)
                          : const EdgeInsets.only(bottom: 85),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: BlocBuilder<StopwatchBloc, StopwatchState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  if (state is StopwatchRunInProgress) {
                                    context
                                        .read<StopwatchBloc>()
                                        .add(ResetStopwatch());
                                    controller.reset();
                                  }
                                },
                                onLongPress: () {
                                  controller.forward();
                                  controller.addStatusListener((status) {
                                    if (status == AnimationStatus.completed) {
                                      context
                                          .read<StopwatchBloc>()
                                          .add(StartStopwatch());
                                    }
                                  });
                                },
                                onLongPressEnd: (details) {
                                  if (!controller.isCompleted) {
                                    context
                                        .read<StopwatchBloc>()
                                        .add(ResetStopwatch());
                                    controller.reset();
                                    _startSendMessageMqtt();
                                  }
                                },
                                child: !controller.isCompleted
                                    ? AnimatedBuilder(
                                        animation: animation,
                                        builder: (context, child) {
                                          return CustomPaint(
                                            foregroundPainter: BorderPainter(
                                                currentState: controller.value),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: ConstColors
                                                      .tertiaryContainerColor,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: ConstColors
                                                          .tertiaryColor,
                                                      width: 8),
                                                ),
                                                width: 150,
                                                height: 150,
                                                child: Center(
                                                  child: Text(
                                                      L10nX.getStr
                                                          .code_3_activate,
                                                      style: ConstFonts()
                                                          .copyWithHeading(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                )),
                                          );
                                        })
                                    : AnimatedGradientBorder(
                                        borderSize: 10,
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        gradientColors: const [
                                          Color(0xffCC0000),
                                          Color(0xffCC0000),
                                          ConstColors.errorContainerColor,
                                        ],
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: ConstColors.errorColor,
                                            shape: BoxShape.circle,
                                          ),
                                          width: 150,
                                          height: 150,
                                          child: Center(
                                              child: Text(
                                                  L10nX
                                                      .getStr.code_3_deactivate,
                                                  style: ConstFonts()
                                                      .copyWithHeading(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .w600))),
                                        ),
                                      ),
                              );
                            },
                          )),
                    )
                  : const SizedBox(),

              if (showInfoBox)
                Padding(
                    padding: EdgeInsets.only(
                      top: Dimens.size50Vertical,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        infoBox(destination),
                      ],
                    ))
            ],
          ),
        ));
  }

  void _initLocationService() async {
    await MapHelper.getInstance().checkLocationService(whenDisabled: () {
      QuickAlert.show(
        context: context,
        title: L10nX.getStr.location_service_disabled_title,
        text: L10nX.getStr.location_service_disabled_message,
        type: QuickAlertType.warning,
        confirmBtnColor: ConstColors.primaryColor,
      );
    }, whenEnabled: () {
      // if (focusOnMyLocation) {
      //   _controller
      //       .animateCamera(CameraUpdate.newLatLng(MapHelper.currentLocation));
      //   _updateMyLocationMarker();
      // }
    });

    if (await MapHelper.getInstance().getPermission()) {
      _positionStreamSubscription =
          Geolocator.getPositionStream().listen((Position position) async {
            if (focusOnMyLocation) {
              _controller.animateCamera(CameraUpdate.newLatLng(
                  LatLng(position.latitude, position.longitude)));
            }
            MapHelper.getInstance().updateCurrentLocation(
                LatLng(position.latitude, position.longitude));
            _updateMyLocationMarker();
          });
    }
  }

  void _startSendMessageMqtt() async {
    // Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   await MapHelper.getInstance().getCurrentLocation;
    //
    //   String time = await _getTimeZoneTime();
    //
    //   Position position = MapHelper.currentPosition;
    //   locationInfo = LocationInfo(
    //       latitude: position.latitude,
    //       longitude: position.longitude,
    //       // altitude: position.longitude,
    //       speed: (position.speed).toInt(),
    //       heading: (position.heading).toInt(),
    //       // address: address,
    //       createdAt: time);
    //
    //   await MQTTManager().sendMessageToATopic(
    //     newMqttServerClientObject: mqttServerClientObject!,
    //     message: jsonEncode(locationInfo!.toJson()),
    //     onCallbackInfo: (p0) {
    //       if (kDebugMode) {
    //         // InstanceManager().showSnackBar(
    //         //     context: context, text: locationInfo!.toJson().toString());
    //       }
    //     },
    //   );
    // });

    if (await MapHelper.getInstance().getPermission()) {
    // _sendMessageMqtt();
    locationService.setCurrentTimeZone(currentTimeZone);
    locationService.setMqttServerClientObject(mqttServerClientObject);
    locationService.startService();
    }
  }

  void _showModalBottomSheet(BuildContext context, MapState state) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (newContext) {
          bool isSelected = state.mapType == MapType.normal;
          return StatefulBuilder(builder: (newContext, StateSetter setState) {
            return Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: ConstColors.surfaceColor,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: Dimens.size40Vertical),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _mapTypeButton(
                          title: L10nX.getStr.normal_map,
                          onPressed: () {
                            context.read<MapBloc>().add(NormalMapEvent());
                            setState(() {
                              isSelected = true;
                            });
                          },
                          image: "assets/normal_map.png",
                          isSelected: isSelected),
                      _mapTypeButton(
                          title: L10nX.getStr.satellite_map,
                          onPressed: () {
                            context.read<MapBloc>().add(SatelliteMapEvent());
                            setState(() {
                              isSelected = false;
                            });
                          },
                          image: "assets/satellite_map.png",
                          isSelected: !isSelected),
                    ],
                  ),
                ));
          });
        });
  }

  Future<void> _getNode() async {
    GetAllNodeApi getAllNodeApi = GetAllNodeApi();
    List<NodeModel> list = [];
    List<int> listId = [];
    try {
      AllNodePhase allNodePhase = await getAllNodeApi.call();
      for (NodePhaseModel nodePhase in allNodePhase.listNodePhase ?? []) {
        if (!listId.contains(nodePhase.nodeID)) {
          GetNodeApi getNodeApi = GetNodeApi(
            nodeId: nodePhase.nodeID!,
          );
          NodeModel nodeModel = await getNodeApi.call();
          list.add(nodeModel);
          listId.add(nodePhase.nodeID!);
        }
      }
      listNode = list;
      _addNode();
    } catch (e) {
      listNode = [];
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (newContext) => PopScope(
              onPopInvoked: (value) {
                context.read<StopwatchBloc>().add(ResumeStopwatch());
              },
              child: AlertDialog(
                icon: const Icon(
                  Icons.location_off_rounded,
                  color: Colors.white,
                  size: 45,
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
                backgroundColor: ConstColors.surfaceColor,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Button(
                            width: 100,
                            height: 47,
                            color: ConstColors.errorContainerColor,
                            isCircle: false,
                            child: TextButton(
                              onPressed: () {
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
                            width: 100,
                            height: 47,
                            color: ConstColors.primaryColor,
                            isCircle: false,
                            child: TextButton(
                              onPressed: () {
                                context
                                    .read<StopwatchBloc>()
                                    .add(ResetStopwatch());
                                Navigator.pop(context);
                                MQTTManager().disconnectAllTopic();
                                locationService.stopService();
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

  void _showReport() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog.reportDialog();
        });
  }

  Widget _controlPanelMobile({required double width, required double height}) {
    return Positioned(
      bottom: 15,
      left: 15,
      child: BlocBuilder<StopwatchBloc, StopwatchState>(
        builder: (context, state) {
          return ClipPath(
            clipper: CustomContainer(),
            child: Container(
              width: width - 30,
              height: FetchPixel.getPixelHeight(105, false),
              color: ConstColors.tertiaryContainerColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 35, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocBuilder<VehiclesBloc, VehiclesState>(
                        builder: (context, vehicleState) {
                      return CustomDropdown(
                        transport: transport,
                        currentVehicle: vehicleState.vehicleType,
                        onSelected: (VehicleType? selectedVehicle) {
                          if (selectedVehicle != null) {
                            _changeVehicle(selectedVehicle);
                            switch (selectedVehicle) {
                              case VehicleType.pedestrians:
                                context
                                    .read<VehiclesBloc>()
                                    .add(PedestriansEvent());
                                break;
                              case VehicleType.cyclists:
                                context
                                    .read<VehiclesBloc>()
                                    .add(CyclistsEvent());
                                break;
                              case VehicleType.cityVehicle:
                              case VehicleType.truck:
                                context.read<VehiclesBloc>().add(TruckEvent());
                                break;
                              case VehicleType.car:
                                context.read<VehiclesBloc>().add(CarEvent());
                                break;
                            }
                          }
                        },
                      );
                    }),
                    _controlButton(
                        icon: Icons.turn_left_rounded,
                        onPressed: () {},
                        color: state is StopwatchRunInProgress
                            ? ConstColors.surfaceColor
                            : ConstColors.secondaryContainerColor),
                    _controlButton(
                        icon: Icons.straight_rounded,
                        onPressed: () {},
                        color: state is StopwatchRunInProgress
                            ? ConstColors.surfaceColor
                            : ConstColors.secondaryContainerColor),
                    _controlButton(
                        icon: Icons.report_problem_rounded,
                        onPressed: () {
                          _showReport();
                        },
                        color: ConstColors.tertiaryContainerColor),
                    GestureDetector(
                      onTap: () {
                        if (state is StopwatchRunInProgress) {
                          context.read<StopwatchBloc>().add(StopStopwatch());
                          _showDialog(context);
                        }
                      },
                      onLongPress: () {
                        if (state is! StopwatchRunInProgress) {
                          setState(() {
                            hidden = false;
                          });
                        }
                      },
                      onLongPressEnd: (details) async {
                        _startSendMessageMqtt();
                        setState(() {
                          hidden = true;
                        });
                      },
                      child: Button(
                        width: 60,
                        height: 60,
                        color: state is StopwatchRunInProgress
                            ? ConstColors.errorColor
                            : ConstColors.primaryColor,
                        isCircle: true,
                        child: Icon(
                          state is StopwatchRunInProgress
                              ? Icons.pause
                              : Icons.play_arrow_rounded,
                          color: state is StopwatchRunInProgress
                              ? Colors.white
                              : ConstColors.tertiaryContainerColor,
                          size: 45,
                        ),
                      ).getButton(),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _controlPanelTablet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: Dimens.size15Vertical),
        child: ClipPath(
          clipper: CustomContainerTablet(),
          child: Container(
            color: ConstColors.tertiaryContainerColor,
            height: 105,
            width: MediaQuery.of(context).size.shortestSide * 0.9,
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimens.size80Horizontal,
                  right: Dimens.size50Horizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<VehiclesBloc, VehiclesState>(
                          builder: (context, vehicleState) {
                        return CustomDropdown(
                          size: 70,
                          transport: transport,
                          currentVehicle: vehicleState.vehicleType,
                          onSelected: (VehicleType? selectedVehicle) {
                            if (selectedVehicle != null) {
                              _changeVehicle(selectedVehicle);
                              switch (selectedVehicle) {
                                case VehicleType.pedestrians:
                                  context
                                      .read<VehiclesBloc>()
                                      .add(PedestriansEvent());
                                  break;
                                case VehicleType.cyclists:
                                  context
                                      .read<VehiclesBloc>()
                                      .add(CyclistsEvent());
                                  break;
                                case VehicleType.cityVehicle:
                                case VehicleType.truck:
                                  context
                                      .read<VehiclesBloc>()
                                      .add(TruckEvent());
                                  break;
                                case VehicleType.car:
                                  context.read<VehiclesBloc>().add(CarEvent());
                                  break;
                              }
                            }
                          },
                        );
                      }),
                      SizedBox(width: 10,),
                      Text(
                        '0 ${L10nX.getStr.kmh}',
                        style: ConstFonts().copyWithInformation(fontSize: 24),
                      ),
                    ],
                  ),
                  BlocBuilder<StopwatchBloc, StopwatchState>(
                    builder: (context, state) {
                      return _stopwatchText(context, state);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mapTypeButton(
      {required String title,
      required Function() onPressed,
      required String image,
      required bool isSelected}) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
          width: 100,
          height: 150,
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ConstColors.surfaceColor,
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? ConstColors.primaryColor
                          : ConstColors.secondaryColor,
                      spreadRadius: 3,
                    ),
                  ],
                  color: ConstColors.surfaceColor,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      image,
                      height: 80,
                      width: 80,
                      color:
                          isSelected ? ConstColors.primaryColor : Colors.white,
                    )),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: ConstFonts().copyWithTitle(
                    fontSize: 15,
                    color:
                        isSelected ? ConstColors.primaryColor : Colors.white),
              ),
            ],
          )),
    );
  }

  Widget _controlButton(
      {required IconData icon,
      required Function() onPressed,
      required Color color}) {
    return Button(
        width: 45,
        height: 45,
        color: Colors.white,
        isCircle: true,
        child: IconButton(
          onPressed: onPressed,
          icon: Center(
              child: Icon(
            icon,
            color: color,
            size: 30,
          )),
        )).getButton();
  }

  Widget _stopwatchText(BuildContext context, StopwatchState state) {
    final duration = state.duration;
    final hoursStr =
        ((duration / 3600) % 60).floor().toString().padLeft(2, '0');
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$hoursStr:$minutesStr:$secondsStr',
      style: ResponsiveInfo.isTablet()
          ? ConstFonts().copyWithInformation(fontSize: 45)
          : ConstFonts().information,
    );
  }

  void _addMarkers(LatLng? position, VehicleType vehicleType) async {
    if (position == null) {
      Marker current = await MapHelper.getInstance()
          .getMarker(latLng: myLocation, image: transport[vehicleType]);
      // markers.add(current);
      myLocationMarker.add(current);
    }
    // NotificationModel notificationModel = NotificationModel(
    //   msg: "hello",
    //   dateTime: DateTime.now(),
    // );
    // await MQTTManager().sendMessageToATopic(
    //   newMqttServerClientObject: mqttServerClientObject!,
    //   message: jsonEncode(notificationModel.toJson()),
    //   onCallbackInfo: (p0) {
    //     print(p0);
    //   },
    // );
    setState(() {
      if (position != null) {
        if (!showInfoBox) {
          // markers.insert(
          //   1,
          //   Marker(
          //     markerId: MarkerId(position.toString()),
          //     position: position,
          //   ),
          // );
        // } else {
          // markers.removeAt(1);
          // markers.insert(
          //   1,
          //   Marker(
          //     markerId: MarkerId(position.toString()),
          //     position: position,
          //   ),
          // );
          selectedMarker.add(Marker(
            markerId: MarkerId(position.toString()),
            position: position,
          ),);
        }

        showInfoBox = true;
        destination = position;
      }
    });
  }

  void _addNode() async {
    // NotificationModel notificationModel = NotificationModel(
    //   msg: "hello",
    //   dateTime: DateTime.now(),
    // );
    // await MQTTManager().sendMessageToATopic(
    //   newMqttServerClientObject: mqttServerClientObject!,
    //   message: jsonEncode(notificationModel.toJson()),
    //   onCallbackInfo: (p0) {
    //     print(p0);
    //   },
    // );
    for (var node in listNode) {
      Marker current = await MapHelper.getInstance().getMarker(
          latLng: LatLng(node.deviceLat!, node.deviceLng!),
          image: "assets/road.png",
          size: 120);
      // markers.add(current);
      nodeMarker.add(current);
    }
    setState(() {});
  }

  void _updateMyLocationMarker() async {
    final vehicleState = context.read<VehiclesBloc>().state;
    Marker current = await MapHelper.getInstance().getMarker(
        latLng: MapHelper.currentLocation,
        image: transport[vehicleState.vehicleType]);
    // markers.removeAt(0);
    // markers.insert(0, current);
    myLocationMarker.removeAt(0);
    myLocationMarker.add(current);
    setState(() {});
  }

  void _changeVehicle(VehicleType vehicleType) async {
    Marker current = await MapHelper.getInstance()
        .getMarker(latLng: MapHelper.currentLocation, image: transport[vehicleType]);
    // markers.removeAt(0);
    // markers.insert(0, current);
    myLocationMarker.removeAt(0);
    myLocationMarker.add(current);
    setState(() {});
  }

  void _removeMarkers() {
    selectedMarker.clear();
    setState(() {
      // markers.removeAt(1);
    });
  }

  Widget infoBox(LatLng destination) {
    UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();
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
                                  Text("${userInfo?.username}"),
                                  Text(
                                    '${userInfo?.typeVehicle ?? "type vehicle"}${distance > 0 ? (distance < 1000 ? ' - $distance m' : ' - ${(distance / 1000).toStringAsFixed(1)} km') : ''}',
                                    maxLines: 2,
                                  ),
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
                                              child: const Icon(
                                                  Icons.keyboard_return,
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
                                          distance = MapHelper.getInstance()
                                              .calculateDistance(
                                                  myLocation, destination);
                                        });
                                      },
                                      child: Button(
                                              width: 40,
                                              height: 40,
                                              color: ConstColors.onPrimaryColor,
                                              isCircle: false,
                                              child: const Icon(
                                                  Icons.directions,
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

  void _openNotification() {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.50,
        maxHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      context: context,
      builder: (context) => NotificationScreen(),
    );
  }

  void _openNodeLocation() {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.50,
        maxHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, builder) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Node location'),
            centerTitle: true,
            actions: [
              InkWell(
                child: const Icon(
                  Icons.arrow_back,
                  color: ConstColors.onPrimaryColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: listNode.length - 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _controller.animateCamera(CameraUpdate.newLatLng(LatLng(
                            listNode[index + 1].deviceLat!,
                            listNode[index + 1].deviceLng!)));
                        setState(() {
                          focusOnMyLocation = false;
                        });
                      },
                      child: Row(
                        children: [
                          Text(listNode[index + 1].name.toString()),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        );
      }),
    );
  }

  Future<String> _getTimeZoneTime() async {
    // final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var detroit = tz1.getLocation(currentTimeZone!);
    String now = tz1.TZDateTime.now(detroit).toString();
    now = now.replaceAll("+", " +");
    now = now.replaceRange(now.length - 2, now.length - 2, ":");
    return now; //"${timeStr} ${timeZone}";
  }
}
