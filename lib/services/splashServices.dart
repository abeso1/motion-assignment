import 'dart:async';
import 'package:assignment/pages/mapPage.dart';
import 'package:flutter/material.dart';

class SplashServices {
  static splashInitialization(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MapPage()));
    });
  }
}
