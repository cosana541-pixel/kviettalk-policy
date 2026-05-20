import 'dart:async';

import 'package:flutter/material.dart';

import 'home_screen.dart';

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  static const _splashDuration = Duration(milliseconds: 1500);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_splashDuration, _openHomeScreen);
  }

  void _openHomeScreen() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFF7E8),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SizedBox.expand(
          child: Image(
            image: AssetImage('assets/images/splash_screen.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
