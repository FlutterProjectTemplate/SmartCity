import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/controller/helper/map_helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1800), () async{
      SharedPreferenceData.isLogIn().then((isLogIn)async{
        if(isLogIn) {
          await MapHelper.getInstance().getCurrentLocation();
          GoRouter.of(context).go('/map');
        } else {
          await MapHelper.getInstance().getCurrentLocation();
          GoRouter.of(context).go('/login');
        }
      });
    });
    return  Scaffold(
      body: Center(
          child: LoadingAnimationWidget.inkDrop(
              color: ConstColors.primaryColor,
              size: MediaQuery.of(context).size.width/4
          )),
    );
  }
}