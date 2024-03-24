import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/routes.dart';
import '../utils/routes_name.dart';

class SplashScreenController {
  void isLogin(context) {
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        Routes.generateRoute(
          const RouteSettings(
            name: RouteName.signInScreen,
          ),
        ),
      ),
    );
  }
}
