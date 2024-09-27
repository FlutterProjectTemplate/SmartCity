import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
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
import 'package:smart_city/controller/stopwatch_bloc/stopwatch_bloc.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
import 'package:smart_city/view/mqtt/mqtt.dart';
import '../../controller/mqtt/mqtt_service.dart';
import '../../l10n/l10n_extention.dart';
import 'map_bloc/map_bloc.dart';
import 'dart:async';

class MapUi extends StatefulWidget {
  const MapUi({super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}

class _MapUiState extends State<MapUi> with SingleTickerProviderStateMixin {
  late GoogleMapController _controller;
  late String _mapStyleString = ''; // map style
  bool hidden = true; // show or hide the countdown timer
  LatLng? initialPosition = MapHelper.currentLocation;

  // LatLng initialPosition = const LatLng(37.608360, -122.402878);
  StreamSubscription<Position>? _positionStreamSubscription;
  late AnimationController controller;
  late Animation<double> animation;
  late List<Marker> markers;

  @override
  void initState() {
    //_initLocationService();
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    MapHelper.getInstance().dispose();
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                builder: (context, state) {
                  return GoogleMap(
                    markers: Set.from(markers),
                    onTap: _addMarkers,
                    // style: _mapStyleString,
                    mapType: state.mapType,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: initialPosition ?? const LatLng(0, 0),
                      zoom: 16,
                    ),
                    zoomControlsEnabled: true,
                    myLocationButtonEnabled: true,
                    trafficEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      context.read<MapBloc>().add(NormalMapEvent());
                    },
                  );
                },
              ),

              //control buttons
              Positioned(
                  top: Dimens.size50Vertical,
                  right: Dimens.size20Horizontal,
                  child: SizedBox(
                    height: 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _controlButton(
                            icon: Icons.notifications,
                            onPressed: () {
                              context.go('/map/notification');
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
                          return _controlButton(
                              icon: Icons.layers,
                              onPressed: () {
                                _showModalBottomSheet(context, state);
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
                                                  child: Text(L10nX.getStr.code_3_activate,
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
                                              child: Text(L10nX.getStr.code_3_deactivate,
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
      _controller
          .animateCamera(CameraUpdate.newLatLng(MapHelper.currentLocation));
    });

    if (await MapHelper.getInstance().getPermission()) {
      _positionStreamSubscription =
          Geolocator.getPositionStream().listen((Position position) {
        _controller.animateCamera(CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude)));
      });
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
                  Button(
                      width: 105,
                      height: 47,
                      color: ConstColors.errorContainerColor,
                      isCircle: false,
                      child: TextButton(
                        onPressed: () {
                          context.read<StopwatchBloc>().add(ResumeStopwatch());
                          Navigator.pop(context);
                        },
                        child: Text(L10nX.getStr.no,
                            style: ConstFonts().copyWithTitle(fontSize: 16)),
                      )).getButton(),
                  const SizedBox(
                    width: 20,
                  ),
                  Button(
                      width: 105,
                      height: 47,
                      color: ConstColors.primaryColor,
                      isCircle: false,
                      child: TextButton(
                        onPressed: () {
                          context.read<StopwatchBloc>().add(ResetStopwatch());
                          Navigator.pop(context);
                        },
                        child: Text(L10nX.getStr.yes,
                            style: ConstFonts().copyWithTitle(fontSize: 16)),
                      )).getButton(),
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
          MqttService mqtt = MqttService();
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocBuilder<VehiclesBloc, VehiclesState>(
                        builder: (context, state) {
                      return Image.asset(
                        state.vehicleType == VehicleType.pedestrians
                            ? "assets/pedestrians.png"
                            : "assets/cycling.png",
                        height: 40,
                        width: 40,
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
                          mqtt.disconnect();
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
                        setState(() {
                          hidden = true;
                        });
                        try {
                          await mqtt.connect();
                        } catch (e) {
                          print(e.toString());
                        }
                        ;
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
            width: MediaQuery.of(context).size.shortestSide * 0.8,
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimens.size80Horizontal,
                  right: Dimens.size50Horizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/fire-truck.png',
                        height: 70,
                        width: 70,
                      ),
                      Text(
                        '0 ${L10nX.getStr.kmh}',
                        style: ConstFonts().copyWithInformation(fontSize: 24),
                      )
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
                    color: ConstColors.surfaceColor, // Black border
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? ConstColors.primaryColor
                          : ConstColors.secondaryColor, // Outer yellow border
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

  void _addMarkers(LatLng position) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(markerId: MarkerId(position.toString()), position: position),
      );
    });
  }
}
