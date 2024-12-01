
import 'package:flutter/material.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/constant_value/const_size.dart';

class ActionButton1 extends StatelessWidget {
  Color? enableBgColor;
  Color? borderColor;
  double? borderWidth;
  TextStyle? textStype;
  String? text;
  double? radius;
  Function()? onTap;
  double? width;
  double? height;
  bool? enable;
  bool? enableLinearColor;
  EdgeInsetsGeometry? contentPadding;
  double? elevation;
  Color? splashColor;
  Widget?icon;
  ActionButton1(
      {super.key,
      this.enableBgColor,
      this.text,
      this.textStype,
      this.radius,
      this.onTap,
      this.width,
      this.height, 
      this.borderColor,
        this.borderWidth,
        this.enableLinearColor,
        this.contentPadding,
        this.elevation,
        this.splashColor,
        this.icon,
      this.enable}) {
    enableBgColor ??= ConstColors.primaryColor;
    textStype ??= ConstFonts().copyWithTitle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,);
    radius ??= Dimens.size30Vertical;
    height ??= Dimens.size40Vertical;
    enable ??= true;
    enableLinearColor??=false;
    text??="";
    elevation??=1;
  }
  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      borderRadius:BorderRadius.all(Radius.circular(radius??5)),
      child: InkWell(
        onTap: () {
          if (onTap != null && enable!) {
            onTap!();
          }
        },
       // focusColor: Colors.transparent,
       // hoverColor: Colors.transparent,
        splashColor: splashColor,
        highlightColor: splashColor,
        child: Card(
          elevation: elevation,
          color: enable! ? enableBgColor : enableBgColor!.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius??5)),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(radius??5)),
                shape: BoxShape.rectangle,
                border: Border.all(color: borderColor??enableBgColor!, width: borderWidth??0),
                color: enable! ? enableBgColor : enableBgColor!.withOpacity(0.3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: contentPadding??EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Center(
                      child: Row(
                        children: [
                          Visibility(
                            visible: icon!=null,
                            child: Row(
                              children: [
                                icon??SizedBox.shrink(),
                                SizedBox(width: 8)
                              ],
                            ),
                          ),
                          Text(
                            text!,
                            style: enable! ?textStype:textStype,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
