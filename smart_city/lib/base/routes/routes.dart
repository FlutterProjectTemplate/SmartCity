import 'package:go_router/go_router.dart';
import 'package:smart_city/base/store/shared_preference_data.dart';
import 'package:smart_city/view/login/forgot_password/forgot_password_ui.dart';
import 'package:smart_city/view/login/login_ui_welcome_back.dart';
import 'package:smart_city/view/setting/setting_ui.dart';
import 'package:smart_city/view/splash_screen.dart';
import 'package:smart_city/view/welcome_screen.dart';
import 'package:smart_city/view/login/login_ui.dart';
import 'package:smart_city/view/map/map_ui.dart';

import '../../view/setting/component/profile_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
      redirect: (context, state) async {
        final bool isFirstUsingApp =
            await SharedPreferenceData.getHaveFirstUsingApp();
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
        builder: (context, state) => const MapUi(),
        routes: [
          GoRoute(
              path: 'setting',
              builder: (context, state) => const SettingUi(),
              routes: [
                GoRoute(
                  path: 'profile',
                  builder: (context, state) {
                    return const ProfileScreen();
                  },
                )
              ]),
          // GoRoute(
          //   path: 'notification',
          //   builder: (context, state) => MqttScreen(),
          // ),
        ]),
    GoRoute(
      path: '/welcomeBackSignIn',
      builder: (context, state) => LoginUiWelcomeBack(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginUi(),
      redirect: (context, state) async {
        bool isSignedInOneTime =
            await SharedPreferenceData.isCheckUserSignedIn();
        if (isSignedInOneTime) {
          return '/welcomeBackSignIn';
        } else {
          return '/login';
        }
      },
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

