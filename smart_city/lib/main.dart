import 'package:flutter/material.dart';
import 'package:smart_city/base/routes/routes.dart';
import 'package:smart_city/base/store/cached_storage.dart';
import 'base/firebase_manager/firebase_manager.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  //await initialService();
  //FirebaseMessaging.onBackgroundMessage((_)=>FirebaseManager.getInstance.firebaseMessagingBackgroundHandler(_));
  runApp(const MyApp());
}

Future<void> initialService()async {
  await SharedPreferencesStorage().initSharedPreferences();
  FirebaseManager.getInstance.initialFirebase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

