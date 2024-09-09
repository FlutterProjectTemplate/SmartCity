import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/resizer/fetch_pixel.dart';
import 'package:smart_city/base/routes/routes.dart';
import 'package:smart_city/base/store/cached_storage.dart';
import 'package:smart_city/controller/helper/map_helper.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initialService();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //FirebaseMessaging.onBackgroundMessage((_)=>FirebaseManager.getInstance.firebaseMessagingBackgroundHandler(_));
  runApp(const App());
}

Future<void> initialService()async {
  await MapHelper.getInstance().getPermission();
  await MapHelper.getInstance().getCurrentLocation();
  await SharedPreferencesStorage().initSharedPreferences();
  //FirebaseManager.getInstance.initialFirebase();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_){
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        ResponsiveInfo().init(context);
        FetchPixel(context);
        return BlocProvider(
          create: (_)=>VehiclesBloc(),
          child: MaterialApp.router(
            routerConfig: routerMobile,
          ),
        );
      },
      tablet: (_){
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        ResponsiveInfo().init(context);
        FetchPixel(context);
        return MaterialApp.router(
          routerConfig: routerTablet,
        );
      },
    );
  }
}


