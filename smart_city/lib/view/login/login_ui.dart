import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/constant_value/const_decoration.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hint = true;
  String? email,password,forgotPassword;
  final _formKey = GlobalKey<FormState>();
  final _formKeyForgotPassword = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _forgotPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height:height*0.15,),
                          Image.asset('assets/scs-logo.png',height: height*0.1,width:width*0.3,),
                          SizedBox(height:height*0.02,),
                          Text('Sign in',style: ConstFonts().copyWithHeading(fontSize: 35),),
                          SizedBox(height:height*0.08,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: validate,
                              controller: _emailController,
                              decoration: ConstDecoration.inputDecoration(hintText: "User name/Email/Phone number"),
                              cursorColor: ConstColors.onSecondaryContainerColor,
                              onChanged: (value){
                                email = value;
                              },
                            ),
                          ),
                          SizedBox(height:height*0.03,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: validate,
                              controller: _passwordController,
                              decoration: ConstDecoration.inputDecoration(hintText: "Password"),
                              cursorColor: ConstColors.onSecondaryContainerColor,
                              onChanged: (value){
                                password = value;
                              },
                              obscureText: hint,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: TextButton(
                                  onPressed: (){
                                    _showForgotPasswordDialog();
                                  },
                                  child: Text('Forgot password?',style: ConstFonts().copyWithSubHeading(color: Colors.white,fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                          Button(
                            width: width-50,
                            height: height*0.06,
                            color: ConstColors.primaryColor,
                            isCircle: false,
                            child: TextButton(
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  context.go('/map');
                                }else{
                                  debugPrint("Validation failed");
                                }
                              },
                              child: Text('Sign in',style: ConstFonts().title),
                            ),
                          ).getButton(),
                          SizedBox(height: height*0.04,),
                          Text("Or sign in with",style: ConstFonts().copyWithTitle(fontSize: 18),),
                          IconButton(
                              onPressed: (){},
                              icon: Image.asset("assets/fingerprint.png",height: 50,width: 50,)
                          )
                        ],
                      ),
                    ]),
              )
          ),
        )
    );
  }

  Future<void> _showForgotPasswordDialog() async{
    showDialog(
        context: context,
        builder: (_){
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
              key: _formKeyForgotPassword,
              child: TextFormField(
                controller: _forgotPasswordController,
                onChanged: (value){
                  forgotPassword = value;
                },
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
              Button(
                width: MediaQuery.of(context).size.width-20,
                height: MediaQuery.of(context).size.height*0.065,
                isCircle: false,
                color: ConstColors.primaryColor,
                child: TextButton(
                  onPressed: (){
                    if(_formKeyForgotPassword.currentState!.validate()){
                      context.go('/login/forgot-password/${forgotPassword!}');
                      _forgotPasswordController.clear();
                    }else{
                      debugPrint("Validation failed");
                    }
                  },
                  child: Text('Send me the code',style: ConstFonts().title),
                ),
              ).getButton(),
            ],
            actionsPadding: EdgeInsets.only(left:20,right:20,bottom: MediaQuery.of(context).size.height*0.04),
          );
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

  String? validate(String? value){
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }
}
