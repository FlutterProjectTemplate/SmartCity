import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/base/utlis/loading_common.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/base/widgets/popup_confirm/confirm_popup_page.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_decoration.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/services/api/change_password/change_password_api.dart';
import 'package:smart_city/services/api/change_password/change_password_model/change_password_model.dart';
import 'package:smart_city/services/api/forgot_password/forgot_password_api.dart';

import '../../l10n/l10n_extention.dart';

class CustomAlertDialog {
  static final formKeyForgotPassword = GlobalKey<FormState>();
  static final emailForgotPasswordController = TextEditingController();
  static final oldPasswordController = TextEditingController();
  static final newPasswordController = TextEditingController();
  static final confirmPasswordController = TextEditingController();
  static final formKeyChangePassword = GlobalKey<FormState>();

  static TextEditingController phoneController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController addressController = TextEditingController();
  static GlobalKey formKeyUpdateProfile = GlobalKey<FormState>();

  static Widget forgotPasswordDialog() {
    String? validateMobile(String? value) {
      String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
      RegExp regExp = RegExp(pattern);
      if (value == null || value.isEmpty) {
        return 'Please enter your email';
      } else if (!regExp.hasMatch(value)) {
        return 'Please enter valid your email';
      }
      return null;
    }

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        backgroundColor: ConstColors.secondaryColor,
        insetPadding: (ResponsiveInfo.isTablet())
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4)
            : EdgeInsets.symmetric(horizontal: 10),
        icon: Image.asset(
          "assets/password.png",
          height: 50,
          width: 50,
          color: ConstColors.surfaceColor,
        ),
        iconPadding: const EdgeInsets.symmetric(vertical: 10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Forgot Password',
              style: ConstFonts().copyWithTitle(
                fontSize: 19,
                color: ConstColors.textFormFieldColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('We will send you a verification link for you',
                style: ConstFonts().copyWithSubHeading(
                  fontSize: 15,
                  color: ConstColors.textFormFieldColor,
                )),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        content: Form(
          key: formKeyForgotPassword,
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            controller: emailForgotPasswordController,
            validator: validateMobile,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.singleLineFormatter,
            ],
            decoration: ConstDecoration.inputDecoration(
              hintText: "Email",
              borderRadius: 30,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.lock_outline),
              ),
            ),
            cursorColor: ConstColors.textFormFieldColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              /*if (formKeyForgotPassword.currentState!.validate()) {
                context
                    .push('/forgot-password/${forgotPasswordController.text}');
                forgotPasswordController.clear();
              } else {
                debugPrint("Validation failed");
              }*/
              CustomLoading().showLoading();

              ForgotPasswordApi forgotPasswordApi = ForgotPasswordApi(email: emailForgotPasswordController.text );
              dynamic result =  await  forgotPasswordApi.call();
              CustomLoading().dismissLoading();
              if(result.runtimeType == String)
                {
                  ConfirmPopupPage(
                    title: "Error",
                    content: result.toString(),
                    enableCancelButton: false,
                    onCancel: () {
                    },
                    onAccept:  () {
                    },
                  ).show(context);
                }
              else
              {
                ConfirmPopupPage(
                  title: "Successful",
                  content: "Please check your mail and follow the instructions.",
                  enableCancelButton: false,
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onAccept:  () {
                    Navigator.of(context).pop();
                  },
                ).show(context);
              }

            },
            child: Button(
                    width: MediaQuery.of(context).size.width - 20,
                    height: (ResponsiveInfo.isTablet() &&
                            MediaQuery.of(context).size.width <
                                MediaQuery.of(context).size.height)
                        ? MediaQuery.of(context).size.height * 0.04
                        : MediaQuery.of(context).size.height * 0.065,
                    isCircle: false,
                    color: ConstColors.primaryColor,
                    child: Text('Send', style: ConstFonts().title))
                .getButton(),
          ),
        ],
        actionsPadding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).size.height * 0.04),
      );
    });
  }

  static Widget reportDialog() {
    String? selectedOption;
    final List<String> options = [
      'Can\'t display map',
      'Can\'t start tracking',
      'Can\'t stop tracking',
      'Control commands are not responded to',
      'The map is not currently tracking with your current location'
    ];
    final List<bool> isSelected =
        List.generate(options.length, (index) => false);

    return StatefulBuilder(builder: (context, StateSetter setState) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return AlertDialog(
        backgroundColor: ConstColors.tertiaryContainerColor,
        insetPadding: (ResponsiveInfo.isTablet())
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4)
            : EdgeInsets.symmetric(horizontal: 10),
        title: Center(
            child: Text("Send us your problem",
                style: ConstFonts().copyWithTitle(fontSize: 20))),
        content: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: height * 0.4, maxWidth: width - 50),
          child: SingleChildScrollView(
            child: Column(
              children: options.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        isSelected[entry.key] = !isSelected[entry.key];
                      });
                    },
                    child: Row(
                      children: [
                        CheckboxTheme(
                          data: CheckboxThemeData(
                            side: BorderSide(
                              color: ConstColors.tertiaryColor,
                              width: 2.0,
                            ),
                          ),
                          child: Checkbox(
                            activeColor: ConstColors.primaryColor,
                            value: isSelected[entry.key],
                            onChanged: (value) {
                              setState(() {
                                isSelected[entry.key] = value ?? false;
                              });
                            },
                          ),
                        ),
                        Flexible(
                            child: Text(entry.value,
                                style: ConstFonts()
                                    .copyWithSubHeading(fontSize: 16))),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              InstanceManager().showSnackBar(
                  context: context,
                  text: isSelected.contains(true)
                      ? "Send successfully"
                      : "Choose at least 1 problem to report");
            },
            child: Button(
                width: 100,
                height: 40,
                color: ConstColors.tertiaryContainerColor,
                isCircle: false,
                child: Text(
                  'Send',
                  style: ConstFonts().copyWithTitle(fontSize: 16),
                )).getButton(),
          ),
        ],
      );
    });
  }

  static Widget changePasswordDialog() {
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    bool isHidePassword = true;

    String? validate(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your information';
      }
      return null;
    }

    String? validateNewPassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your information';
      } else if (value.length < 6) {
        return 'New password must be at least 6 characters';
      }
      if (newPasswordController.text != confirmPasswordController.text) {
        return 'Password does not match';
      }
      return null;
    }

    return StatefulBuilder(builder: (context, StateSetter setState) {
      Widget hidePasswordButton() {
        return IconButton(
            onPressed: () {
              setState(() {
                isHidePassword = !isHidePassword;
              });
            },
            icon: Icon(
              isHidePassword ? Icons.visibility_off : Icons.visibility,
              color: ConstColors.textFormFieldColor,
            ));
      }

      return AlertDialog(
        backgroundColor: ConstColors.secondaryColor,
        insetPadding: (ResponsiveInfo.isTablet())
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4)
            : EdgeInsets.symmetric(horizontal: 10),
        // backgroundColor: ConstColors.surfaceColor,
        icon: Icon(
          Icons.password_rounded,
          color: ConstColors.surfaceColor,
          size: 45,
        ),
        title: Text(
          'Change Password',
          style: ConstFonts()
              .copyWithTitle(fontSize: 20, color: ConstColors.surfaceColor),
        ),
        content: Form(
          key: formKeyChangePassword,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: TextStyle(color: ConstColors.textFormFieldColor),
                  validator: validate,
                  obscureText: isHidePassword,
                  decoration: ConstDecoration.inputDecoration(
                    hintText: 'Old password',
                    borderRadius: 30,
                    suffixIcon: hidePasswordButton(),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.lock_outline),
                    ),
                  ),
                  cursorColor: ConstColors.textFormFieldColor,
                  controller: oldPasswordController,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(color: ConstColors.textFormFieldColor),
                  validator: validateNewPassword,
                  obscureText: isHidePassword,
                  decoration: ConstDecoration.inputDecoration(
                      hintText: 'New password',
                      borderRadius: 30,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.lock_outline),
                      ),
                      suffixIcon: hidePasswordButton()),
                  cursorColor: ConstColors.textFormFieldColor,
                  controller: newPasswordController,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(color: ConstColors.textFormFieldColor),
                  validator: validateNewPassword,
                  obscureText: isHidePassword,
                  decoration: ConstDecoration.inputDecoration(
                      hintText: 'Confirm password',
                      borderRadius: 30,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.lock_outline),
                      ),
                      suffixIcon: hidePasswordButton()),
                  cursorColor: ConstColors.textFormFieldColor,
                  controller: confirmPasswordController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () async {
                if (formKeyChangePassword.currentState!.validate()) {
                  ChangePasswordApi changePasswordApi = ChangePasswordApi(
                      changePasswordModel: ChangePasswordModel(
                          passwordOld: oldPasswordController.text,
                          passwordNew: newPasswordController.text,
                          userId: userDetail!.id ?? 0));
                  bool check = await changePasswordApi.call();
                  if (check) {
                    Navigator.pop(context);
                    InstanceManager().showSnackBar(
                        context: context, text: "Change password successfully");
                  } else {
                    InstanceManager().showSnackBar(
                        context: context, text: "Change password failed");
                  }
                }
              },
              child: Button(
                  width: MediaQuery.of(context).size.width - 20,
                  height: (ResponsiveInfo.isTablet() &&
                          MediaQuery.of(context).size.width <
                              MediaQuery.of(context).size.height)
                      ? MediaQuery.of(context).size.height * 0.04
                      : MediaQuery.of(context).size.height * 0.065,
                  color: ConstColors.primaryColor,
                  isCircle: false,
                  child: Text(
                    'Save',
                    style: ConstFonts().copyWithTitle(fontSize: 16),
                  )).getButton(),
            ),
          )
        ],
      );
    });
  }

  static Widget updateProfileDialog() {
    UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();
    addressController.text =
        (userDetail != null) ? userDetail.address ?? "" : "";
    phoneController.text = (userDetail != null) ? userDetail.phone ?? "" : "";
    emailController.text = (userDetail != null) ? userDetail.email ?? "" : "";

    return StatefulBuilder(builder: (context, StateSetter setState) {
      // Widget hidePasswordButton(){
      //   return IconButton(
      //       onPressed: (){
      //         setState((){
      //           isHidePassword = !isHidePassword;
      //         });
      //       },
      //       icon: Icon(isHidePassword?Icons.visibility_off:Icons.visibility,color: ConstColors.onSecondaryContainerColor,)
      //   );
      // }
      return AlertDialog(
        insetPadding: (ResponsiveInfo.isTablet())
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4)
            : EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: ConstColors.secondaryColor,
        icon: Icon(
          Icons.person_pin,
          color: ConstColors.surfaceColor,
          size: 45,
        ),
        title: Text(
          L10nX.getStr.your_profile,
          style: ConstFonts()
              .copyWithTitle(fontSize: 20, color: ConstColors.surfaceColor),
        ),
        content: Form(
          key: formKeyUpdateProfile,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: TextStyle(color: ConstColors.textFormFieldColor),
                  // initialValue: (userDetail != null) ? userDetail.address??"" : "",
                  decoration: ConstDecoration.inputDecoration(
                    hintText: L10nX.getStr.address,
                    borderRadius: 30,
                  ),
                  cursorColor: ConstColors.textFormFieldColor,
                  controller: addressController,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(color: ConstColors.textFormFieldColor),
                  // initialValue: (userDetail != null) ? userDetail.phone??"" : "",
                  decoration: ConstDecoration.inputDecoration(
                    hintText: L10nX.getStr.phone_number,
                    borderRadius: 30,
                  ),
                  cursorColor: ConstColors.textFormFieldColor,
                  controller: phoneController,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(color: ConstColors.textFormFieldColor),
                  // initialValue: (userDetail != null) ? userDetail.email??"" : "",
                  decoration: ConstDecoration.inputDecoration(
                    hintText: L10nX.getStr.email,
                    borderRadius: 30,
                  ),
                  cursorColor: ConstColors.textFormFieldColor,
                  controller: emailController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                // if(formKeyUpdateProfile.currentState!.validate()){
                Navigator.pop(context);
                InstanceManager().showSnackBar(
                    context: context, text: "Update profile successfully");
                // }
              },
              child: Button(
                  width: MediaQuery.of(context).size.width - 20,
                  height: (ResponsiveInfo.isTablet() &&
                          MediaQuery.of(context).size.width <
                              MediaQuery.of(context).size.height)
                      ? MediaQuery.of(context).size.height * 0.04
                      : MediaQuery.of(context).size.height * 0.065,
                  color: ConstColors.primaryColor,
                  isCircle: false,
                  child: Text(
                    'Save',
                    style: ConstFonts().copyWithTitle(fontSize: 16),
                  )).getButton(),
            ),
          )
        ],
      );
    });
  }

  static Widget stopTrackingDialog(
      {required Function() onTapOutSide,
      required Function() onTapYesButton,
      required Function() onTapNoButton}) {
    return PopScope(
      onPopInvoked: (value) {
        onTapOutSide;
      },
      child: AlertDialog(
        backgroundColor: ConstColors.tertiaryContainerColor,
        icon: const Icon(
          Icons.location_off_rounded,
          color: Colors.white,
          size: 45,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              L10nX.getStr.stop_tracking_title,
              style: ConstFonts().copyWithTitle(fontSize: 19),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(L10nX.getStr.stop_tracking_message,
                style: ConstFonts().copyWithSubHeading(fontSize: 15)),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        actions: [
          Button(
              width: 105,
              height: 47,
              color: ConstColors.errorContainerColor,
              isCircle: false,
              child: TextButton(
                onPressed: onTapNoButton,
                child: Text(L10nX.getStr.no,
                    style: ConstFonts().copyWithTitle(fontSize: 16)),
              )).getButton(),
          const SizedBox(
            width: 20,
          ),
          Button(
              width: 105,
              height: 47,
              color: ConstColors.primaryColor,
              isCircle: false,
              child: TextButton(
                onPressed: onTapYesButton,
                child: Text(L10nX.getStr.yes,
                    style: ConstFonts().copyWithTitle(fontSize: 16)),
              )).getButton(),
        ],
      ),
    );
  }
}
