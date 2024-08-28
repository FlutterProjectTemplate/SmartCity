import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:smart_city/base/instance_manager/instance_manager.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/base/widgets/custom_alert_dialog.dart';
import 'package:smart_city/constant_value/const_decoration.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/model/user/user_info.dart';
import 'package:smart_city/view/login/login_bloc/login_bloc.dart';

class LoginUiWelcomeBack extends StatelessWidget {
  LoginUiWelcomeBack({super.key});

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isHidePassword = true;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_)=>LoginBloc(),
      child: BlocListener<LoginBloc,LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            InstanceManager().showSnackBar(context: context, text: InstanceManager().errorLoginMessage);
          }else if(state.status == LoginStatus.success){
            context.go('/map');
          }
        },
        child: Scaffold(
            body:Form(
              key: _formKey,
              child: SizedBox(
                  width: width,
                  height: height,
                  child: SingleChildScrollView(
                    child:
                    Stack(
                        children:[
                          Image.asset('assets/background_mobile.png',height:height,width: width,fit: BoxFit.fill,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height:height*0.2,),
                              Image.asset('assets/scs-logo.png',height: height*0.08,width:width*0.25,),
                              SizedBox(height:height*0.02,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20,bottom: 5),
                                child: Text('Welcome back to Citiez',style: ConstFonts().copyWithHeading(fontSize: 28),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Your journey awaits,sign in to start",style:ConstFonts().copyWithSubHeading(fontSize: 17),),
                              ),
                              SizedBox(height:height*0.04,),
                              StatefulBuilder(
                                builder: (context,StateSetter setState){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: TextFormField(
                                      validator: (value){
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your information';
                                        }
                                        return null;
                                      },
                                      controller: _passwordController,
                                      decoration: ConstDecoration.inputDecoration(
                                          hintText: "Password",
                                          suffixIcon: IconButton(
                                              onPressed: (){
                                                setState((){
                                                  isHidePassword = !isHidePassword;
                                                });
                                              },
                                              icon: Icon(isHidePassword?Icons.visibility:Icons.visibility_off,color: ConstColors.onSecondaryContainerColor,)
                                          )
                                      ),
                                      cursorColor: ConstColors.onSecondaryContainerColor,
                                      obscureText: isHidePassword,
                                    ),
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: TextButton(
                                      onPressed: (){
                                        _showForgotPasswordDialog(context);
                                      },
                                      child: Text('Forgot password?',style: ConstFonts().copyWithSubHeading(color: Colors.white,fontSize: 16)),
                                    ),
                                  ),
                                ],
                              ),
                              BlocBuilder<LoginBloc,LoginState>(
                                  builder: (context,state){
                                    if(state.status == LoginStatus.loading){
                                      return Center(
                                        child: LoadingAnimationWidget.staggeredDotsWave(
                                            color: ConstColors.primaryColor,
                                            size: 45),
                                      );
                                    }
                                    return Center(
                                      child: GestureDetector(
                                        onTap: ()async{
                                          UserInfo? userInfo = await SqliteManager().getCurrentLoginUserInfo();
                                          if(_formKey.currentState!.validate()){
                                            context.read<LoginBloc>().add(
                                              LoginSubmitted(
                                                userInfo!.username??"",
                                                _passwordController.text,
                                              ),
                                            );
                                          }else{
                                            debugPrint("Validation failed");
                                          }
                                        },
                                        child: Button(
                                          width: width-50,
                                          height: height*0.06,
                                          color: ConstColors.primaryColor,
                                          isCircle: false,
                                          child:Text('Sign in',style: ConstFonts().title),
                                        ).getButton(),
                                      ),
                                    );
                                  }
                              ),
                              SizedBox(height: height*0.04,),
                              Center(
                                child: Text('Or sign in with',style: ConstFonts().copyWithSubHeading(fontSize: 18),),
                              ),
                              Center(
                                child: IconButton(
                                    onPressed: ()async{
                                      bool turnOnSignInBiometric = await SharedPreferenceData.checkSignInBiometric();
                                      if(turnOnSignInBiometric){
                                        bool authenticated = await SqliteManager.getInstance.authenticate();
                                        if(authenticated){
                                          await SharedPreferenceData.setLogIn();
                                          context.go('/map');
                                        }else{
                                          InstanceManager().showSnackBar(context: context, text: 'Authentication Biometric Failure');
                                        }
                                      }else{
                                        QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.error,
                                            title: 'Oops...',
                                            text: 'Sorry, you don\'t enable biometric sign in yet',
                                            confirmBtnColor: ConstColors.primaryColor
                                        );
                                      }
                                    },
                                    icon: Image.asset("assets/fingerprint.png",height: 50,width: 50,)
                                ),
                              )
                            ],
                          ),
                        ]),
                  )
              ),
            )
        ),
      ),
    );
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async{
    showDialog(
        context: context,
        builder: (_){
          return CustomAlertDialog.forgotPasswordDialog();
        }
    );
  }

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

}
