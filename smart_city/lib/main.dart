import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:smart_city/base/common/responsive_info.dart';
import 'package:smart_city/base/resizer/fetch_pixel.dart';
import 'package:smart_city/base/routes/routes.dart';
import 'package:smart_city/base/store/cached_storage.dart';
import 'package:smart_city/controller/helper/map_helper.dart';
import 'package:smart_city/controller/vehicles_bloc/vehicles_bloc.dart';
import 'package:get/get.dart';
import 'package:smart_city/mqtt_manager/MQTT_client_manager.dart';
import 'package:smart_city/view/map/component/notification_screen.dart';
import 'package:smart_city/view/splash_screen.dart';
import 'generated/l10n.dart';
import 'helpers/localizations/app_notifier.dart';
import 'helpers/localizations/bloc/main_bloc.dart';
import 'helpers/localizations/language_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'helpers/services/navigation_service.dart';
import 'l10n/l10n_extention.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialService();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //FirebaseMessaging.onBackgroundMessage((_)=>FirebaseManager.getInstance.firebaseMessagingBackgroundHandler(_));
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(
            create: (_) => MainBloc(MainState(mainStatus: MainStatus.initial))
              ..add(MainInitEvent()))
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AppNotifier>(
              create: (context) => AppNotifier()),
        ],
        builder: (context, child) {
          return MyApp();
        },
      )));
}

Future<void> initialService() async {
  await MapHelper.getInstance().getPermission();
  await MapHelper.getInstance().getCurrentLocation();
  await SharedPreferencesStorage().initSharedPreferences();
  await getNotificationPermission();
  MQTTManager().initialMQTT();
  //FirebaseManager.getInstance.initialFirebase();
}

Future<void> getNotificationPermission() async {
  // Android 13+, you need to allow notification permission to display foreground service notification.
  //
  // iOS: If you need notification, ask for permission.
  final NotificationPermission notificationPermission =
      await FlutterForegroundTask.checkNotificationPermission();
  if (notificationPermission != NotificationPermission.granted) {
    await FlutterForegroundTask.requestNotificationPermission();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      FlutterForegroundTask.initCommunicationPort();
    return WithForegroundTask(
      child: BlocConsumer<MainBloc, MainState>(listener: (context, state) {
        switch (state.mainStatus) {
          case MainStatus.initial:
            break;
          case MainStatus.onchangeLanguage:
            state.mainStatus = MainStatus.unKnown;
            Get.updateLocale(LanguageHelper().getCurrentLocale());
            break;
          case MainStatus.unKnown:
            break;
          case MainStatus.onEnableDarkMode:
            // TODO: Handle this case.
            state.mainStatus = MainStatus.unKnown;
            break;
        }
      }, builder: (BuildContext context, state) {
        return GetMaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          localizationsDelegates: const [
            S.delegate,
            L10nX.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LanguageHelper()
              .supportedLanguages
              .map((language) => (language.scripCode == null)
                  ? Locale(language.languageCode!, language.country!)
                  : Locale.fromSubtags(
                      languageCode: language.languageCode!,
                      countryCode: language.country!,
                      scriptCode: language.scripCode))
              .toList(),
          locale: LanguageHelper().getCurrentLocale(),
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
      
            return supportedLocales.first;
          },
          home: const SplashScreen(),
          builder: (context, child) {
            EasyLoading.init();
            NavigationService.registerContext(context, update: true);
            return ScreenTypeLayout.builder(
              key: Key(LanguageHelper().getCurrentLocale().languageCode),
              mobile: (_) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
                ResponsiveInfo().init(context);
                FetchPixel(context);
                return BlocProvider(
                  create: (_) => VehiclesBloc(),
                  child: MaterialApp.router(
                    routerConfig: router,
                  ),
                );
              },
              tablet: (_) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
                ResponsiveInfo().init(context);
                FetchPixel(context);
                return BlocProvider(
                  create: (context) => VehiclesBloc(),
                  child: MaterialApp.router(
                    routerConfig: router,
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
