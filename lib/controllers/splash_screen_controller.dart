import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whisperwave/utils/routes_name.dart';
import 'package:whisperwave/views/screens/auth/auth.dart';

class SplashScreenController {
  Future<void> isLogin(context) async {
    final isUserLoggedIn = await AuthMethods().getcurrentUser();
    if (isUserLoggedIn != null) {
      Navigator.pushReplacementNamed(context, RouteName.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, RouteName.signInScreen);
    }
  }
}
