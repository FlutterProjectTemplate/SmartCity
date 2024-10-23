import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/constant_value/const_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () async {
      SharedPreferenceData.isLogIn().then((isLogIn) async {
        if (isLogIn) {
          context.go('/map');
        } else {
          context.go('/login');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: LoadingAnimationWidget.inkDrop(
              color: ConstColors.primaryColor,
              size: MediaQuery.of(context).size.width / 4)),
    );
  }
}
