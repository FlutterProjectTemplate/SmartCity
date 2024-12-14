import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/model/user/user_detail.dart';
import 'package:smart_city/view/intro_screen.dart';
import 'package:smart_city/view/login/forgot_password/forgot_password_ui.dart';
import 'package:smart_city/view/login/login_ui_welcome_back.dart';
import 'package:smart_city/view/login/register/register_ui.dart';
import 'package:smart_city/view/setting/setting_ui.dart';
import 'package:smart_city/view/splash_screen.dart';
import 'package:smart_city/view/login/login_ui.dart';
import 'package:smart_city/view/map/map_ui.dart';

import '../../controller/stopwatch_bloc/stopwatch_bloc.dart';
import '../../controller/vehicles_bloc/vehicles_bloc.dart';
import '../../model/user/user_info.dart';
import '../../view/map/map_bloc/map_bloc.dart';
import '../../view/setting/component/profile_screen.dart';
import '../sqlite_manager/sqlite_manager.dart';

UserInfo? userInfo = SqliteManager().getCurrentLoginUserInfo();
UserDetail? userDetail = SqliteManager().getCurrentLoginUserDetail();

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const IntroScreen(),
      redirect: (context, state) async {
        final bool isFirstUsingApp = await SharedPreferenceData
            .getHaveFirstUsingApp();
        // return '/';
        if (isFirstUsingApp) {
          return '/';
        } else {
          return '/splash';
        }
      },
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'map',
      path: '/map',
      builder: (context, state) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => MapBloc()),
        BlocProvider(create: (_) => StopwatchBloc()),
        BlocProvider(create: (_) => VehiclesBloc()..add(OnVehicleInitEventEvent())),
      ],child: MapUi()),
      routes: [
        GoRoute(
          path: 'setting',
          builder: (context, state) {
            final vehicleBloc = state.extra as VehiclesBloc?;
            return SettingUi(vehiclesBloc: vehicleBloc);
          },
          routes: [
            GoRoute(
              path: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/welcomeBackSignIn',
      builder: (context, state) => LoginUiWelcomeBack(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginUi(),
      redirect: (context, state) async {
        bool isSignedInOneTime = await SharedPreferenceData.isCheckUserSignedIn();
        if (isSignedInOneTime) {
          return '/welcomeBackSignIn';
        } else {
          return '/login';
        }
      },
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: LoginUi(),
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterUi(),
    ),
    GoRoute(
      path: '/forgot-password/:phone',
      builder: (context, state) {
        final phone = state.pathParameters['phone'];
        return ForgotPassword(phoneNumber: phone ?? '');
      },
    )
  ],
);
