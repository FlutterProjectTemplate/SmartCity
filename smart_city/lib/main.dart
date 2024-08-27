import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_city/base/routes/routes.dart';
import 'package:smart_city/base/store/cached_storage.dart';
import 'package:smart_city/controller/helper/map_helper.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initialService();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //FirebaseMessaging.onBackgroundMessage((_)=>FirebaseManager.getInstance.firebaseMessagingBackgroundHandler(_));
  runApp(const App());
}

Future<void> initialService()async {
  await MapHelper.getInstance().getPermission();
  MapHelper.getInstance().getCurrentLocation();
  await SharedPreferencesStorage().initSharedPreferences();
  //FirebaseManager.getInstance.initialFirebase();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}


