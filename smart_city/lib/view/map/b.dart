import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../base/app_settings/app_setting.dart';
import '../../constant_value/const_colors.dart';
import '../../constant_value/const_fonts.dart';
import '../../controller/helper/map_helper.dart';
import '../../l10n/l10n_extention.dart';

class AppBarWidget extends StatefulWidget {
  final bool? onStart;
  final bool? onService;
  final Function(double) onHeightChange;
  const AppBarWidget({super.key, this.onStart, this.onService,required this.onHeightChange});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  late double appBarHeight ;

  @override
  void initState() {
    super.initState();
    appBarHeight = 100;
  }

  @override
  void didUpdateWidget(AppBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onService != widget.onService || oldWidget.onStart != widget.onStart) {
      if (widget.onStart??false) {
        appBarHeight = 150;
      }
      if (widget.onService??false) {
        appBarHeight = 250;
      }
      if (!(widget.onStart??false) && !(widget.onService??false)) {
        appBarHeight = 100;
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 100,
      ),
        height: appBarHeight,
        width: width,
        decoration: BoxDecoration(
          color: ConstColors.tertiaryContainerColor,
          borderRadius: appBarHeight > 120 ? BorderRadius.circular(20) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            (appBarHeight <= 120) ? Text('Map', style: ConstFonts().copyWithHeading(fontSize: 30),)
                : (appBarHeight > 120) ?
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 50,right: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text("Current location: ${currentLocation != null ? MapHelper().getAddressByLocation(currentLocation) : 'Not found'}", style: ConstFonts().title,),
                        Text("State: Servicing", style: ConstFonts().title,),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                '${(MapHelper().getSpeed()).toStringAsFixed(0) ?? 0}',
                                style: ConstFonts()
                                    .copyWithInformation(fontSize: 20),
                              ),
                              TextSpan(
                                text: (AppSetting.getSpeedUnit == 'km/h')
                                    ? L10nX.getStr.kmh
                                    : (AppSetting.getSpeedUnit == 'mph')
                                    ? L10nX.getStr.mph
                                    : L10nX.getStr.ms,
                                style: ConstFonts()
                                    .copyWithInformation(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                              3,
                                  (index) => InkWell(
                                onTap: (){
                                  print(index);
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ConstColors.primaryContainerColor
                                  ),
                                  child: Center(child: Text('$index', style: ConstFonts().title,)),
                                ),
                              )
                          ),
                        )
                      ]
                  ),
                ),
              ),
            ) :
             (widget.onStart??false) ? Text('On Start', style: ConstFonts().copyWithHeading(fontSize: 30),)
                : Text('On Service', style: ConstFonts().copyWithHeading(fontSize: 30),),
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
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                color: ConstColors.tertiaryContainerColor,
                child: Container(
                  height: 7,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}
