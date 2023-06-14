import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:holidays/screens/home.dart';
import 'package:holidays/userauth/forgotpass.dart';
import 'package:holidays/userauth/login.dart';
import 'package:holidays/userauth/signup.dart';
import 'firebase_options.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
          FirebaseAuth.instance.currentUser != null ? HomePage() : LoginPage(),
      routes: {
        ForgitPassword.idScreen: (context) => ForgitPassword(),
        LoginPage.routeName: (context) => LoginPage(),
        SignupPage.idScreen: (context) => SignupPage(),
        HomePage.routeName: (context) => HomePage()
      },
    );
  }
}
