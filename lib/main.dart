// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:holidays/screens/empauth/emp_home.dart';
import 'package:holidays/screens/empauth/home.dart';
import 'package:holidays/screens/empauth/forgotpass.dart';
import 'package:holidays/screens/empauth/login.dart';
import 'package:holidays/screens/empauth/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:holidays/screens/splashscreen.dart';
import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:holidays/viewmodel/employee/empuserviewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // var directory = await getApplicationDocumentsDirectory();
  //  Hive.init(directory.path);
  await Hive.initFlutter();
  await Hive.openBox('box');

  runApp(const MyApp1());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CompanyViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => EmpViewModel(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          title: 'Holiday Request',
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
            primarySwatch: Colors.red,
          ),
          home: SplashScreen(),
          routes: {
            EmpForgitPassword.idScreen: (context) => EmpForgitPassword(),
            EmpLoginPage.routeName: (context) => EmpLoginPage(),
            SignupPage.idScreen: (context) => SignupPage(),
            HomePage.routeName: (context) => HomePage()
          },
        ));
  }
}
