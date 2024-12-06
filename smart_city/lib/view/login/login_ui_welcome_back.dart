import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/custom_alert_dialog.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_decoration.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/model/user/user_info.dart';
import 'package:smart_city/view/login/login_bloc/login_bloc.dart';
import '../../base/common/responsive_info.dart';
import '../../constant_value/const_size.dart';
import '../../helpers/localizations/language_helper.dart';
import '../../l10n/l10n_extention.dart';
import '../setting/component/change_language.dart';
import '../setting/component/country_flag.dart';

class LoginUiWelcomeBack extends StatefulWidget {
  LoginUiWelcomeBack({super.key});

  @override
  State<LoginUiWelcomeBack> createState() => _LoginUiWelcomeBackState();
}

class _LoginUiWelcomeBackState extends State<LoginUiWelcomeBack> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();
  UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
  bool isHidePassword = true;
  
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
      children: [
        Image.asset(
          height: height,
          width: width,
          'assets/images/background16.jpg', fit: BoxFit.fill,),
        // Positioned(
        //   top: Dimens.size30Vertical,
        //   right: Dimens.size15Horizontal,
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
        Center(
          child: Container(
            width: (height > width) ? width * 0.6 : width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.6),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  Center(
                      child: Hero(
                        tag: 'lo-go',
                        child: Image.asset(
                          color: Colors.white,
                          'assets/logo1.png',
                          height: height * 0.2,
                          width: width * 0.3,
                        ),
                      ),),
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  Center(
                    child: Text(
                      L10nX.getStr.welcome_back,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ConstFonts().copyWithHeading(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      userDetail?.name ?? "",
                      style: ConstFonts().copyWithHeading(fontSize: 28),
                    ),
                  ),
                  SizedBox(
                    height: (height > width) ? height * 0.02 : height * 0.04,
                  ),
                  StatefulBuilder(
                    builder: (context, StateSetter setState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20),
                        child: TextFormField(
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
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isHidePassword =
                                      !isHidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    isHidePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: ConstColors
                                        .onSecondaryContainerColor,
                                  ))),
                          cursorColor:
                          ConstColors.textFormFieldColor,
                          obscureText: isHidePassword,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            SqliteManager()
                                .deleteCurrentLoginUserInfo();
                            context.go('/login');
                          },
                          child: Text(L10nX.getStr.switch_account,
                              style: ConstFonts().copyWithSubHeading(
                                  color: Colors.white,
                                  fontSize: 16)),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: true,
                          child: TextButton(
                            onPressed: () {
                              _showForgotPasswordDialog(context);
                            },
                            child: Text(L10nX.getStr.forgot_password,
                                style: ConstFonts().copyWithSubHeading(
                                    color: Colors.white,
                                    fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state.status == LoginStatus.loading) {
                          return Center(
                            child: LoadingAnimationWidget
                                .staggeredDotsWave(
                                color: ConstColors.primaryColor,
                                size: 45),
                          );
                        }
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(
                                  LoginSubmitted(
                                    userInfo!.username ?? "",
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
                                width: width - 50,
                                height: (ResponsiveInfo.isTablet() && MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) ? MediaQuery.of(context).size.height*0.04 : MediaQuery.of(context).size.height*0.060,
                                color: ConstColors.primaryColor,
                                isCircle: false,
                                child: Text(L10nX.getStr.sign_in,
                                    style: ConstFonts().title),
                              ).getButton(),
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  // Center(
                  //   child: Text(
                  //     L10nX.getStr.or_sign_in_with,
                  //     style: ConstFonts().copyWithSubHeading(
                  //         fontSize: 18,
                  //         color: ConstColors
                  //             .onSecondaryContainerColor),
                  //   ),
                  // ),
                  // Center(
                  //   child: IconButton(
                  //       onPressed: () async {
                  //         bool turnOnSignInBiometric =
                  //             await SharedPreferenceData
                  //                 .checkSignInBiometric();
                  //         if (turnOnSignInBiometric) {
                  //           bool authenticated = await SqliteManager
                  //               .getInstance
                  //               .authenticate();
                  //           if (authenticated) {
                  //             await SharedPreferenceData.setLogIn();
                  //             context.go('/map');
                  //           } else {
                  //             InstanceManager().showSnackBar(
                  //                 context: context,
                  //                 text: L10nX.getStr
                  //                     .authentication_biometric_failure);
                  //           }
                  //         } else {
                  //           QuickAlert.show(
                  //               context: context,
                  //               type: QuickAlertType.error,
                  //               title: 'Oops...',
                  //               text: L10nX.getStr
                  //                   .biometric_sign_in_not_enabled,
                  //               confirmBtnColor:
                  //                   ConstColors.primaryColor);
                  //         }
                  //       },
                  //       icon: Image.asset(
                  //         "assets/fingerprint.png",
                  //         height: 50,
                  //         width: 50,
                  //         color:
                  //             ConstColors.onSecondaryContainerColor,
                  //       )),
                  // )
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
      Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(0.6),
          ),
          margin: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'lo-go',
                  child: Image.asset(
                    'assets/logo1.png',
                    height: height * 0.25,
                    width: width * 0.5,
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Text(
                    L10nX.getStr.welcome_back,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ConstFonts().copyWithHeading(fontSize: 16),
                  ),
                ),Center(
                  child: Text(
                    userDetail?.name ?? "",
                    style: ConstFonts().copyWithHeading(fontSize: 28),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                StatefulBuilder(
                  builder: (context, StateSetter setState) {
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        style: TextStyle(color:ConstColors.onSecondaryContainerColor ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return L10nX
                                .getStr.please_enter_your_information;
                          }
                          return null;
                        },
                        controller: _passwordController,
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
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: ConstColors
                                      .onSecondaryContainerColor,
                                ))),
                        cursorColor:
                        ConstColors.onSecondaryContainerColor,
                        obscureText: isHidePassword,
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          SqliteManager()
                              .deleteCurrentLoginUserInfo();
                          context.go('/login');
                          // Navigator.push(context, MaterialPageRoute(builder: (builder) => Test()));
                        },
                        child: Text(L10nX.getStr.switch_account,
                            style: ConstFonts().copyWithSubHeading(
                                color: Colors.white, fontSize: 14)),
                      ),
                      Spacer(),
                      Visibility(
                        visible: true,
                        child: TextButton(
                          onPressed: () {
                            _showForgotPasswordDialog(context);
                          },
                          child: Text(L10nX.getStr.forgot_password,
                              style: ConstFonts().copyWithSubHeading(
                                  color: Colors.white, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state.status == LoginStatus.loading) {
                          return Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: ConstColors.primaryColor, size: 45),
                          );
                        }
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              UserInfo? userInfo =
                              SqliteManager().getCurrentLoginUserInfo();
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(
                                  LoginSubmitted(
                                    userInfo!.username ?? "",
                                    _passwordController.text,
                                  ),
                                );
                              } else {
                                debugPrint("Validation failed");
                              }
                            },
                            child: Button(
                              width: width - 50,
                              height: (ResponsiveInfo.isTablet() && MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) ? MediaQuery.of(context).size.height*0.04 : MediaQuery.of(context).size.height*0.060,
                              color: ConstColors.primaryColor,
                              isCircle: false,
                              child: Text(L10nX.getStr.sign_in,
                                  style: ConstFonts().title),
                            ).getButton(),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: Text(
                //     L10nX.getStr.or_sign_in_with,
                //     style:
                //         ConstFonts().copyWithSubHeading(fontSize: 18),
                //   ),
                // ),
                // Center(
                //   child: IconButton(
                //       onPressed: () async {
                //         bool turnOnSignInBiometric =
                //             await SharedPreferenceData
                //                 .checkSignInBiometric();
                //         if (turnOnSignInBiometric) {
                //           bool authenticated = await SqliteManager
                //               .getInstance
                //               .authenticate();
                //           if (authenticated) {
                //             await SharedPreferenceData.setLogIn();
                //             context.go('/map');
                //           } else {
                //             InstanceManager().showSnackBar(
                //                 context: context,
                //                 text: L10nX.getStr
                //                     .authentication_biometric_failure);
                //           }
                //         } else {
                //           QuickAlert.show(
                //               context: context,
                //               type: QuickAlertType.error,
                //               title: 'Oops...',
                //               text: L10nX.getStr
                //                   .biometric_sign_in_not_enabled,
                //               confirmBtnColor:
                //                   ConstColors.primaryColor);
                //         }
                //       },
                //       icon: Image.asset(
                //         "assets/fingerprint.png",
                //         height: 50,
                //         width: 50,
                //       )),
                // )
              ],
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

  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return L10nX.getStr.please_enter_mobile_number;
    } else if (!regExp.hasMatch(value)) {
      return L10nX.getStr.please_enter_valid_mobile_number;
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
