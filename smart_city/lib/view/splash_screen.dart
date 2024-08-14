import 'package:flutter/material.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/constant_value/const_size.dart';
import 'package:smart_city/view/login/login_ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   SharedPreferenceData.getHaveFirstUsingApp().then((value){
  //     SharedPreferenceData.setHaveFirstUsingApp();
  //     Future.delayed(const Duration(milliseconds: 1),() async {
  //     if(!value) /// have used app at least once after installation
  //     {
  //       SharedPreferenceData.isLogIn().then((isLogIn) async {
  //         if(isLogIn) /// if token is still valid, go to home screen
  //         {
  //           //await MapHelper().getMyLocationData();
  //           //AppPages.route(Routes.homeScreenRoute, preventDuplicates: false, isReplace: true);
  //         }
  //         else
  //         {
  //           /// return to login screen
  //           // MapHelper().getMyLocationData();
  //           // AppPages.route(Routes.loginRoute, isReplace: true);
  //         }
  //       });
  //     }
  //     else
  //     {/// return to initial guide screen
  //       // MapHelper().getMyLocationData();
  //       // AppPages.route(Routes.introRoute);
  //     }
  //   },);
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    final height = ConstSize.getHeight(context);
    final width = ConstSize.getWidth(context);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/background_mobile.png',height:height,width: width,fit: BoxFit.fill,),
          Positioned(
            top: height*0.6,
            left: 20,
            child:RichText(
              text: TextSpan(
                text: 'Beat the',
                style: ConstFonts().heading,
                children:  <TextSpan>[
                  TextSpan(text: ' red \n', style:ConstFonts().copyWithHeading(color: Colors.red)),
                  TextSpan(text: 'Navigate smarter\nwith Citiez', style:ConstFonts().copyWithHeading(fontSize: 35)),
                ],
              )
            )
          ),
          Positioned(
              top: height*0.77,
              left: 20,
              child: RichText(
                text: TextSpan(
                  text: 'Let’s turn your commute\ninto a ',
                  style: ConstFonts().subHeading,
                  children: <TextSpan>[
                    TextSpan(text: 'green ',style: ConstFonts().copyWithSubHeading(color: ConstColors.primaryColor)),
                    TextSpan(text:'light party',style: ConstFonts().copyWithSubHeading()),
                  ],
                ),
              )
          ),
          Positioned(
            top: height*0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Button(
                  width: width-20,
                  height: height*0.07,
                  color: ConstColors.primaryColor,
                  text: TextButton(
                    onPressed: (){
                      Navigator.push(context,(MaterialPageRoute(builder: (context)=>const Login())));
                    },
                    child: Text('Get Started',style: ConstFonts().title),
                  ),
                ).getButton(),
              ),
          )
        ],
      ),
    );
  }
}
