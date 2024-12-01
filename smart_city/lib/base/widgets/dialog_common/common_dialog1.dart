
import 'package:flutter/material.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/widgets/common/stateless_widget_common.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_size.dart';

class CustomDialog1 extends StatelessWidgetCommon{
  /// This [CustomDialog1] show app dialog common
  CustomDialog1(
      {
        super.key,
        required this.child,
        this.height,
        this.width,
        this.radius,
        this.insetPadding,
        this.enableCloseButton,
        this.enableBackButton,
        this.title,
        this.canBackdrop = true,
        this.enableHeader= true,
        this.alignment,
        this.mainAxisSizeParent,
        this.titleIcon,
        this.bodyBackGroundColor,
        this.backButtonCallback,
        this.titleAlignment,
        this.titleStyle,
        this.enableHeaderDivider,
        this.headerColor,
        this.headerButtonColor
      }){
    title??="";
    bodyBackGroundColor??=Colors.white;
    enableCloseButton??=true;
    enableBackButton??=false;
    radius??=Dimens.size25Vertical;
    enableHeader??=true;
    alignment??=Alignment.center;
    mainAxisSizeParent ??=MainAxisSize.max;
    enableHeaderDivider??=false;
  }

  ///constant width dynamic
  static const double dynamicSize = -1;

  /// content dialog;
  final Widget child;
  final Widget? titleIcon;
  TextStyle? titleStyle;
  bool? enableCloseButton;
  bool? enableBackButton;
  String? title;
  bool ? enableHeader;
  Color? bodyBackGroundColor;
  Color? headerColor;
  Color? headerButtonColor;
  AlignmentGeometry? alignment;
  MainAxisAlignment? titleAlignment;
  /// radius dialog;
  double? radius;
  final EdgeInsets? insetPadding;
  /// The [height] height of dialog
  final double? height;

  Function()?backButtonCallback;
  ///The [width] width of dialog
  ///
  /// If [width] is null width default is device screen width DeviceUtils.isTablet() ? size.width * 0.4 : size.width * 0.95
  final double? width;
  MainAxisSize? mainAxisSizeParent;
  final bool canBackdrop;
  bool? enableHeaderDivider;

  ///The [show] function show custom dialog
  void show(BuildContext context) {
    showDialog(
        barrierDismissible: canBackdrop,
        context: context,
        builder: (context) => this);
  }

  @override
  Widget rootWidget(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool isTablet = ResponsiveInfo.isTablet();
    double? widthSize = width ?? (ResponsiveInfo.isTablet() ? size.width * 0.7 : size.width * 0.95);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          /// boc de thuc hien ontap outside
          height:MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius!,),
          ),
          constraints: BoxConstraints(
            maxHeight:  MediaQuery.sizeOf(context).height,
            maxWidth: MediaQuery.sizeOf(context).width,
          ),
          child: Dialog(
            insetPadding: insetPadding ??  EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius!)),
            alignment: alignment!,
            child: Container(
                  width: widthSize,
                  height: height,
                  decoration: BoxDecoration(
                    color: bodyBackGroundColor,
                    borderRadius: BorderRadius.circular(radius!,),
                  ),
                  padding: EdgeInsets.only(bottom: radius??0),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Column(
                    mainAxisSize: mainAxisSizeParent!,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: enableHeader!,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: isTablet?Dimens.size60Vertical:Dimens.size60Vertical,
                              decoration: BoxDecoration(
                                color: headerColor??ConstColors.tertiaryContainerColor,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(radius!)),
                              ),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: Dimens.size15Horizontal, vertical: Dimens.size15Vertical),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: enableBackButton??false,
                                      child: InkWell(
                                          onTap: (){
                                            if(enableBackButton!)
                                              {
                                                if(backButtonCallback!=null)
                                                  {
                                                    backButtonCallback!();
                                                  }
                                                else
                                                  {
                                                    Navigator.of(context).pop();
                                                  }
                                              }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Icon(
                                              Icons.arrow_back_ios_rounded,
                                              size: Dimens.size20Vertical,
                                              color: headerButtonColor??Colors.white,
                                            ),
                                          )),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: titleAlignment??MainAxisAlignment.start,
                                        children: [
                                          titleIcon??const SizedBox.shrink(),
                                          SizedBox(width:5),
                                          Text(
                                              title!,
                                              style: titleStyle??TextStyle(fontSize: 20, color: Colors.white))
                                            ],
                                      ),
                                    ),
                                    enableCloseButton!=null?
                                    InkWell(
                                        onTap: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Icon(
                                            Icons.close,
                                            size: Dimens.size20Vertical,
                                            color: headerButtonColor??Colors.white,
                                          ),
                                        )):
                                    SizedBox(width: Dimens.size20Horizontal,),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: enableHeaderDivider??false,
                              child: Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: mainAxisSizeParent==MainAxisSize.min,
                        child: Container(
                          decoration: BoxDecoration(
                              color: bodyBackGroundColor,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius!)),
                              //border: const Border(bottom: BorderSide(color: Colors.white), right: BorderSide(color: Colors.white), left: BorderSide(color: Colors.white))
                          ),
                          child: Column(
                            children: [
                              child,
                            ],
                          )),
                      ),
                      Visibility(
                        visible: mainAxisSizeParent==MainAxisSize.max,
                        child: Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: bodyBackGroundColor,
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius!)),
                                  //border: const Border(bottom: BorderSide(color: Colors.white), right: BorderSide(color: Colors.white), left: BorderSide(color: Colors.white))
                              ),
                              child: Column(
                                children: [
                                  child,
                                ],
                              )),
                        ),
                      ),
                    ],
                  )
                ),
          ),
        ),
      ),
    );
  }
}
