import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/view/login/login_ui.dart';

import '../base/store/shared_preference_data.dart';
import 'intro_view.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int totalPage = 3;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferenceData.setHaveFirstUsingApp();
    if (ResponsiveInfo.isTablet()) context.go('login');
    _pageController.addListener(() {
      int page = (_pageController.page ?? 0).round();
      if (currentPage != page) {
        setState(() {
          currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children:[
          Visibility(
            visible: currentPage== totalPage-1,
              child:Column(
                children: [
                  Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Image.asset(
                            'assets/images/background17.png',
                              height: height,
                              width: width,
                            fit: BoxFit.cover);
                        },
                      )),
                ],
              ),),
          Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  IntroView(
                    image: 'assets/images/onboading1.jpg',
                    title: 'Bicyclists',
                    subTitle: 'Share your GPS position to send “Detection Requests” to traffic signals to get a green light faster or to extend a green.',
                  ),
                  IntroView(
                    image: 'assets/images/onboading3.png',
                    title: 'Pedestrians',
                    subTitle: 'Use audio or screen tap to push crosswalk button as you approach a traffic signals',
                  ),


                  buildListOfCity(),

                ],
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        totalPage,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? ConstColors.primaryColor
                                : Colors.grey[300],
                            // borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(children: [
                      SizedBox(
                        height: height * 0.05,
                        width: width * 0.8,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ConstColors.primaryColor,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              (currentPage < totalPage - 1) ? 'Next' : 'Get Started',
                              style: ConstFonts()
                                  .copyWithTitle(color: ConstColors.onPrimaryColor),
                            ),
                            onPressed: () {
                              (currentPage < totalPage - 1)
                                  ? _pageController.animateToPage(currentPage + 1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOutCubic)
                                  : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginUi()),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: currentPage< totalPage-1,
                        child: Card(
                          elevation: 5,
                          child: SizedBox(
                            height: height * 0.05,
                            width: width * 0.8,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ConstColors.onPrimaryColor,
                                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Skip',
                                style: ConstFonts()
                                    .copyWithTitle(color: ConstColors.primaryColor),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginUi()),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),

          ],
        ),
        ]
      ),
    );
  }
  Widget buildListOfCity(){
    double childAspectRatio = MediaQuery.of(context).size.width / (ResponsiveInfo.isPhone()?60:180);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 450,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 78.0),
                          child: Text(
                              "Cities on our platform",
                              style: ConstFonts().copyWithHeading(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20
                              )
                          ),
                        ),
                        SizedBox(height: 20,),
                        buildCityWidget(assetIcon: 'assets/cities/Foster_city.png',cityName: 'Foster City'),
                        buildCityWidget(assetIcon: 'assets/cities/LosAltos.png',cityName: 'Los Altos City'),
                        buildCityWidget(assetIcon: 'assets/cities/LosAltosHill.png',cityName: 'Los Altos Hill City'),
                        buildCityWidget(assetIcon: 'assets/cities/millbrae_city.png',cityName: 'Millbrae City', isBold: true),
                        buildCityWidget(assetIcon: 'assets/cities/pleasant_hill_city.png',cityName: 'Pleasant Hill City'),
                        buildCityWidget(assetIcon: 'assets/cities/redwood_city.png',cityName: 'Redwood City'),
                        buildCityWidget(assetIcon: 'assets/cities/saratoga_city.jpg',cityName: 'Saratoga City'),
                        buildCityWidget(assetIcon: 'assets/cities/watsonville_city.png',cityName: 'Watsonville City'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }
  Widget buildCityWidget({required String assetIcon, required String cityName, bool? isBold}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 78.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          color: Colors.white.withOpacity(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                  width: ResponsiveInfo.isPhone()?60:110,
                  height: ResponsiveInfo.isPhone()?60:120,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(85),
                    color: Colors.transparent
                  ),
                  padding: EdgeInsets.all(0),
                  child: Center(
                    child: Image.asset(
                        assetIcon,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
            ),
            SizedBox(width: 8,),
            Text(cityName,
                style: ConstFonts().copyWithSubHeading(
                fontWeight: isBold!=null?FontWeight.bold: FontWeight.normal,
                color: isBold!=null?Colors.white:Colors.white.withOpacity(0.2),
                fontSize: isBold!=null?16:15,
            ),)
          ],
        ),
      ),
    );
}
