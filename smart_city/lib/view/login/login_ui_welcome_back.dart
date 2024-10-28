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
import 'package:smart_city/model/user/user_info.dart';
import 'package:smart_city/view/login/login_bloc/login_bloc.dart';

import '../../base/common/responsive_info.dart';
import '../../l10n/l10n_extention.dart';

class LoginUiWelcomeBack extends StatelessWidget {
  LoginUiWelcomeBack({super.key});

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();
    bool isHidePassword = true;
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
          child: (ResponsiveInfo.isTablet() && width > height)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: height,
                        width: width / 2,
                        child: Image.asset(
                          'assets/background_mobile.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          height: height,
                          width: width / 2,
                          color: ConstColors.onPrimaryColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.2,
                              ),
                              Center(
                                  child: Image.asset(
                                'assets/scs-logo.png',
                                height: height * 0.08,
                                width: width * 0.25,
                                color: ConstColors.textFormFieldColor,
                              )),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, bottom: 5),
                                child: Text(
                                  '${L10nX.getStr.welcome_back_to_citiez}, ${userInfo?.username ?? ""}',
                                  style: ConstFonts().copyWithHeading(
                                    fontSize: 28,
                                    color:
                                        ConstColors.textFormFieldColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  L10nX.getStr
                                      .your_journey_awaits_sign_in_to_start,
                                  style: ConstFonts().copyWithSubHeading(
                                      fontSize: 17,
                                      color: ConstColors
                                          .textFormFieldColor),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.04,
                              ),
                              StatefulBuilder(
                                builder: (context, StateSetter setState) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: TextFormField(
                                      style: TextStyle(color:ConstColors.textFormFieldColor ),
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
                                              color: ConstColors
                                                  .textFormFieldColor,
                                              fontSize: 16)),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        _showForgotPasswordDialog(context);
                                      },
                                      child: Text(L10nX.getStr.forgot_password,
                                          style: ConstFonts().copyWithSubHeading(
                                              color: ConstColors
                                                  .textFormFieldColor,
                                              fontSize: 16)),
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
                              // SizedBox(
                              //   height: height * 0.04,
                              // ),
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
                )
              : SizedBox(
                  width: width,
                  height: height,
                  child: SingleChildScrollView(
                    child: Stack(children: [
                      Image.asset(
                        'assets/background_mobile.png',
                        height: height,
                        width: width,
                        fit: BoxFit.fill,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.2,
                          ),
                          Center(
                              child: Image.asset(
                            'assets/scs-logo.png',
                            height: height * 0.08,
                            width: width * 0.25,
                          )),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 5),
                            child: Text(
                              '${L10nX.getStr.welcome_back_to_citiez}, ${userInfo?.username ?? ""}',
                              style: ConstFonts().copyWithHeading(fontSize: 28),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.04,
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
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                          color: Colors.white, fontSize: 16)),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    _showForgotPasswordDialog(context);
                                  },
                                  child: Text(L10nX.getStr.forgot_password,
                                      style: ConstFonts().copyWithSubHeading(
                                          color: Colors.white, fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                          BlocBuilder<LoginBloc, LoginState>(
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
                          // SizedBox(
                          //   height: height * 0.04,
                          // ),
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
                    ]),
                  )),
        )),
      ),
    );
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
}
