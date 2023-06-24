// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:holidays/screens/dashboard.dart';
import 'package:holidays/screens/companyauth/resetpass.dart';
import 'package:holidays/screens/empauth/leaverequest.dart';
import 'package:holidays/screens/empauth/profile.dart';
import 'package:holidays/screens/empauth/test1.dart';

import 'package:holidays/screens/home.dart';
import 'package:holidays/screens/empauth/forgotpass.dart';
import 'package:holidays/screens/empauth/login.dart';
import 'package:holidays/screens/empauth/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:holidays/screens/onboarding.dart';
import 'package:holidays/screens/testingscreen.dart';
import 'package:holidays/tst.dart';
import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:holidays/viewmodel/employee/empuserviewmodel.dart';
import 'package:provider/provider.dart';

import 'screens/request_leave.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // var directory = await getApplicationDocumentsDirectory();
  //   Hive.init(directory.path);
  await Hive.initFlutter();
  await Hive.openBox('box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
            primarySwatch: Colors.red,
          ),
          home: CompanyLoginPage(),
          routes: {
            EmpForgitPassword.idScreen: (context) => EmpForgitPassword(),
            EmpLoginPage.routeName: (context) => EmpLoginPage(),
            SignupPage.idScreen: (context) => SignupPage(),
            HomePage.routeName: (context) => HomePage()
          },
        ));
  }
}
