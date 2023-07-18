// ignore_for_file: prefer_const_literals_to_create_immutables, unused_field, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'package:holidays/screens/empauth/profile.dart';
import 'package:holidays/viewmodel/employee/empuserviewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/companyLogin.dart';
import 'package:http/http.dart' as http;
import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/constants.dart';
import '../../widget/popuploader.dart';
import 'package:velocity_x/velocity_x.dart';

import 'forgotpass.dart';
import 'otpscreen.dart';

class EmpLoginPage extends StatefulWidget {
  static const routeName = "login";
  @override
  _EmpLoginPageState createState() => _EmpLoginPageState();
}

class _EmpLoginPageState extends State<EmpLoginPage> {
  bool obsCheck = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<void> performLogin() async {
    const String apiUrl = 'https://jporter.ezeelogix.com/public/api/login';
    PopupLoader.show();

    final response = await http.post(Uri.parse(apiUrl), body: {
      'email': _emailController.text,
      'password': _passwordController.text,
      'user_type': '2'
    });
    PopupLoader.hide();

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'Success') {
        final user = jsonData['data']['user'];
        final token = jsonData['data']['token'];

        // User data
        final userId = user['id'];
        final firstName = user['first_name'];
        final lastName = user['last_name'];
        final phone = user['phone'];
        final email = user['email'];

        // Store user data in shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', userId.toString());
        prefs.setString('firstName', firstName);
        prefs.setString('lastName', lastName);
        prefs.setString('phone', phone);
        prefs.setString('email', email);

        // Token
        print('Token: $token');
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => EmpProfileView()));
        print('');

        // Navigate to the next screen or perform any desired action
        print(jsonData);
      } else {
        // Login failed
        Fluttertoast.showToast(
            msg: "Verify your email through OTP sent to your email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => EmpOtpScreen(
                      email: _emailController.text,
                    )));
        print('');
      }
    } else {
      Fluttertoast.showToast(
          msg: "wrong userCridentials ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('Error: ${response.reasonPhrase}');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 14.0;
      title = 22;
      heading = 30; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 16.0;
      title = 25;

      heading = 24; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 18.0;
      title = 27;

      heading = 28; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 20.0;
      title = 30;

      heading = 30; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 34;

      heading = 30; // Extra large screen or unknown device
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(CupertinoIcons.left_chevron, color: red),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Sign In Employee",
                    style:
                        TextStyle(fontSize: title, fontWeight: FontWeight.bold),
                  ).centered(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.black, fontSize: fontSize),
                  ).pSymmetric(h: 20).centered(),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    //keyboardType: TextInputType.visiblePassword,
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                            ),
                            child: const Icon(
                              Icons.email_outlined,
                              color: red,
                            )),
                      ),
                      labelText: 'Email Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0, color: Colors.black),
                                ),
                              ),
                              child: Icon(
                                Icons.lock_open_rounded,
                                color: red,
                              )),
                        ),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obsCheck = !obsCheck;
                              });
                            },
                            icon: Icon(
                              obsCheck
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ))),
                    obscureText: !obsCheck,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.black, fontSize: fontSize),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(EmpForgitPassword.idScreen);
                        },
                      )),
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        Provider.of<EmpViewModel>(context, listen: false)
                            .performLogin(email, password, context);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: red, borderRadius: BorderRadius.circular(10)),
                      height: screenheight / 15,
                      width: screenWidth - 100,
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                              color: Colors.white, fontSize: fontSize),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       if (_formKey.currentState!.validate()) {
                  //         final email = _emailController.text;
                  //         final password = _passwordController.text;

                  //         Provider.of<EmpViewModel>(context, listen: false)
                  //             .performLogin(email, password, context);
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: red,
                  //       padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //     child: Text(
                  //       'Sign In',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyLoginPage()),
                      );
                    },
                    child: const Text(
                      'Login as Company',
                      style: TextStyle(
                          decorationColor: Colors.red,
                          decoration: TextDecoration.underline,
                          color: Colors.red,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ).pSymmetric(h: 10),
          ),
        ),
      ),
    );
  }
}
