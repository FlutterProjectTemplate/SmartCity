import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/view/login/login_ui.dart';

import '../base/common/responsive_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    precacheImage(AssetImage('assets/images/background16.jpg'), context);
    Future.delayed(const Duration(milliseconds: 1800), () async {
      SharedPreferenceData.isLogIn().then((isLogIn) async {
        if (isLogIn) {
          context.go('/map');
        } else {
          context.go('/login');
        }
      });
    });
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: Hero(
          tag: 'lo-go',
          child: Image.asset(
            'assets/logo1.png',
            height: height * 0.25,
            width: width * 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
