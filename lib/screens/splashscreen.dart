import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

import 'onboarding.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return EasySplashScreen(
      logo: Image.asset(
        "assets/images/logo.png",
        width: size.width / 1.6,
        height: size.height / 5,
        fit: BoxFit.cover,
      ),
      title: const Text(
        "Holiday Request",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      showLoader: true,
      loaderColor: Theme.of(context).primaryColor,
      loadingText: const Text("Loading"),
      navigator: const OnboardScreen(),
      durationInSeconds: 5,
    );
  }
}
