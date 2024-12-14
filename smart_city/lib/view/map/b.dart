
import 'package:flutter/material.dart';

import '../../base/app_settings/app_setting.dart';
import '../../constant_value/const_colors.dart';
import '../../constant_value/const_fonts.dart';
import '../../controller/helper/map_helper.dart';
import '../../l10n/l10n_extention.dart';
import '../../model/tracking_event/tracking_event.dart';

class AppBarWidget extends StatefulWidget {
  final bool? onStart;
  final bool? onService;
  final Function(double) onHeightChange;

  const AppBarWidget(
      {super.key, this.onStart, this.onService, required this.onHeightChange});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  late double appBarHeight;

  @override
  void initState() {
    super.initState();
    appBarHeight = 100;
  }

  @override
  void didUpdateWidget(AppBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onService != widget.onService ||
        oldWidget.onStart != widget.onStart) {
      if (widget.onStart ?? false) {
        appBarHeight = 150;
      }
      if (widget.onService ?? false) {
        appBarHeight = 250;
      }
      if (!(widget.onStart ?? false) && !(widget.onService ?? false)) {
        appBarHeight = 100;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TrackingEventInfo trackingEventInfo = TrackingEventInfo(
        options: [
          Options(
              index: 0, channelName: "Option1", isDummy: false, channelId: 1)
        ],
        state: 1,
        currentCircle: 5,
        vectorId: 91,
        vectorEvent: 2,
        nodeName: "Văn phòng FFT Solution, 178 Thái hà",
        nodeId: 765,
        userId: 124,
        virtualDetectorState: VirtualDetectorState.Processing,
        geofenceEventType: GeofenceEventType.StillInside);
    final Map<String, dynamic> jsonData = trackingEventInfo.toJson();
    MapHelper().logEventNormal = TrackingEventInfo.fromJson(jsonData);
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AnimatedContainer(
            duration: Duration(
              milliseconds: 100,
            ),
            height: appBarHeight,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ConstColors.tertiaryContainerColor,
                  ConstColors.primaryColor,
                  // Colors.transparent
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // stops: [0.5,0.8,1]
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 5), // Shadow position
                ),
              ],
              borderRadius: appBarHeight > 120 ? BorderRadius.circular(20) : null,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (appBarHeight <= 120)
                    ? Hero(
                  tag: 'lo-go',
                  child: Text(
                    'Smart City Signals',
                    style: TextStyle(
                      fontSize: 22,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),

                )
                    : (appBarHeight > 120)
                    ? Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 50, right: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("Current location: ${currentLocation != null ? MapHelper().getAddressByLocation(currentLocation) : 'Not found'}", style: ConstFonts().title,),
                            Text(
                              "${MapHelper().logEventNormal?.nodeName}",
                              style: ConstFonts().title.copyWith(
                                  fontSize: 22
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                    'Speed: ${(MapHelper().getSpeed()).toStringAsFixed(0) ?? 0}',
                                    style: ConstFonts()
                                        .copyWithInformation(
                                        fontSize: 20),
                                  ),
                                  TextSpan(
                                    text:
                                    (AppSetting.getSpeedUnit == 'km/h') ? L10nX.getStr.kmh : (AppSetting.getSpeedUnit == 'mph') ? L10nX.getStr.mph : L10nX.getStr.ms,
                                    style: ConstFonts()
                                        .copyWithInformation(
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    print(index);
                                  },
                                  child: Container(
                                    color: Colors.green,
                                    child: ListTile(
                                      leading: Icon(Icons.add),
                                      title: Text('$index'),
                                      trailing: Icon(Icons.add),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ]),
                    ),
                  ),
                )
                    : (widget.onStart ?? false)
                    ? Text(
                  'On Start',
                  style: ConstFonts().copyWithHeading(fontSize: 30),
                )
                    : Text(
                  'On Service',
                  style: ConstFonts().copyWithHeading(fontSize: 30),
                ),
                // if (widget.onStart??false || (widget.onService??false))
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    widget.onHeightChange(appBarHeight);
                    setState(() {
                      appBarHeight += details.primaryDelta ?? 0;
                      appBarHeight = appBarHeight.clamp(100.0, 250.0);
                    });
                  },
                  onVerticalDragEnd: (_) {
                    if (appBarHeight <= 220) {
                      setState(() {
                        appBarHeight = 100;
                      });
                    } else {
                      setState(() {
                        appBarHeight = 250;
                      });
                    }
                  },
                  child: Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey, Colors.black12],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                )
              ],
            ));
      },
    );
  }
}
