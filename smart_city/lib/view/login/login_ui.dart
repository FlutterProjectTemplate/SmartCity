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

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          child: SizedBox(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: (ResponsiveInfo.isTablet() && width > height)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height,
                            width: width / 2,
                            child: Expanded(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: height * 0.15,
                                    ),
                                    Container(
                                      width: width / 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(20),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'assets/scs-logo.png',
                                        height: height * 0.1,
                                        width: width * 0.3,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Text(
                                      L10nX.getStr.login,
                                      style: ConstFonts().copyWithHeading(
                                          fontSize: 35,
                                          color: ConstColors
                                              .textFormFieldColor),
                                    ),
                                    SizedBox(
                                      height: height * 0.08,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextFormField(
                                        style: TextStyle(color:ConstColors.textFormFieldColor ),
                                        validator: validate,
                                        controller: _emailController,
                                        decoration: ConstDecoration.inputDecoration(
                                            hintText:
                                                "User name/Email/Phone number"),
                                        cursorColor: ConstColors
                                            .textFormFieldColor,
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
                                            style: TextStyle(color:ConstColors.textFormFieldColor ),
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
                                                              : Icons
                                                                  .visibility,
                                                          color: ConstColors
                                                              .textFormFieldColor,
                                                        ))),
                                            cursorColor: ConstColors
                                                .textFormFieldColor,
                                            obscureText: isHidePassword,
                                          ),
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          RegisterUi()));
                                            },
                                            child: Text(
                                                L10nX.getStr.register_button,
                                                style: ConstFonts()
                                                    .copyWithSubHeading(
                                                        color: ConstColors
                                                            .textFormFieldColor,
                                                        fontSize: 16)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _showForgotPasswordDialog(
                                                  context);
                                            },
                                            child: Text(
                                                L10nX.getStr.forgot_password,
                                                style: ConstFonts()
                                                    .copyWithSubHeading(
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
                                        return LoadingAnimationWidget
                                            .staggeredDotsWave(
                                                color: ConstColors.primaryColor,
                                                size: 45);
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          if (_formKey.currentState!
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
                                          width: width / 2 - 50,
                                          height: (ResponsiveInfo.isTablet() && MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) ? MediaQuery.of(context).size.height*0.04 : MediaQuery.of(context).size.height*0.06,
                                          color: ConstColors.primaryColor,
                                          isCircle: false,
                                          child: Text(L10nX.getStr.sign_in,
                                              style: ConstFonts().title),
                                        ).getButton(),
                                      );
                                    }),
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
                        ],
                      )
                    : Stack(children: [
                        Image.asset(
                          'assets/background_mobile.png',
                          height: height,
                          width: width,
                          fit: BoxFit.fill,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.15,
                            ),
                            Image.asset(
                              'assets/scs-logo.png',
                              height: height * 0.1,
                              width: width * 0.3,
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Text(
                              L10nX.getStr.sign_in,
                              style: ConstFonts().copyWithHeading(fontSize: 35),
                            ),
                            SizedBox(
                              height: height * 0.08,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                style: TextStyle(color:ConstColors.textFormFieldColor ),
                                validator: validate,
                                controller: _emailController,
                                decoration: ConstDecoration.inputDecoration(
                                    hintText: "User name/Email/Phone number"),
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
                                    style: TextStyle(color:ConstColors.textFormFieldColor ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return L10nX.getStr
                                            .please_enter_your_information;
                                      }
                                      return null;
                                    },
                                    controller: _passwordController,
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
                                                  .onSecondaryContainerColor,
                                            ))),
                                    cursorColor:
                                        ConstColors.textFormFieldColor,
                                    obscureText: isHidePassword,
                                  ),
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      top: height * 0.03,
                                      bottom: height * 0.03),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  RegisterUi()));
                                    },
                                    child: Text(L10nX.getStr.register_button,
                                        style: ConstFonts().copyWithSubHeading(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 20.0, bottom: height * 0.03),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showForgotPasswordDialog(context);
                                    },
                                    child: Text(L10nX.getStr.forgot_password,
                                        style: ConstFonts().copyWithSubHeading(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                            BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                              if (state.status == LoginStatus.loading) {
                                return LoadingAnimationWidget.staggeredDotsWave(
                                    color: ConstColors.primaryColor, size: 45);
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
                                  height: height * 0.06,
                                  color: ConstColors.primaryColor,
                                  isCircle: false,
                                  child: Text(L10nX.getStr.sign_in,
                                      style: ConstFonts().title),
                                ).getButton(),
                              );
                            }),
                            // SizedBox(
                            //   height: height * 0.04,
                            // ),
                            // Text(
                            //   L10nX.getStr.or_sign_in_with,
                            //   style: ConstFonts().copyWithTitle(fontSize: 18),
                            // ),
                            // IconButton(
                            //     onPressed: () async {
                            //       QuickAlert.show(
                            //         context: context,
                            //         type: QuickAlertType.error,
                            //         title: 'Oops...',
                            //         text: L10nX
                            //             .getStr.biometric_sign_in_not_enabled,
                            //         confirmBtnColor: ConstColors.primaryColor,
                            //       );
                            //     },
                            //     icon: Image.asset(
                            //       "assets/fingerprint.png",
                            //       height: 50,
                            //       width: 50,
                            //     ))
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

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return L10nX.getStr.please_enter_your_information;
    }
    return null;
  }
}
