import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../base/app_settings/app_setting.dart';
import '../../constant_value/const_colors.dart';
import '../../constant_value/const_fonts.dart';
import '../../controller/helper/map_helper.dart';
import '../../l10n/l10n_extention.dart';
import '../../model/tracking_event/tracking_event.dart';

class AppBarWidget2 extends StatefulWidget {
  const AppBarWidget2({
    super.key,
  });

  @override
  State<AppBarWidget2> createState() => _AppBarWidget2State();
}

class _AppBarWidget2State extends State<AppBarWidget2> {
  late double appBarHeight;

  @override
  void initState() {
    super.initState();
    appBarHeight = 250;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MapHelper().logEventNormal != null ? Container(
      decoration: BoxDecoration(
          color: ConstColors.tertiaryContainerColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 5), // Shadow position
            ),
          ]),
      margin: EdgeInsets.only(left: 20, top: 40, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${MapHelper().logEventNormal?.nodeName}",
                        style: ConstFonts()
                            .title
                            .copyWith(fontSize: 22, color: Colors.white),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: MapHelper().logEventNormal?.options?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              print(index);
                            },
                            child: SizedBox(
                                height: height * 0.05,
                                child: Row(
                                  children: [
                                    Container(
                                      height: height * 0.04,
                                      width: height * 0.04,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green),
                                      child: FittedBox(
                                        child: Text('${index + 1}', style: TextStyle(),),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        '${MapHelper().logEventNormal?.options?[index].channelName}', style: TextStyle(
                                      color: Colors.white
                                    ),)
                                  ],
                                )),
                          );
                        },
                      ),
            ]),
          )
        ],
      ),
    ) : SizedBox();
  }
}
