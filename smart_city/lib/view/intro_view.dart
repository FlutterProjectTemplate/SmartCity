import 'package:flutter/material.dart';
import 'package:smart_city/base/widgets/custom_container.dart';
import 'package:smart_city/constant_value/const_fonts.dart';

class IntroView extends StatelessWidget {
  final String image;
  final String title;
  final BoxFit? boxFit;
  final String subTitle;
  const IntroView({super.key, required this.title, required this.image, required this.subTitle, this.boxFit});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 12,
          child: ClipPath(
            clipper: CustomContainerIntro1(),
            child: Container(
              height: height * 0.2,
              // width: height * 0.35,
              decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   border: Border.all(color: Colors.grey, width: 2),
                image: DecorationImage(
                  image: AssetImage(image,),
                  fit: boxFit??BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    title,
                    style: ConstFonts().copyWithHeading(
                      fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 20
                    )
                ),
                Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: ConstFonts().copyWithHeading(
                      fontWeight: FontWeight.w400,
                        color: Colors.black45,
                        fontSize: 16
                    )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
