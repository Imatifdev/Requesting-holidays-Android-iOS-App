import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:holidays/screens/dashboard.dart';
import 'package:holidays/screens/home.dart';
import 'package:holidays/screens/splashscreen.dart';
import 'package:holidays/screens/testingscreen.dart';
import 'package:holidays/screens/userauth/forgotpass.dart';
import 'package:holidays/screens/userauth/login.dart';
import 'package:holidays/screens/userauth/profile.dart';
import 'package:holidays/screens/userauth/signup.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: LeaveScreen(),
      routes: {
        ForgitPassword.idScreen: (context) => ForgitPassword(),
        LoginPage.routeName: (context) => LoginPage(),
        SignupPage.idScreen: (context) => SignupPage(),
        HomePage.routeName: (context) => HomePage()
      },
    );
  }
}
