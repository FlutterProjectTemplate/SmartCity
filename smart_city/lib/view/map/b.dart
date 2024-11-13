import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../base/app_settings/app_setting.dart';
import '../../constant_value/const_colors.dart';
import '../../constant_value/const_fonts.dart';
import '../../controller/helper/map_helper.dart';
import '../../l10n/l10n_extention.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  late double appBarHeight ;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    appBarHeight = 100;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        height: appBarHeight,
        width: width,
        color: ConstColors.tertiaryContainerColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            (appBarHeight <= 120) ? Text('Map', style: ConstFonts().copyWithHeading(
                fontSize: 30
            ),) :
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 50,right: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("178 Thai Ha", style: ConstFonts().title,),
                        Text("Vecter id", style: ConstFonts().title,),
                        Text("Circle", style: ConstFonts().title,),
                        Text("State", style: ConstFonts().title,),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                '${(MapHelper().speed)?.toStringAsFixed(0) ?? 0}',
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
            ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
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
