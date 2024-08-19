import 'package:go_router/go_router.dart';
import 'package:smart_city/view/login/forgot_password/forgot_password_ui.dart';
import 'package:smart_city/view/splash_screen.dart';
import 'package:smart_city/view/login/login_ui.dart';
import 'package:smart_city/view/map/map_ui.dart';

final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: 'map',
        path: '/map',
        builder: (context, state) => const MapUi(),
      ),
      GoRoute(
          path: '/login',
          builder: (context, state) => const Login(),
          routes: [
            GoRoute(
              path: 'forgot-password/:phone',
              builder: (context, state) {
                final phone = state.pathParameters['phone'];
                return ForgotPassword(phoneNumber: phone??'');
              },
            )
          ]
      )
]
);