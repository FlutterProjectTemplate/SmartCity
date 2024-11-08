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
import 'package:smart_city/services/api/register/register_api.dart';
import 'package:smart_city/services/api/register/register_model/register_model.dart';
import 'package:smart_city/view/login/login_bloc/login_bloc.dart';
import 'package:smart_city/view/login/login_ui.dart';

import '../../../base/common/responsive_info.dart';
import '../../../base/widgets/custom_drop_down.dart';

class RegisterUi extends StatefulWidget {
  const RegisterUi({super.key});

  @override
  State<RegisterUi> createState() => _RegisterUiState();
}

class _RegisterUiState extends State<RegisterUi> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _typerController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPassController = TextEditingController();

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isHidePassword = true;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: SizedBox(
              width: width,
              height: height,
              child: (ResponsiveInfo.isTablet() && width > height)
                  ? Stack(
                      children: [
                        Image.asset(
                          height: height,
                          width: width,
                          'assets/images/background16.jpg',
                          fit: BoxFit.fill,
                        ),
                        Center(
                          child: Container(
                            width: width / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: height * 0.05,
                                ),
                                // Image.asset(
                                //   'assets/scs-logo.png',
                                //   height: height * 0.1,
                                //   width: width * 0.3,
                                //   color: ConstColors.onSecondaryContainerColor,
                                // ),
                                Image.asset(
                                  color: Colors.white,
                                  'assets/logo1.png',
                                  height: height * 0.2,
                                  width: width * 0.3,
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: ConstColors.textFormFieldColor),
                                    validator: validate,
                                    controller: _nameController,
                                    decoration: ConstDecoration.inputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.person_2_outlined),
                                        ),
                                        hintText: L10nX.getStr.name),
                                    cursorColor:
                                        ConstColors.onSecondaryContainerColor,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: ConstColors
                                            .onSecondaryContainerColor),
                                    validator: validate,
                                    controller: _emailController,
                                    decoration: ConstDecoration.inputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.email_outlined),
                                        ),
                                        hintText: L10nX.getStr.email),
                                    cursorColor: ConstColors.textFormFieldColor,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: ConstColors.textFormFieldColor),
                                    validator: validate,
                                    controller: _typerController,
                                    decoration: ConstDecoration.inputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.person_2_outlined),
                                        ),
                                        hintText: L10nX.getStr.type_vehicle),
                                    cursorColor: ConstColors.textFormFieldColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: CustomDropdown(
                                    items: ['Option 1', 'Option 2', 'Option 3'],
                                    initialValue: 'Option 1',
                                    itemWidget: Text('data'),
                                    borderRadious: 20,
                                    onChanged: (value) {
                                      print("Selected: $value");
                                    },
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
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(Icons.lock_outline),
                                                ),
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
                                        cursorColor:
                                            ConstColors.textFormFieldColor,
                                        obscureText: isHidePassword,
                                      ),
                                    );
                                  },
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
                                        controller: _confirmPassController,
                                        decoration:
                                            ConstDecoration.inputDecoration(
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(Icons.lock_outline),
                                                ),
                                                hintText: L10nX
                                                    .getStr.confirm_password,
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
                                        cursorColor:
                                            ConstColors.textFormFieldColor,
                                        obscureText: isHidePassword,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        RegisterApi registerApi = RegisterApi(
                                            registerModel: RegisterModel(
                                          username: _nameController.text,
                                          // phone: _phoneController.text,
                                          email: _emailController.text,
                                          vehicleType:
                                              int.parse(_typerController.text),
                                        ));
                                        context.go('/login');
                                      } else {
                                        debugPrint("Validation failed");
                                      }
                                    },
                                    child: Button(
                                      width: width - 50,
                                      height: height * 0.06,
                                      color: ConstColors.primaryColor,
                                      isCircle: false,
                                      child: Text(L10nX.getStr.register,
                                          style: ConstFonts().title),
                                    ).getButton(),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                Row(
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
                                                        LoginUi()));
                                          },
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      L10nX.getStr.login_button,
                                                  style: ConstFonts()
                                                      .copyWithSubHeading(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: L10nX.getStr.login,
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
                                    SizedBox(
                                      height: height * 0.04,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: width,
                      height: height,
                      child: Stack(children: [
                        Image.asset(
                          height: height,
                          width: width,
                          'assets/images/background17.jpg',
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.6),
                          ),
                          margin: EdgeInsets.only(top: 80, left: 30, right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/logo1.png',
                                height: height * 0.2,
                                width: width * 0.5,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Text(
                                L10nX.getStr.register,
                                style:
                                    ConstFonts().copyWithHeading(fontSize: 16),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: ConstColors.textFormFieldColor),
                                  validator: validate,
                                  controller: _nameController,
                                  decoration: ConstDecoration.inputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.person_2_outlined),
                                      ),
                                      hintText: L10nX.getStr.name),
                                  cursorColor: ConstColors.textFormFieldColor,
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: ConstColors.textFormFieldColor),
                                  validator: validate,
                                  controller: _emailController,
                                  decoration: ConstDecoration.inputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.email_outlined),
                                      ),
                                      hintText: L10nX.getStr.email),
                                  cursorColor: ConstColors.textFormFieldColor,
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: ConstColors.textFormFieldColor),
                                  validator: validate,
                                  controller: _typerController,
                                  decoration: ConstDecoration.inputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.lock_outline),
                                      ),
                                      hintText: L10nX.getStr.type_vehicle),
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
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.lock_outline),
                                              ),
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
                                      cursorColor:
                                          ConstColors.textFormFieldColor,
                                      obscureText: isHidePassword,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
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
                                      controller: _confirmPassController,
                                      decoration:
                                          ConstDecoration.inputDecoration(
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.lock_outline),
                                              ),
                                              hintText:
                                                  L10nX.getStr.confirm_password,
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
                                      cursorColor:
                                          ConstColors.textFormFieldColor,
                                      obscureText: isHidePassword,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      RegisterApi registerApi = RegisterApi(
                                          registerModel: RegisterModel(
                                        username: _nameController.text,
                                        // phone: _phoneController.text,
                                        email: _emailController.text,
                                        vehicleType:
                                            int.parse(_typerController.text),
                                      ));
                                      // context.go('/login');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) => LoginUi()));
                                    } else {
                                      debugPrint("Validation failed");
                                    }
                                  },
                                  child: Button(
                                    width: width - 50,
                                    height: height * 0.06,
                                    color: ConstColors.primaryColor,
                                    child: Text(L10nX.getStr.register,
                                        style: ConstFonts().title),
                                  ).getButton(),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10, bottom: 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      LoginUi()));
                                        },
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: L10nX.getStr.login_button,
                                                style: ConstFonts()
                                                    .copyWithSubHeading(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: L10nX.getStr.login,
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
                            ],
                          ),
                        ),
                      ]),
                    )),
        ));
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
