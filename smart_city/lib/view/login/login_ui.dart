import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_alert_dialog.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_decoration.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/l10n/l10n_extention.dart';
import 'package:smart_city/view/login/login_bloc/login_bloc.dart';
import 'package:smart_city/view/login/register/register_ui.dart';

import '../../base/common/responsive_info.dart';
import '../../base/widgets/custom_container.dart';
import '../../constant_value/const_size.dart';
import '../../helpers/localizations/language_helper.dart';
import '../setting/component/change_language.dart';
import '../setting/component/country_flag.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isHidePassword = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get the current patch number and print it to the console.
    // It will be `null` if no patches are installed.
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            InstanceManager().showSnackBar(
                context: context, text: InstanceManager().errorLoginMessage);
          } else if (state.status == LoginStatus.success) {
            context.go('/map');
          }
        },
        child: Scaffold(
            // resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              child: (ResponsiveInfo.isTablet())
                  ? buildTablet(context)
                  : buildMobile(context)
            )),
      ),
    );
  }

  Widget buildTablet(BuildContext context) {
    List<LanguageInfo> languageInfo = LanguageHelper().supportedLanguages;
    Locale selectedLanguage = LanguageHelper().getCurrentLocale();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
        children:[
          Image.asset(
            height: height,
            width: width,
            'assets/images/background16.jpg', fit: BoxFit.fill,),
          // Positioned(
          //   top: Dimens.size40Vertical,
          //   right: 20,
          //   child: PopupMenuButton<int>(
          //     color: Colors.black,
          //     onSelected: (value) {
          //       LanguageHelper().changeLanguage(
          //         LanguageInfo(
          //           languageIndex: languageInfo[value].languageIndex,
          //         ),
          //         context,
          //       );
          //     },
          //     child: CountryFlag(countryCode: ((selectedLanguage.toString()).substring(3))),
          //     itemBuilder: (BuildContext context) => List.generate(
          //       languageInfo.length,
          //           (index) => PopupMenuItem<int>(
          //         value: index,
          //         child: Row(
          //           mainAxisSize: MainAxisSize.max,
          //           children: [
          //             CountryFlag(countryCode: languageInfo[index].country!),
          //             SizedBox(width: 20),
          //             Text(
          //               languageInfo[index].language!,
          //               style: ConstFonts().copyWithTitle(
          //                 fontSize: 16,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: (height > width) ? width * 0.6 : width * 0.4 ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.6),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: (height > width) ? height * 0.02 : height * 0.04,
                    ),
                    Hero(
                      tag: 'lo-go',
                      child: Image.asset(
                        'assets/logo1.png',
                        color: Colors.white,
                        height: height * 0.2,
                        width: width * 0.3,
                      ),
                    ),
                    SizedBox(
                      height: (height > width) ? height * 0.02 : height * 0.04,
                    ),
                    Text(
                      L10nX.getStr.sign_in,
                      style: ConstFonts().copyWithHeading(
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: (height > width) ? height * 0.02 : height * 0.04,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: TextFormField(
                        style: TextStyle(
                            color:
                            ConstColors.textFormFieldColor),
                        validator: validate,
                        controller: _emailController,
                        decoration: ConstDecoration.inputDecoration(
                            prefixIcon:
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.person_2_outlined, color: ConstColors
                                  .textFormFieldColor,),
                            ),
                            hintText:
                            "Username"),
                        cursorColor:
                        ConstColors.textFormFieldColor,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    StatefulBuilder(
                      builder: (context, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: TextFormField(
                            style: TextStyle(
                                color: ConstColors
                                    .textFormFieldColor),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return L10nX.getStr
                                    .please_enter_your_information;
                              }
                              return null;
                            },
                            controller: _passwordController,
                            decoration:
                            ConstDecoration.inputDecoration(
                                prefixIcon:
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.lock_outline, color: ConstColors
                                      .textFormFieldColor,),
                                ),
                                hintText:
                                L10nX.getStr.password,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isHidePassword =
                                        !isHidePassword;
                                      });
                                    },
                                    icon: Icon(
                                      isHidePassword
                                          ? Icons
                                          .visibility_off
                                          : Icons.visibility,
                                      color: ConstColors
                                          .textFormFieldColor,
                                    ))),
                            cursorColor:
                            ConstColors.textFormFieldColor,
                            obscureText: isHidePassword,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Visibility(
                          visible: true,
                          child: TextButton(
                            onPressed: () {
                              _showForgotPasswordDialog(context);
                            },
                            child: Text(
                                L10nX.getStr.forgot_password,
                                style: ConstFonts()
                                    .copyWithSubHeading(
                                    color: Colors.white,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
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
                              if (_formKey.currentState!.validate()) {
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: Button(
                                width: width,
                                height: (ResponsiveInfo.isTablet() &&
                                    MediaQuery.of(context)
                                        .size
                                        .width <
                                        MediaQuery.of(context)
                                            .size
                                            .height)
                                    ? MediaQuery.of(context)
                                    .size
                                    .height *
                                    0.04
                                    : MediaQuery.of(context)
                                    .size
                                    .height *
                                    0.06,
                                color: ConstColors.primaryColor,
                                isCircle: false,
                                child: Text(L10nX.getStr.sign_in,
                                    style: ConstFonts().title),
                              ).getButton(),
                            ),
                          );
                        }),
                    SizedBox(
                      height: 30,
                    ),
                    Visibility(
                      visible: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, top: 20, bottom: 20),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              RegisterUi()));
                                },
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: L10nX
                                            .getStr.register_button,
                                        style: ConstFonts()
                                            .copyWithSubHeading(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextSpan(
                                        text: L10nX.getStr.register,
                                        style: ConstFonts()
                                            .copyWithSubHeading(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.size15Vertical,)
                    // SizedBox(
                    //   height: height * 0.04,
                    // ),
                    // Text(
                    //   L10nX.getStr.or_sign_in_with,
                    //   style: ConstFonts().copyWithTitle(
                    //       fontSize: 18,
                    //       color: ConstColors
                    //           .onSecondaryContainerColor),
                    // ),
                    // IconButton(
                    //     onPressed: () async {
                    //       QuickAlert.show(
                    //         context: context,
                    //         type: QuickAlertType.error,
                    //         title: 'Oops...',
                    //         text: L10nX.getStr
                    //             .biometric_sign_in_not_enabled,
                    //         confirmBtnColor: ConstColors
                    //             .onSecondaryContainerColor,
                    //       );
                    //     },
                    //     icon: Image.asset(
                    //       "assets/fingerprint.png",
                    //       height: 50,
                    //       width: 50,
                    //     ))
                  ],
                ),
              ),
            ),
          ),
        ]
    );
    // : Column(
    //   children: [
    //     ClipPath(
    //         clipper: CurvedRectangleClipper(),
    //         child: SizedBox(
    //           height: height / 2,
    //           width: width,
    //           child: Stack(children: [
    //             Image.asset(
    //               height: height,
    //               width: width,
    //               'assets/images/background16.jpg',
    //               fit: BoxFit.cover,
    //             ),
    //             Center(
    //               child: Image.asset(
    //                 'assets/logo1.png',
    //                 height: height * 0.25,
    //                 width: width * 0.6,
    //                 color: Colors.white,
    //               ),
    //             )
    //           ]),
    //         ),
    //       ),
    //     Padding(
    //       padding:
    //       const EdgeInsets.only(left: 20, right: 20, top: 20),
    //       child: TextFormField(
    //         style: TextStyle(
    //             color: ConstColors.textFormFieldColor),
    //         validator: validate,
    //         controller: _emailController,
    //         decoration: ConstDecoration.inputDecoration(
    //             prefixIcon: IconButton(icon: Icon(Icons.person_2_outlined), onPressed: (){},),
    //             hintText: "Username"),
    //         cursorColor: ConstColors.textFormFieldColor,
    //       ),
    //     ),
    //     SizedBox(
    //       height: 20,
    //     ),
    //     StatefulBuilder(
    //       builder: (context, StateSetter setState) {
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(
    //               horizontal: 20),
    //           child: TextFormField(
    //             style: TextStyle(
    //                 color: ConstColors.textFormFieldColor),
    //             validator: (value) {
    //               if (value == null || value.isEmpty) {
    //                 return L10nX.getStr
    //                     .please_enter_your_information;
    //               }
    //               return null;
    //             },
    //             controller: _passwordController,
    //             decoration: ConstDecoration.inputDecoration(
    //                 hintText: L10nX.getStr.password,
    //                 prefixIcon: IconButton(
    //                     onPressed: () {
    //                       setState(() {
    //                         isHidePassword =
    //                         !isHidePassword;
    //                       });
    //                     },
    //                     icon: Icon(
    //                       isHidePassword
    //                           ? Icons.lock_outline
    //                           : Icons.lock_open_outlined,
    //                       color: ConstColors
    //                           .onSecondaryContainerColor,
    //                     ))),
    //             cursorColor: ConstColors.textFormFieldColor,
    //             obscureText: isHidePassword,
    //           ),
    //         );
    //       },
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.only(
    //               right: 20.0, top: 10, bottom: 10),
    //           child: GestureDetector(
    //             onTap: () {
    //               _showForgotPasswordDialog(context);
    //             },
    //             child: Text(L10nX.getStr.forgot_password,
    //                 style: ConstFonts().copyWithSubHeading(
    //                     color: Colors.black, fontSize: 16)),
    //           ),
    //         ),
    //       ],
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //       child: BlocBuilder<LoginBloc, LoginState>(
    //           builder: (context, state) {
    //             if (state.status == LoginStatus.loading) {
    //               return LoadingAnimationWidget.staggeredDotsWave(
    //                   color: ConstColors.primaryColor, size: 45);
    //             }
    //             return GestureDetector(
    //               onTap: () {
    //                 if (_formKey.currentState!.validate()) {
    //                   context.read<LoginBloc>().add(
    //                     LoginSubmitted(
    //                       _emailController.text,
    //                       _passwordController.text,
    //                     ),
    //                   );
    //                 } else {
    //                   debugPrint("Validation failed");
    //                 }
    //               },
    //               child: Button(
    //                 width: width - 50,
    //                 height: (ResponsiveInfo.isTablet() &&
    //                     MediaQuery.of(context).size.width <
    //                         MediaQuery.of(context)
    //                             .size
    //                             .height)
    //                     ? MediaQuery.of(context).size.height *
    //                     0.04
    //                     : MediaQuery.of(context).size.height *
    //                     0.06,
    //                 color: ConstColors.primaryColor,
    //                 child: Text(L10nX.getStr.login,
    //                     style: ConstFonts().title),
    //               ).getButton(),
    //             );
    //           }),
    //     ),
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Expanded(
    //                       child: Divider(
    //                         color: Colors.black,
    //                         thickness: 1,
    //                         endIndent: 8, // Space between the line and text
    //                       ),
    //                     ),
    //                     Text(
    //                       'or',
    //                       style: TextStyle(fontSize: 18, color: Colors.black), // Replace with ConstFonts().copyWithTitle if needed
    //                     ),
    //                     Expanded(
    //                       child: Divider(
    //                         color: Colors.black,
    //                         thickness: 1,
    //                         indent: 8, // Space between the text and line
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //     Button(
    //       width: width - 50,
    //       height: (ResponsiveInfo.isTablet() &&
    //           MediaQuery.of(context).size.width <
    //               MediaQuery.of(context)
    //                   .size
    //                   .height)
    //           ? MediaQuery.of(context).size.height *
    //           0.04
    //           : MediaQuery.of(context).size.height *
    //           0.06,
    //       borderColor: Colors.black,
    //       color: ConstColors.onPrimaryColor,
    //       child: Text(L10nX.getStr.register,
    //           style: ConstFonts().title.copyWith(
    //             color: Colors.black
    //           )),
    //     ).getButton(),
    //   ],
    // )
  }

  Widget buildMobile(BuildContext context) {
    List<LanguageInfo> languageInfo = LanguageHelper().supportedLanguages;
    Locale selectedLanguage = LanguageHelper().getCurrentLocale();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Image.asset(
        height: height,
        width: width,
        'assets/images/background16.jpg',
        fit: BoxFit.cover,
      ),
      Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.2),
        ),
      ),
      // Positioned(
      //     top: Dimens.size50Vertical,
      //     right: Dimens.size15Horizontal,
      //     child: InkWell(
      //       onTap: _openChangeLanguage,
      //       child: SizedBox(
      //           height: 30,
      //           width: 30,
      //           child: Image.asset(
      //             'assets/images/language.png',
      //             color: Colors.white,
      //           )),
      //     )),
      // Positioned(
      //   top: Dimens.size40Vertical,
      //   right: 20,
      //   child: PopupMenuButton<int>(
      //     color: Colors.black,
      //     onSelected: (value) {
      //         LanguageHelper().changeLanguage(
      //           LanguageInfo(
      //             languageIndex: languageInfo[value].languageIndex,
      //           ),
      //           context,
      //         );
      //     },
      //     child: CountryFlag(countryCode: ((selectedLanguage.toString()).substring(3))),
      //     itemBuilder: (BuildContext context) => List.generate(
      //       languageInfo.length,
      //           (index) => PopupMenuItem<int>(
      //         value: index,
      //         child: Row(
      //           mainAxisSize: MainAxisSize.max,
      //           children: [
      //             CountryFlag(countryCode: languageInfo[index].country!),
      //             SizedBox(width: 20),
      //             Text(
      //               languageInfo[index].language!,
      //               style: ConstFonts().copyWithTitle(
      //                 fontSize: 16,
      //                 color: Colors.white,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),


      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.6),
            ),
            // margin: EdgeInsets.symmetric(vertical: 150,horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Hero(
                    tag: 'lo-go',
                    child: Image.asset(
                      'assets/logo1.png',
                      height: height * 0.25,
                      width: width * 0.5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    L10nX.getStr.sign_in,
                    style: ConstFonts()
                        .copyWithHeading(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20),
                    child: TextFormField(
                      style: TextStyle(
                          color: ConstColors.textFormFieldColor),
                      validator: validate,
                      controller: _emailController,
                      decoration: ConstDecoration.inputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.person_2_outlined, color: ConstColors
                                .textFormFieldColor,),
                          ),
                          hintText: "Username"),
                      cursorColor: ConstColors.textFormFieldColor,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StatefulBuilder(
                    builder: (context, StateSetter setState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20),
                        child: TextFormField(
                          style: TextStyle(
                              color:
                              ConstColors.textFormFieldColor),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return L10nX.getStr
                                  .please_enter_your_information;
                            }
                            return null;
                          },
                          controller: _passwordController,
                          decoration:
                          ConstDecoration.inputDecoration(
                              hintText: L10nX.getStr.password,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.lock_outline, color: ConstColors
                                    .textFormFieldColor,),
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isHidePassword =
                                      !isHidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    isHidePassword
                                        ? Icons
                                        .visibility_off
                                        : Icons
                                        .visibility,
                                    color: ConstColors
                                        .textFormFieldColor,
                                  ))),
                          cursorColor:
                          ConstColors.textFormFieldColor,
                          obscureText: isHidePassword,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 20.0, top: 10, bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              _showForgotPasswordDialog(context);
                            },
                            child: Text(
                                L10nX.getStr.forgot_password,
                                style: ConstFonts()
                                    .copyWithSubHeading(
                                    color: Colors.white,
                                    fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0),
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
                              if (_formKey.currentState!.validate()) {
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
                              width: width - 50,
                              height: (ResponsiveInfo.isTablet() &&
                                  MediaQuery.of(context)
                                      .size
                                      .width <
                                      MediaQuery.of(context)
                                          .size
                                          .height)
                                  ? MediaQuery.of(context)
                                  .size
                                  .height *
                                  0.04
                                  : MediaQuery.of(context)
                                  .size
                                  .height *
                                  0.06,
                              color: ConstColors.primaryColor,
                              child: Text(L10nX.getStr.login,
                                  style: ConstFonts().title),
                            ).getButton(),
                          );
                        }),
                  ),
                  Visibility(
                    visible: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 20, bottom: 20),
                          child: GestureDetector(
                              onTap: () {
                                context.push('/register');
                              },
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: L10nX
                                          .getStr.register_button,
                                      style: ConstFonts()
                                          .copyWithSubHeading(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextSpan(
                                      text: L10nX.getStr.register,
                                      style: ConstFonts()
                                          .copyWithSubHeading(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.size15Vertical,)
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog.forgotPasswordDialog();
        });
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return L10nX.getStr.please_enter_your_information;
    }
    return null;
  }

  void _openChangeLanguage() {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (context) => const ChangeLanguage(),
    );
    // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => ChangeLanguage()));
  }
}
