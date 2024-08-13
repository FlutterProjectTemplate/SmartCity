import 'package:connectivity_plus/connectivity_plus.dart';

class InternetCheckerHandler{
  static final InternetCheckerHandler _singletonInternetCheckerHandler = InternetCheckerHandler._internal();
  static InternetCheckerHandler get getInstance => _singletonInternetCheckerHandler;
  factory InternetCheckerHandler() {
    return _singletonInternetCheckerHandler;
  }
  InternetCheckerHandler._internal();

  Future<bool> checkConnectionInternet() async{
    final connectivityResult = await (Connectivity().checkConnectivity());
    bool isConnectionInternet = true;
    if(connectivityResult.isEmpty) {
      return false;
    }
    if (connectivityResult.first == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult.first == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else if (connectivityResult.first == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
    } else if (connectivityResult.first == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult.first == ConnectivityResult.bluetooth) {
      // I am connected to a bluetooth.
    } else if (connectivityResult.first == ConnectivityResult.other) {
      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult.first == ConnectivityResult.none) {
      // I am not connected to any network.
      isConnectionInternet = false;
    }
    if(!isConnectionInternet)
    {
      //TODO : Implement the code to show the dialog
    }
    return isConnectionInternet;
  }
}