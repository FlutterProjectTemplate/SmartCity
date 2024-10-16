import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_decoration.dart';
import 'package:smart_city/constant_value/const_fonts.dart';

class CustomAlertDialog{
  static final formKeyForgotPassword = GlobalKey<FormState>();
  static final forgotPasswordController = TextEditingController();
  static final oldPasswordController = TextEditingController();
  static final newPasswordController = TextEditingController();
  static final confirmPasswordController = TextEditingController();
  static final formKeyChangePassword = GlobalKey<FormState>();
  static Widget forgotPasswordDialog(){

    String? validateMobile(String? value) {
      String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
      RegExp regExp = RegExp(pattern);
      if (value == null||value.isEmpty) {
        return 'Please enter mobile number';
      }
      else if (!regExp.hasMatch(value)) {
        return 'Please enter valid mobile number';
      }
      return null;
    }
    return StatefulBuilder(
      builder: (context,setState) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: ConstColors.surfaceColor,
          icon: Image.asset("assets/password.png",height:50,width:50,),
          iconPadding: const EdgeInsets.symmetric(vertical: 10),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Forgot Password',style: ConstFonts().copyWithTitle(fontSize: 19),),
              const SizedBox(height: 10,),
              Text('We will send you OTP verification to you',style: ConstFonts().copyWithSubHeading(fontSize: 15)),
              const SizedBox(height: 5,),
            ],
          ),
          content: Form(
            key: formKeyForgotPassword,
            child: TextFormField(
              controller: forgotPasswordController,
              validator: validateMobile,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: ConstDecoration.inputDecoration(hintText: "Phone number",borderRadius: 30),
              cursorColor: ConstColors.onSecondaryContainerColor,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: (){
                if(formKeyForgotPassword.currentState!.validate()){
                  context.push('/forgot-password/${forgotPasswordController.text}');
                  forgotPasswordController.clear();
                }else{
                  debugPrint("Validation failed");
                }
              },
              child: Button(
                width: MediaQuery.of(context).size.width-20,
                height: MediaQuery.of(context).size.height*0.065,
                isCircle: false,
                color: ConstColors.primaryColor,
                child: Text('Send me the code',style: ConstFonts().title)
              ).getButton(),
            ),
          ],
          actionsPadding: EdgeInsets.only(left:20,right:20,bottom: MediaQuery.of(context).size.height*0.04),
        );
      }
    );
  }

  static Widget reportDialog(){
    String? selectedOption;
    final List<String> options = ['Can\'t display map', 'Can\'t start tracking','Can\'t stop tracking','Control commands are not responded to','The map is not currently tracking with your current location' ];
    final List<bool> isSelected = List.generate(options.length, (index) => false);

    return StatefulBuilder(
        builder: (context,StateSetter setState){
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
          return AlertDialog(
            backgroundColor: ConstColors.surfaceColor,
            title: Center(child: Text("Send us your problem",style: ConstFonts().copyWithTitle(fontSize: 20))),
            content: Flexible(
              // height: height*0.4,
              // width: width-50,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height*0.4,
                  maxWidth: width-50
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: options.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isSelected[entry.key] = !isSelected[entry.key];
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                shape: const CircleBorder(),
                                value: isSelected[entry.key],
                                onChanged: (value) {
                                  setState(() {
                                    isSelected[entry.key] = value ?? false;
                                  });
                                },
                              ),
                              Flexible(child: Text(entry.value,style: ConstFonts().copyWithSubHeading(fontSize: 16))),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  InstanceManager().showSnackBar(context: context, text: isSelected.contains(true)?"Send successfully":"Choose at least 1 problem to report");
                },
                child: Button(
                    width: 100,
                    height: 40,
                    color: ConstColors.primaryColor,
                    isCircle: false,
                    child:Text('Send',style: ConstFonts().copyWithTitle(fontSize: 16),)
                ).getButton(),
              ),
            ],
          );
        }
    );
  }

  static Widget changePasswordDialog(){
    bool isHidePassword = true;

    String? validate(String? value){
      if (value == null || value.isEmpty) {
        return 'Please enter your information';
      }
      return null;
    }

    String? validateNewPassword(String? value){
      if (value == null || value.isEmpty) {
        return 'Please enter your information';
      }else if(value.length<6){
        return 'New password must be at least 6 characters';}
      if(newPasswordController.text!=confirmPasswordController.text){
        return 'Password does not match';
      }
      return null;
    }

    return StatefulBuilder(
      builder: (context,StateSetter setState){
        Widget hidePasswordButton(){
          return IconButton(
            onPressed: (){
              setState((){
                isHidePassword = !isHidePassword;
              });
            },
            icon: Icon(isHidePassword?Icons.visibility_off:Icons.visibility,color: ConstColors.onSecondaryContainerColor,)
          );
        }
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: ConstColors.surfaceColor,
          icon: const Icon(Icons.password_rounded,color: Colors.white,size:45,),
          title: Text('Change Password',style: ConstFonts().copyWithTitle(fontSize: 20),),
          content: Form(
            key: formKeyChangePassword,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: validate,
                  obscureText: isHidePassword,
                  decoration: ConstDecoration.inputDecoration(hintText: 'Old password',borderRadius: 30,suffixIcon: hidePasswordButton(),),
                  cursorColor: ConstColors.onSecondaryContainerColor,
                  controller: oldPasswordController,
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  validator: validateNewPassword,
                  obscureText: isHidePassword,
                  decoration: ConstDecoration.inputDecoration(hintText: 'New password',borderRadius: 30,suffixIcon: hidePasswordButton()),
                  cursorColor: ConstColors.onSecondaryContainerColor,
                  controller: newPasswordController,
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  validator: validateNewPassword,
                  obscureText: isHidePassword,
                  decoration: ConstDecoration.inputDecoration(hintText: 'Confirm password',borderRadius: 30,suffixIcon: hidePasswordButton()),
                  cursorColor: ConstColors.onSecondaryContainerColor,
                  controller: confirmPasswordController,
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: GestureDetector(
                onTap: (){
                  if(formKeyChangePassword.currentState!.validate()){
                    Navigator.pop(context);
                    InstanceManager().showSnackBar(context: context, text: "Change password successfully");
                  }
                },
                child: Button(
                    width: MediaQuery.of(context).size.width-20,
                    height: MediaQuery.of(context).size.height*0.065,
                    color: ConstColors.primaryColor,
                    isCircle: false,
                    child:Text('Save',style: ConstFonts().copyWithTitle(fontSize: 16),)
                ).getButton(),
              ),
            )
          ],
        );
      }
    );
  }

  static Widget stopTrackingDialog({required Function() onTapOutSide,required Function() onTapYesButton,required Function() onTapNoButton}){
    return PopScope(
      onPopInvoked: (value){
        onTapOutSide;
      },
      child: AlertDialog(
        icon: const Icon(Icons.location_off_rounded,color: Colors.white,size: 45,),
        title:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Stop tracking',style: ConstFonts().copyWithTitle(fontSize: 19),),
            const SizedBox(height: 5,),
            Text('Are you sure you want to stop?',style: ConstFonts().copyWithSubHeading(fontSize: 15)),
            const SizedBox(height: 5,),
          ],
        ),
        backgroundColor: ConstColors.surfaceColor,
        actions: [
          Button(
              width: 105, height: 47,
              color:ConstColors.errorContainerColor,
              isCircle: false,
              child:TextButton(
                onPressed: onTapNoButton,
                child: Text("No",style: ConstFonts().copyWithTitle(fontSize: 16)),
              )
          ).getButton(),
          const SizedBox(width: 20,),
          Button(
              width: 105, height: 47,
              color:ConstColors.primaryColor,
              isCircle: false,
              child:TextButton(
                onPressed: onTapYesButton,
                child: Text("Yes",style: ConstFonts().copyWithTitle(fontSize: 16)),
              )
          ).getButton(),
        ],
      ),
    );
  }

}