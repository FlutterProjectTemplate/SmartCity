import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferenceData.setHaveFirstUsingApp();
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
      body: Column(
        children: [
          // Expanded(
          //   child: PageView(
          //     controller: _pageController,
          //     children: [
          //       IntroView(
          //         image: 'assets/images/intro1.jpg',
          //         title: 'Frustrated with endless traffic jams holding you back?',
          //       ),
          //       IntroView(
          //         image: 'assets/images/intro2.jpg',
          //         title: 'Want a quicker route but not sure where to start?',
          //       ),
          //       IntroView(
          //         image: 'assets/images/intro3.jpg',
          //         title: 'Let’s get moving with Smart City Signals and we’ll guide you to your destination',
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                IntroView(
                  image: 'assets/images/onboading5.png',
                  title: 'Save Time on the Road',
                  subTitle: 'Get real-time updates to avoid delays and reach your destination faster',
                ),
                IntroView(
                  image: 'assets/images/onboading3.png',
                  title: 'Choose Your Own Path',
                  subTitle: 'Take control of your journey and explore routes that suit you best',
                ),
                IntroView(
                  image: 'assets/images/onboading1.jpg',
                  title: 'Track Your Journey',
                  subTitle: 'Stay informed with real-time tracking and make every trip seamless and efficient.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
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
                      (currentPage < 2) ? 'Next' : 'Get Started',
                      style: ConstFonts()
                          .copyWithTitle(color: ConstColors.onPrimaryColor),
                    ),
                    onPressed: () {
                      (currentPage < 2)
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
              Card(
                elevation: 5,
                child: SizedBox(
                  height: height * 0.05,
                  width: width * 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstColors.onPrimaryColor,
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
            ]),
          ),
        ],
      ),
    );
  }
}
