// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/compforgotpass.dart';

import '../../widget/constants.dart';
import '../../widget/custombutton.dart';
import '../../widget/textinput.dart';
import 'package:http/http.dart' as http;

class CompanyForgitPassword extends StatefulWidget {
  static const String idScreen = 'forgotpass';

  const CompanyForgitPassword({super.key});

  @override
  State<CompanyForgitPassword> createState() => _CompanyForgitPasswordState();
}

class _CompanyForgitPasswordState extends State<CompanyForgitPassword> {
  final TextEditingController _email = TextEditingController();
  //key for handling Auth
  bool _isOTPSent = false;
  bool _isOTPSuccessful = false;

  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  // Future<void> _forgotpass() async {
  //   final url = 'https://jporter.ezeelogix.com/public/api/forgot-password';

  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Accept': 'application/json',
  //     },
  //     body: {
  //       'email': _email.toString(),
  //       'user_type': '1',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _isOTPSent = true;
  //     });
  //   } else {
  //     print(response.body);

  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text(response.body.toString()),
  //         content: Text('Failed to send OTP. Please try again.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
  Future<void> _forgotpass(String email) async {
    final url = 'https://jporter.ezeelogix.com/public/api/forgot-password';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'user_type': '1',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);

      // Navigator.push(context,
      //     MaterialPageRoute(builder: (ctx) => CompanyForgotPasswordScreen()));
    } else {
      print(response.body);
    }
  }

  Future<void> _forgotpass1(String email) async {
    final url = 'https://jporter.ezeelogix.com/public/api/forgot-password';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'user_type': '1',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final status = responseData['status'];
      print(response.body);

      if (status == 'Error') {
        print(response.body);

        final errorMessage = responseData['message'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage != null
                ? errorMessage.toString()
                : 'Failed to send password reset email.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print(response.body);

        // Navigate to the desired screen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => CompanyResetPasswordScreen(
                    email: email,
                  )),
        );
      }
    } else {
      print(response.body);

      final responseData = jsonDecode(response.body);
      final errorMessage = responseData['message'];
      print(response.body);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage != null
              ? errorMessage.toString()
              : 'Failed to send password reset email.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showetoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                ),
                const Text(
                  "Forgot Your Password",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                    validator: (value) {
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    textEditingController: _email,
                    hintText: "Enter Your Email",
                    textInputType: TextInputType.visiblePassword),
                const SizedBox(
                  height: 30,
                ),
                MyCustomButton(
                    buttontextcolr: Colors.white,
                    title: "Send Forgot Pass Request",
                    borderrad: 25,
                    onaction: () {
                      _forgotpass1(_email.text);
                      // if (formGlobalKey.currentState!.validate()) {
                      //   _showetoast("Details Send to your email");
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (ctx) => ForgotPasswordScreen(
                      //                 email: _email.text,
                      //               )));
                      // } else
                      //   _showetoast("Please a valid email address");
                    },
                    color1: red,
                    color2: red,
                    width: MediaQuery.of(context).size.width - 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
