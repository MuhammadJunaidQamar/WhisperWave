import 'package:flutter/material.dart';
import 'package:WhisperWave/views/screens/home_screen.dart';
import 'package:WhisperWave/views/screens/auth/signin_screen.dart';
import 'package:WhisperWave/views/screens/auth/signup_screen.dart';
import '../views/screens/chat_screen.dart';
import '../views/screens/welcome/splash_screen.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case RouteName.signInScreen:
        return MaterialPageRoute(builder: (context) => const SignInScreen());

      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case RouteName.chatScreen:
        return MaterialPageRoute(builder: (context) => const ChatScreen());

      case RouteName.signUpScreen:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());

      default:
        return MaterialPageRoute(
          builder: ((context) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          }),
        );
    }
  }
}
