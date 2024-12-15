import 'package:flutter/material.dart';
import 'package:smart_city/base/widgets/custom_container.dart';
import 'package:smart_city/constant_value/const_fonts.dart';

class IntroView extends StatelessWidget {
  final String image;
   String? title;
   BoxFit? boxFit;
  String? subTitle;
  Widget? bottomChild;
  Widget? topChild;
  int? topWidgetFlex;
  int? bottomWidgetFlex;
  IntroView({
     super.key,
      this.title,
     required this.image,
     this.subTitle,
     this.boxFit,
     this.bottomChild,
    this.topChild,
    this.bottomWidgetFlex,
    this.topWidgetFlex
   });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: topWidgetFlex??12,
          child: topChild??ClipPath(
            clipper: CustomContainerIntro1(),
            child: Container(
              height: height * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image,),
                  fit: boxFit??BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: bottomWidgetFlex??5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: bottomChild ?? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    title??"",
                    style: ConstFonts().copyWithHeading(
                      fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 20
                    )
                ),
                Text(
                    subTitle??"",
                    textAlign: TextAlign.center,
                    style: ConstFonts().copyWithHeading(
                      fontWeight: FontWeight.w400,
                        color: Colors.black45,
                        fontSize: 16
                    )
                ),
              ],
            )
            ,
          ),
        ),
      ],
    );
  }
}
