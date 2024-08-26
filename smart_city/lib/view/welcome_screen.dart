import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    SharedPreferenceData.setHaveFirstUsingApp();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ScreenTypeLayout.builder(
      mobile:(_)=>Scaffold(
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
                child: GestureDetector(
                  onTap: ()=>context.push('/login'),
                  child: Button(
                    width: width-20,
                    height: height*0.07,
                    color: ConstColors.primaryColor,
                    isCircle: false,
                    child: Text('Get Started',style: ConstFonts().title),
                  ).getButton(),
                ),
              ),
            )
          ],
        ),
      ),
      tablet: (_)=>Container(color: Colors.blue,),
    );
  }
}
