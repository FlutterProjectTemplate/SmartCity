import 'package:flutter/material.dart';
import 'package:smart_city/constant_value/const_colors.dart';
import 'package:smart_city/constant_value/const_fonts.dart';

class InstanceManager{
  static final InstanceManager _singletonBlocManager = InstanceManager._internal();
  static InstanceManager get getInstance => _singletonBlocManager;
  factory InstanceManager() {
    return _singletonBlocManager;
  }
  InstanceManager._internal();

  String _errorLoginMessage = 'Authentication Failure';
  String get errorLoginMessage => _errorLoginMessage;
  void setErrorLoginMessage(String message){
    _errorLoginMessage = message;
  }

  void showSnackBar({required BuildContext context,required String text}){
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
          SnackBar(content: Text(text,style: ConstFonts().copyWithTitle(fontSize: 16),),
            backgroundColor: ConstColors.surfaceColor,
          ));
  }
}