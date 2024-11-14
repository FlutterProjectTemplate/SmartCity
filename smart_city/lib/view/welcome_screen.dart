import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/resizer/fetch_pixel.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_decoration.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/constant_value/const_size.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/view/login/login_bloc/login_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _welcomeFormKeyLandscape = GlobalKey<FormState>();
  final _welcomeFormKeyPortrait = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isHidePassword = true;

  @override
  void initState() {
    super.initState();
    SharedPreferenceData.setHaveFirstUsingApp();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => LoginBloc(),
      child: ScreenTypeLayout.builder(
          mobile: (_) => Scaffold(
                body: Stack(
                  children: [
                    Image.asset(
                      'assets/images/background16.jpg',
                      height: height,
                      width: width,
                      fit: BoxFit.cover,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    Positioned(
                      top: height * 0.2,
                      left: width * 0.25,
                      child: Image.asset(
                        'assets/logo1.png',
                        height: height * 0.25,
                        width: width * 0.5,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                        top: height * 0.6,
                        left: Dimens.size20Horizontal,
                        right: 0,
                        child: Text(
                          "${L10nX.getStr.welcome_back_to_citiez}",
                          style: ConstFonts().copyWithHeading(),
                        )),
                    Positioned(
                      top: height * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () {
                                context.go('/login');
                              },
                              child: Button(
                                width: width * 0.9,
                                height: height * 0.055,
                                color: ConstColors.primaryColor,
                                isCircle: false,
                                child: Text(L10nX.getStr.get_started,
                                    style: ConstFonts()
                                        .copyWithTitle(fontSize: 20)),
                              ).getButton(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
          tablet: (_) => BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.status == LoginStatus.failure) {
                    InstanceManager().showSnackBar(
                        context: context,
                        text: InstanceManager().errorLoginMessage);
                  } else if (state.status == LoginStatus.success) {
                    context.go('/map');
                  }
                },
                child: OrientationLayoutBuilder(
                  portrait: (_) => Scaffold(
                    body: Form(
                      key: _welcomeFormKeyPortrait,
                      child: SingleChildScrollView(
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/background16.jpg',
                              height: height,
                              width: width,
                              fit: BoxFit.fill,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 185),
                                child: Image.asset(
                                  'assets/logo1.png',
                                  height: height * 0.12,
                                  width: width * 0.15,
                                  fit: BoxFit.fill,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top:
                                          FetchPixel.getPixelHeight(230, true)),
                                  child: Text(
                                    L10nX.getStr.sign_in,
                                    style: ConstFonts()
                                        .copyWithHeading(fontSize: 55),
                                  ),
                                )),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: FetchPixel.getPixelHeight(310, true),
                                    left: FetchPixel.getPixelHeight(80, true),
                                    right: FetchPixel.getPixelHeight(80, true)),
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: ConstDecoration.inputDecoration(
                                      hintText: L10nX
                                          .getStr.user_name_email_phone_number),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: FetchPixel.getPixelHeight(370, true),
                                    left: FetchPixel.getPixelHeight(80, true),
                                    right: FetchPixel.getPixelHeight(80, true)),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: isHidePassword,
                                  decoration: ConstDecoration.inputDecoration(
                                      hintText: L10nX.getStr.password,
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isHidePassword = !isHidePassword;
                                            });
                                          },
                                          icon: Icon(
                                            isHidePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: ConstColors
                                                .textFormFieldColor,
                                          ))),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: FetchPixel.getPixelHeight(450, true),
                                      left: FetchPixel.getPixelHeight(90, true),
                                      right:
                                          FetchPixel.getPixelHeight(90, true)),
                                  child: BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                      if (state.status == LoginStatus.loading) {
                                        return LoadingAnimationWidget
                                            .staggeredDotsWave(
                                                color: ConstColors.primaryColor,
                                                size: 45);
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          if (_welcomeFormKeyPortrait
                                              .currentState!
                                              .validate()) {
                                            context.read<LoginBloc>().add(
                                                  LoginSubmitted(
                                                    _emailController.text,
                                                    _passwordController.text,
                                                  ),
                                                );
                                          } else {
                                            debugPrint("Validation failed");
                                          }
                                        },
                                        child: Button(
                                          width: width * 0.4,
                                          height: height * 0.055,
                                          color: ConstColors.primaryColor,
                                          isCircle: false,
                                          child: Text(L10nX.getStr.get_started,
                                              style: ConstFonts()
                                                  .copyWithTitle(fontSize: 20)),
                                        ).getButton(),
                                      );
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  landscape: (_) => Scaffold(
                      body: Form(
                    key: _welcomeFormKeyLandscape,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height,
                          width: width * 0.5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      FetchPixel.getPixelHeight(120, true),
                                ),
                                Image.asset(
                                  'assets/logo1.png',
                                  height: 180,
                                  fit: BoxFit.contain,
                                  color: Colors.black,
                                ),

                                SizedBox(
                                  height: Dimens.size80Vertical,
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: ConstDecoration.inputDecoration(
                                      hintText: L10nX.getStr
                                          .user_name_email_phone_number),
                                ),
                                SizedBox(
                                  height: Dimens.size40Vertical,
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: isHidePassword,
                                  decoration: ConstDecoration.inputDecoration(
                                      hintText: L10nX.getStr.password,
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isHidePassword =
                                                  !isHidePassword;
                                            });
                                          },
                                          icon: Icon(
                                            isHidePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: ConstColors
                                                .textFormFieldColor,
                                          ))),
                                ),
                                SizedBox(
                                  height: Dimens.size50Vertical,
                                ),
                                BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                  if (state.status == LoginStatus.loading) {
                                    return LoadingAnimationWidget
                                        .staggeredDotsWave(
                                            color: ConstColors.primaryColor,
                                            size: 45);
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      if (_welcomeFormKeyLandscape
                                          .currentState!
                                          .validate()) {
                                        context.read<LoginBloc>().add(
                                              LoginSubmitted(
                                                _emailController.text,
                                                _passwordController.text,
                                              ),
                                            );
                                      } else {
                                        debugPrint("Validation failed");
                                      }
                                    },
                                    child: Button(
                                      width: width * 0.4,
                                      height: height * 0.055,
                                      color: ConstColors.primaryColor,
                                      isCircle: false,
                                      child: Text(L10nX.getStr.get_started,
                                          style: ConstFonts()
                                              .copyWithTitle(fontSize: 20)),
                                    ).getButton(),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: height,
                              width: width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/background16.jpg',
                                    height: height,
                                    width: width * 0.5,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  )),
                ),
              )),
    );
  }
}
