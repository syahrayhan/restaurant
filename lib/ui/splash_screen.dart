import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant/common/navigation.dart';
import 'package:restaurant/ui/main_bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
  static const routeName = '/splash_screen';
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigation.intentPushReplacement(MainBottomNavigation.routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/icons/ic_launcher.png',
            width: 140,
          ),
        ),
      ),
    );
  }
}
