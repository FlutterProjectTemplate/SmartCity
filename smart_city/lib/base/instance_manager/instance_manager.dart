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
}