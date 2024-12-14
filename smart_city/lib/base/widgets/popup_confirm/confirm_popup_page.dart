
import 'package:flutter/material.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/widgets/button/action_button1.dart';
import 'package:smart_city/base/widgets/dialog_common/common_dialog1.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/constant_value/const_size.dart';
import 'package:smart_city/l10n/l10n_extention.dart';

class ConfirmPopupPage extends StatefulWidget{
  void show(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => this);
  }
  void Function()? onAccept, onCancel;

  String? title;
  String? content;
  TextAlign? textAlign;
  TextStyle? contentStyle;
  bool? enableCancelButton;
  double? width;
  double? height;
  ConfirmPopupPage(
      {
        super.key,
        this.onAccept,
        this.onCancel,
        this.content,
        this.title,
        this.textAlign,
        this.contentStyle,
        this.enableCancelButton,

      });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ConfirmPopupPageState();
  }

}
class ConfirmPopupPageState extends State<ConfirmPopupPage> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool  isTablet = ResponsiveInfo.isTablet();
    return buildUiAll(context, isTablet: isTablet);
  }
  late AnimationController controller ;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  Widget buildUiAll(BuildContext context, {bool ? isTablet}){
    isTablet??=false;
    
    return ScaleTransition(
      scale: scaleAnimation,
      child: CustomDialog1(
          title: widget.title,
          titleAlignment: MainAxisAlignment.center,
          insetPadding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width*(!isTablet?0.95: 0.7),
          enableBackButton: false,
          enableCloseButton: true,
          mainAxisSizeParent: MainAxisSize.min,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                          widget.content??"",
                          textAlign: widget.textAlign??TextAlign.center,
                          style: widget.contentStyle??TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87
                          )
                      ),
                    ],
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.enableCancelButton??true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [
                          ActionButton1(
                              width: 120,
                              enableBgColor: Colors.white70,
                              textStype: ConstFonts().copyWithTitle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              onTap: () async {
                                Navigator.of(context).pop();
                                if(widget.onCancel!=null)
                                {
                                  widget.onCancel!();
                                }
                              },
                              text: L10nX.getStr.str_cancel,
                              height: Dimens.size40Vertical),
                          SizedBox(width:  Dimens.size20Horizontal),

                        ],
                      ),
                    ),
                    ActionButton1(
                        width: 120,
                        onTap: () async {
                          Navigator.of(context).pop();
                          if(widget.onAccept!=null)
                            {
                              widget.onAccept!();
                            }
                        },
                        text: L10nX.getStr.str_accept,
                        height: Dimens.size40Vertical),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }

  

  }