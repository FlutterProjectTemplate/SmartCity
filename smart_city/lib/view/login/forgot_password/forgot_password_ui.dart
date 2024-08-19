import 'package:flutter/material.dart';
import 'package:smart_city/base/widgets/button.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_decoration.dart';
import 'package:smart_city/constant_value/const_fonts.dart';
import 'package:smart_city/controller/map_helper/sms_retriever_otp.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:pinput/pinput.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key,required this.phoneNumber});
  final String phoneNumber;
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final SmsRetrieverOTP smsRetriever;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    smsRetriever = SmsRetrieverOTP(SmartAuth());
    super.initState();
  }

  @override
  void dispose(){
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int phoneNumberLength = widget.phoneNumber.length;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ConstColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: ConstColors.surfaceColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: ConstColors.secondaryColor,size: 30,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Text('Confirm your number code',textAlign: TextAlign.center,style: ConstFonts().copyWithHeading(fontSize: 22),),
          const SizedBox(height: 10,),
          Text('Enter the code we sent to the number ending ${widget.phoneNumber.substring(phoneNumberLength-4,phoneNumberLength)}',
            textAlign: TextAlign.center,
            style: ConstFonts().copyWithSubHeading(fontSize: 16),),
          SizedBox(height: height*0.05,),
          Pinput(
            length: 6,
            focusNode: focusNode,
            controller: pinController,
            smsRetriever: smsRetriever,
            defaultPinTheme: ConstDecoration.defaultPinTheme(65, width*0.25),
            validator: (value){
              if(value == null ||value.isEmpty){
                return 'Please enter the code';
              }else if(value != '123456'){
                return 'Wrong code, please try again';
              }else{
                return null;
              }
            },
            focusedPinTheme: ConstDecoration.focusedPinTheme(65, width*0.25),
            submittedPinTheme: ConstDecoration.summitedPinTheme(65, width*0.25),
            errorPinTheme: ConstDecoration.errorPinTheme(65, width*0.25),
          ),
          const SizedBox(height: 20,),
          TextButton(
            onPressed: (){},
            child: Text('Send code again',style: ConstFonts().copyWithTitle(fontSize: 20),),
          ),
          SizedBox(height: height*0.23,),
          Button(
            width: width-20,
            height: height*0.065,
            color: ConstColors.primaryColor,
            isCircle: false,
            child: TextButton(
              onPressed: (){},
              child: Text('Confirm',style: ConstFonts().title),
            ),
          ).getButton(),
        ],
      ),
    );
  }
}
