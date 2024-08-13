import 'package:flutter/material.dart';
class InstanceManager{
  static final InstanceManager _singletonBlocManager = InstanceManager._internal();
  static InstanceManager get getInstance => _singletonBlocManager;
  factory InstanceManager() {
    return _singletonBlocManager;
  }
  InstanceManager._internal();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  BuildContext ?rootContext;
}